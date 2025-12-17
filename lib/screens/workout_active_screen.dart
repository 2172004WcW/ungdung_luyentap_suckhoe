import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/exercise.dart';
import '../models/workout_session.dart';
import '../models/streak.dart';
import '../data/exercise_library.dart';
import '../services/storage_service.dart';
import '../services/streak_service.dart';

class WorkoutActiveScreen extends StatefulWidget {
  final String userId;
  const WorkoutActiveScreen({super.key, required this.userId});

  @override
  State<WorkoutActiveScreen> createState() => _WorkoutActiveScreenState();
}

class _WorkoutActiveScreenState extends State<WorkoutActiveScreen> {
  final List<WorkoutExercise> _exercises = [];
  DateTime? _startTime;
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ✅ HIỂN THỊ HƯỚNG DẪN BÀI TẬP (khi đang tập)
  void _showExerciseGuide(Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        final steps = exercise.instructions;
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip('Nhóm cơ: ${exercise.muscleGroup}'),
                      _chip('Dụng cụ: ${exercise.equipment}'),
                      _chip('Độ khó: ${exercise.difficulty}'),
                    ],
                  ),
                  const SizedBox(height: 14),

                  const Text('Mô tả', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(exercise.description),
                  const SizedBox(height: 16),

                  const Text('Các bước thực hiện', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  if (steps.isEmpty)
                    const Text('Chưa có hướng dẫn cho bài tập này.')
                  else
                    ...steps.asMap().entries.map((e) {
                      final i = e.key + 1;
                      final text = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1AB7B0).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$i',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1AB7B0),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(text)),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buổi tập đang diễn ra 🔥')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1AB7B0).withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, color: Color(0xFF1AB7B0)),
                const SizedBox(width: 8),
                Text(
                  _fmt(_elapsedSeconds),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1AB7B0),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _exercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('Chưa có bài tập nào', style: TextStyle(fontSize: 18, color: Colors.grey)),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _addExercise,
                          icon: const Icon(Icons.add),
                          label: const Text('Thêm bài tập'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1AB7B0),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      final we = _exercises[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          title: Text(we.exercise.name),
                          subtitle: Text('${we.sets.length} hiệp'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => setState(() => _exercises.removeAt(index)),
                          ),
                          children: [
                            // ✅ NÚT HƯỚNG DẪN (ngay trong lúc đang tập)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                              child: OutlinedButton.icon(
                                onPressed: () => _showExerciseGuide(we.exercise),
                                icon: const Icon(Icons.info_outline),
                                label: const Text('HƯỚNG DẪN THỰC HIỆN'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 44),
                                ),
                              ),
                            ),

                            ...we.sets.asMap().entries.map((entry) {
                              final setIndex = entry.key;
                              final set = entry.value;
                              return ListTile(
                                title: Text('Hiệp ${setIndex + 1}'),
                                subtitle: Text('${set.reps} lần${set.weight != null ? ' • ${set.weight}kg' : ''}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editSet(we, setIndex),
                                ),
                              );
                            }),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                onPressed: () => _addSet(we),
                                icon: const Icon(Icons.add),
                                label: const Text('Thêm hiệp'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1AB7B0),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: ElevatedButton.icon(
              onPressed: _addExercise,
              icon: const Icon(Icons.add),
              label: const Text('Thêm bài tập'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1AB7B0),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ElevatedButton(
              onPressed: _finishWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
              ),
              child: Text('KẾT THÚC BUỔI TẬP (${_fmt(_elapsedSeconds)})'),
            ),
          ),
        ],
      ),
    );
  }

  void _addExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn nhóm cơ'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final group in ['Ngực', 'Lưng', 'Chân', 'Tay', 'Vai', 'Bụng', 'Cardio'])
                ExpansionTile(
                  title: Text(group),
                  subtitle: Text('${ExerciseLibrary.getByMuscleGroup(group).length} bài tập'),
                  children: ExerciseLibrary.getByMuscleGroup(group).map((exercise) {
                    return ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(exercise.description),
                      onTap: () {
                        Navigator.pop(context);
                        _addExerciseToWorkout(exercise);
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _addExerciseToWorkout(Exercise exercise) {
    setState(() {
      _exercises.add(WorkoutExercise(
        exercise: exercise,
        sets: [ExerciseSet(reps: 10, weight: null)],
      ));
    });
  }

  void _addSet(WorkoutExercise we) {
    setState(() {
      final last = we.sets.isNotEmpty ? we.sets.last : null;
      we.sets.add(ExerciseSet(reps: last?.reps ?? 10, weight: last?.weight));
    });
  }

  void _editSet(WorkoutExercise we, int setIndex) {
    final set = we.sets[setIndex];
    final repsCtrl = TextEditingController(text: set.reps.toString());
    final weightCtrl = TextEditingController(text: set.weight?.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Chỉnh sửa hiệp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: repsCtrl,
              decoration: const InputDecoration(labelText: 'Số lần lặp'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weightCtrl,
              decoration: const InputDecoration(labelText: 'Trọng lượng (kg)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                we.sets[setIndex] = ExerciseSet(
                  reps: int.tryParse(repsCtrl.text) ?? 10,
                  weight: weightCtrl.text.isEmpty ? null : double.tryParse(weightCtrl.text),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _finishWorkout() async {
    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng thêm ít nhất một bài tập')),
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kết thúc buổi tập?'),
        content: Text('Bạn đã tập ${_elapsedSeconds ~/ 60} phút với ${_exercises.length} bài tập.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1AB7B0)),
            child: const Text('Kết thúc'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final session = WorkoutSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _startTime ?? DateTime.now(),
      workoutPlanName: 'Buổi tập tự do',
      exercises: _exercises,
      durationMinutes: _elapsedSeconds ~/ 60,
      durationSeconds: _elapsedSeconds,
      caloriesBurned: (_elapsedSeconds ~/ 60) * 7,
    );

    await StorageService.saveWorkoutSessionToFirebase(
      userId: widget.userId,
      session: session,
    );

    final streakRef = FirebaseFirestore.instance.collection('streaks').doc(widget.userId);
    final streakSnap = await streakRef.get();

    int newStreak;
    final lastDate = DateTime.now();

    if (streakSnap.exists && streakSnap.data() != null) {
      final old = Streak.fromJson(streakSnap.data()!);
      newStreak = StreakService.calculateNewStreak(old.currentStreak, old.lastActivityDate);
    } else {
      newStreak = 1;
    }

    await streakRef.set(Streak(currentStreak: newStreak, lastActivityDate: lastDate).toJson());

    if (!mounted) return;
    Navigator.pop(context, true);
  }
}
