import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/exercise.dart';
import '../models/workout_session.dart';
import '../models/streak.dart';
import '../data/exercise_library.dart';
import '../services/storage_service.dart';
import '../services/streak_service.dart';
import 'exercise_start_page.dart';

class WorkoutActiveScreen extends StatefulWidget {
  final String userId;
  const WorkoutActiveScreen({super.key, required this.userId});

  @override
  State<WorkoutActiveScreen> createState() => _WorkoutActiveScreenState();
}

class _WorkoutActiveScreenState extends State<WorkoutActiveScreen>
    with WidgetsBindingObserver {
  final List<WorkoutExercise> _exercises = [];
  DateTime? _startTime;
  Timer? _timer;
  Timer? _bgExercisesTimer;
  int _elapsedSeconds = 0;
  bool _timerRunning = false;
  final Map<int, _RunState> _runStates = {};
  DateTime? _bgTimestamp;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startBackgroundTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _bgExercisesTimer?.cancel();
    super.dispose();
  }

  void _startBackgroundTimer() {
    _bgExercisesTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      bool anyExerciseRunning = false;

      _runStates.forEach((index, state) {
        if (state.running) {
          anyExerciseRunning = true;
          if (state.remain > 0) {
            state.remain--;
          } else {
            if (state.inWork) {
              if (state.currentSet >= _exercises[index].sets.length - 1) {
                state.running = false;
                state.remain = 0;
              } else {
                state.inWork = false;
                state.remain = state.restSec;
              }
            } else {
              state.currentSet++;
              state.inWork = true;
              state.remain = state.workSec;
            }
          }
        }
      });

      if (!anyExerciseRunning && _timerRunning) {
        _pauseGlobalTimer();
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _bgTimestamp = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_bgTimestamp != null) {
        final gap = DateTime.now().difference(_bgTimestamp!).inSeconds;
        setState(() {
          if (_timerRunning) _elapsedSeconds += gap;
          _runStates.forEach((idx, runState) {
            if (runState.running) _syncGapForState(runState, gap, idx);
          });
        });
      }
    }
  }

  void _syncGapForState(_RunState state, int gap, int idx) {
    int tempGap = gap;
    while (tempGap > 0) {
      if (state.remain > tempGap) {
        state.remain -= tempGap;
        tempGap = 0;
      } else {
        tempGap -= state.remain;
        if (state.inWork) {
          if (state.currentSet >= _exercises[idx].sets.length - 1) {
            state.running = false;
            state.remain = 0;
            return;
          }
          state.inWork = false;
          state.remain = state.restSec;
        } else {
          state.currentSet++;
          state.inWork = true;
          state.remain = state.workSec;
        }
      }
    }
  }

  void _startTimer() {
    if (_timerRunning) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
    _timerRunning = true;
  }

  void _pauseGlobalTimer() {
    _timer?.cancel();
    _timer = null;
    _timerRunning = false;
  }

  String _fmt(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // --- UI Helpers ---
  Color _getMuscleColor(String? muscle) {
    switch (muscle) {
      case 'Ngực':
        return Colors.redAccent;
      case 'Lưng':
        return Colors.blueAccent;
      case 'Chân':
        return Colors.greenAccent;
      case 'Cơ bụng':
        return Colors.orangeAccent;
      default:
        return const Color(0xFF1AB7B0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Buổi tập đang diễn ra',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Header Timer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'TỔNG THỜI GIAN',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _fmt(_elapsedSeconds),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _exercises.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      final we = _exercises[index];
                      final state = _runStates[index];
                      return _buildExerciseCard(we, state, index);
                    },
                  ),
          ),

          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có bài tập nào được thêm',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(WorkoutExercise we, _RunState? state, int index) {
    bool isFinished =
        state != null &&
        !state.running &&
        state.remain == 0 &&
        state.currentSet >= we.sets.length - 1;
    Color muscleColor = _getMuscleColor(we.exercise.muscleGroup);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isFinished ? Colors.green : muscleColor,
                width: 6,
              ),
            ),
          ),
          child: ExpansionTile(
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(
              we.exercise.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: _buildCardSubtitle(state, we, isFinished),
            trailing: _buildCardTrailing(state, we, index, isFinished),
            children: [
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Số hiệp', '${we.sets.length}'),
                    _buildStatColumn(
                      'Nhóm cơ',
                      we.exercise.muscleGroup ?? 'Tự do',
                    ),
                    _buildStatColumn(
                      'Trạng thái',
                      isFinished
                          ? 'Xong'
                          : (state?.running == true ? 'Đang tập' : 'Chờ'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCardSubtitle(
    _RunState? state,
    WorkoutExercise we,
    bool isFinished,
  ) {
    if (isFinished) {
      return const Text(
        'Hoàn thành xuất sắc!',
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
      );
    }
    if (state != null && state.running) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: state.inWork ? Colors.red[50] : Colors.orange[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              state.inWork ? 'TẬP' : 'NGHỈ',
              style: TextStyle(
                color: state.inWork ? Colors.red : Colors.orange,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Hiệp ${state.currentSet + 1} • Còn ${state.remain}s',
            style: const TextStyle(
              color: Color(0xFF1AB7B0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    return Text(
      '${we.sets.length} hiệp • Chờ bắt đầu',
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildCardTrailing(
    _RunState? state,
    WorkoutExercise we,
    int index,
    bool isFinished,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFinished)
          IconButton(
            icon: Icon(
              state?.running == true
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              size: 36,
            ),
            color: const Color(0xFF1AB7B0),
            onPressed: () => _autoRunExercise(
              we,
              state?.workSec ?? 30,
              state?.restSec ?? 15,
              index: index,
            ),
          ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Colors.grey),
          onPressed: () => _addSet(we),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _addExercise,
              icon: const Icon(Icons.add_rounded),
              label: const Text('THÊM BÀI TẬP MỚI'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1AB7B0),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _finishWorkout,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent, width: 2),
                foregroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'KẾT THÚC VÀ LƯU BUỔI TẬP',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Logic functions giữ nguyên ---

  void _addExercise() {
    showDialog(
      context: context,
      builder: (context) => FutureBuilder(
        future: ExerciseLibrary.load(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const AlertDialog(
              content: SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }
          final groups = [
            'Ngực',
            'Lưng',
            'Chân',
            'Cơ mông',
            'Cơ delta',
            'Cơ tay trước',
            'Cơ tay sau',
            'Cẳng tay',
            'Cơ bụng',
            'Luyện tập chức năng',
            'Cardio',
            'Giãn cơ',
          ];
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Chọn bài tập'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: groups.length,
                itemBuilder: (context, i) => ExpansionTile(
                  title: Text(
                    groups[i],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: ExerciseLibrary.getByMuscleGroup(groups[i])
                      .map(
                        (exercise) => ListTile(
                          title: Text(exercise.name),
                          onTap: () {
                            Navigator.pop(context);
                            _showSetupQuickly(exercise);
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSetupQuickly(Exercise exercise) {
    final repsCtrl = TextEditingController(text: '10');
    final weightCtrl = TextEditingController(text: '');
    final workSecCtrl = TextEditingController(text: '30');
    final restSecCtrl = TextEditingController(text: '15');
    int setCount = 3;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateModal) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: weightCtrl,
                        decoration: InputDecoration(
                          labelText: 'Tạ (kg)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: repsCtrl,
                        decoration: InputDecoration(
                          labelText: 'Số lần',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Số hiệp tập:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => setStateModal(() {
                            if (setCount > 1) setCount--;
                          }),
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          '$setCount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setStateModal(() {
                            setCount++;
                          }),
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFF1AB7B0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: workSecCtrl,
                        decoration: InputDecoration(
                          labelText: 'Thời gian tập (s)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: restSecCtrl,
                        decoration: InputDecoration(
                          labelText: 'Thời gian nghỉ (s)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1AB7B0),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    final we = WorkoutExercise(
                      exercise: exercise,
                      sets: List.generate(
                        setCount,
                        (_) => ExerciseSet(
                          reps: int.tryParse(repsCtrl.text) ?? 10,
                          weight: double.tryParse(weightCtrl.text),
                        ),
                      ),
                    );
                    setState(() {
                      _exercises.add(we);
                      _startTime ??= DateTime.now();
                    });
                    Navigator.pop(ctx);
                    _autoRunExercise(
                      we,
                      int.tryParse(workSecCtrl.text) ?? 30,
                      int.tryParse(restSecCtrl.text) ?? 15,
                      index: _exercises.length - 1,
                    );
                  },
                  child: const Text(
                    'BẮT ĐẦU TẬP NGAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _autoRunExercise(
    WorkoutExercise we,
    int workSec,
    int restSec, {
    int? index,
  }) async {
    final idx = index ?? _exercises.indexOf(we);
    _startTimer();

    if (!_runStates.containsKey(idx)) {
      _runStates[idx] = _RunState(workSec: workSec, restSec: restSec);
    }
    setState(() => _runStates[idx]!.running = true);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseStartPage(
          we: we,
          index: idx,
          workSec: workSec,
          restSec: restSec,
          initialSet: _runStates[idx]!.currentSet,
          initialRemain: _runStates[idx]!.remain,
          initialInWork: _runStates[idx]!.inWork,
          onStopWorkout: _finishWorkout,
          onTimerUpdate: (s, r, iw) {
            setState(() {
              _runStates[idx]!.currentSet = s;
              _runStates[idx]!.remain = r;
              _runStates[idx]!.inWork = iw;
              if (s >= we.sets.length - 1 && r == 0 && iw == true) {
                _runStates[idx]!.running = false;
              }
            });
          },
        ),
      ),
    );
    setState(() {});
  }

  void _addSet(WorkoutExercise we) {
    setState(() {
      final last = we.sets.isNotEmpty ? we.sets.last : null;
      we.sets.add(ExerciseSet(reps: last?.reps ?? 10, weight: last?.weight));
    });
  }

  Future<void> _finishWorkout() async {
    if (_exercises.isEmpty) return;
    _pauseGlobalTimer();
    _bgExercisesTimer?.cancel();

    String sessionName = 'Buổi tập tự do';
    if (_exercises.isNotEmpty) {
      final muscles = _exercises
          .map((e) => e.exercise.muscleGroup)
          .where((m) => m != null && m.isNotEmpty)
          .toSet()
          .join(", ");
      if (muscles.isNotEmpty) sessionName = 'Buổi tập $muscles';
    }

    final session = WorkoutSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _startTime ?? DateTime.now(),
      workoutPlanName: sessionName,
      exercises: _exercises,
      durationMinutes: _elapsedSeconds ~/ 60,
      durationSeconds: _elapsedSeconds,
      caloriesBurned: (_elapsedSeconds ~/ 60) * 7,
    );

    await StorageService.saveWorkoutSessionToFirebase(
      userId: widget.userId,
      session: session,
    );

    final streakRef = FirebaseFirestore.instance
        .collection('streaks')
        .doc(widget.userId);
    final streakSnap = await streakRef.get();
    int newStreak = 1;
    if (streakSnap.exists && streakSnap.data() != null) {
      final old = Streak.fromJson(streakSnap.data()!);
      newStreak = StreakService.calculateNewStreak(
        old.currentStreak,
        old.lastActivityDate,
      );
    }
    await streakRef.set(
      Streak(
        currentStreak: newStreak,
        lastActivityDate: DateTime.now(),
      ).toJson(),
    );

    if (!mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}

class _RunState {
  int remain = 0;
  int currentSet = 0;
  bool inWork = true;
  bool running = false;
  late int workSec;
  late int restSec;
  _RunState({required int workSec, required int restSec}) {
    remain = workSec;
    this.workSec = workSec;
    this.restSec = restSec;
  }
}
