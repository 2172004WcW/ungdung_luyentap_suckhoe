import 'dart:async';
import 'package:flutter/material.dart';
import '../models/workout_session.dart';
import '../models/exercise.dart';

class ExerciseStartPage extends StatefulWidget {
  final WorkoutExercise we;
  final int index;
  final int workSec;
  final int restSec;
  final Future<void> Function() onStopWorkout;

  final int initialSet;
  final int initialRemain;
  final bool initialInWork;

  final Function(int currentSet, int remain, bool inWork) onTimerUpdate;

  const ExerciseStartPage({
    super.key,
    required this.we,
    required this.index,
    required this.workSec,
    required this.restSec,
    required this.onStopWorkout,
    required this.initialSet,
    required this.initialRemain,
    required this.initialInWork,
    required this.onTimerUpdate,
  });

  @override
  State<ExerciseStartPage> createState() => _ExerciseStartPageState();
}

class _ExerciseStartPageState extends State<ExerciseStartPage>
    with WidgetsBindingObserver {
  late int current;
  late int remain;
  late bool inWork;
  Timer? localTimer;
  DateTime? _bgTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    current = widget.initialSet;
    inWork = widget.initialInWork;
    remain = widget.initialRemain > 0 ? widget.initialRemain : widget.workSec;

    _startLocalTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    localTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _bgTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_bgTime != null) {
        final gap = DateTime.now().difference(_bgTime!).inSeconds;
        _syncGap(gap);
      }
    }
  }

  void _syncGap(int gap) {
    int tempGap = gap;
    while (tempGap > 0) {
      if (remain > tempGap) {
        setState(() => remain -= tempGap);
        tempGap = 0;
      } else {
        tempGap -= remain;
        if (inWork) {
          if (current >= widget.we.sets.length - 1) {
            localTimer?.cancel();
            remain = 0;
            widget.onTimerUpdate(current, 0, true);
            if (mounted) Navigator.pop(context);
            return;
          }
          inWork = false;
          remain = widget.restSec;
        } else {
          current++;
          if (current >= widget.we.sets.length) {
            localTimer?.cancel();
            if (mounted) Navigator.pop(context);
            return;
          }
          inWork = true;
          remain = widget.workSec;
        }
      }
    }
    widget.onTimerUpdate(current, remain, inWork);
  }

  void _startLocalTimer() {
    localTimer?.cancel();
    localTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (remain > 0) {
          remain--;
        } else {
          if (inWork) {
            if (current >= widget.we.sets.length - 1) {
              localTimer?.cancel();
              remain = 0;
              widget.onTimerUpdate(current, 0, true);
              Navigator.pop(context);
              return;
            }
            inWork = false;
            remain = widget.restSec;
          } else {
            current++;
            inWork = true;
            remain = widget.workSec;
          }
        }
      });
      widget.onTimerUpdate(current, remain, inWork);
    });
  }

  // Widget hiển thị lỗi khi không tìm thấy ảnh
  Widget _buildImageError() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
          SizedBox(height: 8),
          Text("Không tìm thấy ảnh", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _showExerciseInstructions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                widget.we.exercise.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // PHẦN SỬA LỖI HIỂN THỊ ẢNH Ở ĐÂY
              if (widget.we.exercise.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Builder(
                    builder: (context) {
                      final path = widget.we.exercise.imageUrl!;
                      if (path.startsWith('assets/')) {
                        return Image.asset(
                          path,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImageError(),
                        );
                      } else {
                        return Image.network(
                          path,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImageError(),
                        );
                      }
                    },
                  ),
                ),

              const SizedBox(height: 24),
              const Text(
                'Hướng dẫn thực hiện',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1AB7B0),
                ),
              ),
              const SizedBox(height: 12),
              if (widget.we.exercise.instructions != null &&
                  widget.we.exercise.instructions!.isNotEmpty)
                ...widget.we.exercise.instructions!.asMap().entries.map((
                  entry,
                ) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: const Color(
                            0xFF1AB7B0,
                          ).withOpacity(0.1),
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1AB7B0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()
              else
                const Text(
                  'Chưa có hướng dẫn chi tiết cho bài tập này.',
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSetData =
        widget.we.sets[current < widget.we.sets.length ? current : 0];
    final totalTime = inWork ? widget.workSec : widget.restSec;
    final progress = remain / totalTime;
    final themeColor = inWork ? const Color(0xFF1AB7B0) : Colors.orange;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.we.exercise.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF1AB7B0)),
            onPressed: _showExerciseInstructions,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSetIndicator(),
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 280,
                  height: 280,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      inWork ? 'TẬP' : 'NGHỈ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                        letterSpacing: 4,
                      ),
                    ),
                    Text(
                      '$remain',
                      style: const TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'giây',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            _buildInfoCard(currentSetData),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => widget.onStopWorkout(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                elevation: 0,
                side: const BorderSide(color: Colors.red, width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'DỪNG VÀ LƯU LẠI',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSetIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        'HIỆP ${current + 1} / ${widget.we.sets.length}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Color(0xFF1AB7B0),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildInfoCard(ExerciseSet setData) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(Icons.history_edu, '${setData.reps}', 'lần'),
          Container(width: 1.5, height: 40, color: Colors.grey[100]),
          _buildDetailItem(
            Icons.fitness_center_rounded,
            '${setData.weight ?? 0}',
            'kg',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String unit) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[400], size: 28),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(text: value),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
