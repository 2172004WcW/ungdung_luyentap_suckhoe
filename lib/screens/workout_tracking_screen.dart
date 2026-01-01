import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm thư viện này để format ngày tháng
import '../models/workout_session.dart';
import '../data/exercise_library.dart';
import '../services/storage_service.dart';
import 'workout_active_screen.dart';
import '../models/handbook_topic.dart';
import '../services/handbook_firestore_service.dart';
import 'handbook_detail_screen.dart';
import 'exercise_list_screen.dart';

class WorkoutTrackingScreen extends StatefulWidget {
  final String userId;
  const WorkoutTrackingScreen({super.key, required this.userId});

  @override
  State<WorkoutTrackingScreen> createState() => _WorkoutTrackingScreenState();
}

class _WorkoutTrackingScreenState extends State<WorkoutTrackingScreen> {
  int _selectedIndex = 0;
  DateTime _selectedDate = DateTime.now(); // Ngày đang được chọn trên lịch

  String _formatDuration(WorkoutSession s) {
    final totalSec = s.durationSeconds ?? (s.durationMinutes * 60);
    final m = totalSec ~/ 60;
    final sec = totalSec % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  // Hàm lấy màu sắc đại diện cho nhóm cơ để phân biệt
  Color _getMuscleColor(String title) {
    if (title.contains('Ngực')) return Colors.redAccent;
    if (title.contains('Lưng')) return Colors.blueAccent;
    if (title.contains('Chân')) return Colors.greenAccent;
    if (title.contains('Tay')) return Colors.orangeAccent;
    if (title.contains('Bụng')) return Colors.purpleAccent;
    if (title.contains('Cardio')) return Colors.pinkAccent;
    return const Color(0xFF1AB7B0); // Màu mặc định
  }

  void _showSessionDetails(WorkoutSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
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
                  session.workoutPlanName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _infoTag(Icons.timer_outlined, _formatDuration(session)),
                    const SizedBox(width: 8),
                    _infoTag(
                      Icons.local_fire_department_outlined,
                      '${session.caloriesBurned ?? 0} kcal',
                    ),
                    const SizedBox(width: 8),
                    _infoTag(
                      Icons.calendar_today_outlined,
                      DateFormat('HH:mm').format(session.date),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Chi tiết bài tập',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...session.exercises.map(
                  (we) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getMuscleColor(
                          session.workoutPlanName,
                        ).withOpacity(0.1),
                        child: Icon(
                          Icons.fitness_center,
                          color: _getMuscleColor(session.workoutPlanName),
                          size: 18,
                        ),
                      ),
                      title: Text(
                        we.exercise.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${we.sets.length} hiệp tập'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: Colors.grey[800], fontSize: 13)),
        ],
      ),
    );
  }

  void _startNewWorkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutActiveScreen(userId: widget.userId),
      ),
    ).then((result) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tập luyện',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: _selectedIndex == 2
            ? const Color(0xFF1AB7B0)
            : Colors.white,
        foregroundColor: _selectedIndex == 2 ? Colors.white : Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _startNewWorkout,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [_buildTodayTab(), _buildHistoryTab(), _buildLibraryTab()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Hôm nay',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Lịch sử',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: 'Thư viện',
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    return Column(
      children: [
        _buildCalendarStrip(), // Thanh lịch ngang
        Expanded(
          child: FutureBuilder<List<WorkoutSession>>(
            future: StorageService.loadWorkoutSessionsFromFirebase(
              userId: widget.userId,
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());

              final filteredSessions = snapshot.data!
                  .where(
                    (s) =>
                        s.date.year == _selectedDate.year &&
                        s.date.month == _selectedDate.month &&
                        s.date.day == _selectedDate.day,
                  )
                  .toList();

              if (filteredSessions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_note, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Không có hoạt động ngày ${DateFormat('dd/MM').format(_selectedDate)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredSessions.length,
                itemBuilder: (context, index) {
                  final session = filteredSessions[index];
                  final color = _getMuscleColor(session.workoutPlanName);
                  return _buildWorkoutCard(session, color);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget Thanh lịch ngang
  Widget _buildCalendarStrip() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14, // Hiển thị 14 ngày gần nhất
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final date = DateTime.now().subtract(Duration(days: index));
          final isSelected =
              date.day == _selectedDate.day &&
              date.month == _selectedDate.month;

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1AB7B0)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget thẻ buổi tập được thiết kế lại
  Widget _buildWorkoutCard(WorkoutSession session, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
        border: Border(
          left: BorderSide(color: color, width: 6),
        ), // Vạch màu phân biệt
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          session.workoutPlanName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                DateFormat('HH:mm').format(session.date),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 12),
              Icon(Icons.timer_outlined, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatDuration(session),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.chevron_right, color: color),
        ),
        onTap: () => _showSessionDetails(session),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return FutureBuilder<List<WorkoutSession>>(
      future: StorageService.loadWorkoutSessionsFromFirebase(
        userId: widget.userId,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final sessions = snapshot.data!
          ..sort((a, b) => b.date.compareTo(a.date));
        if (sessions.isEmpty)
          return const Center(child: Text('Chưa có lịch sử tập luyện'));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            final color = _getMuscleColor(session.workoutPlanName);
            return _buildWorkoutCard(session, color);
          },
        );
      },
    );
  }

  Widget _buildLibraryTab() {
    return StreamBuilder<List<HandbookTopic>>(
      stream: HandbookFirestoreService().topicsStream(),
      builder: (context, snapshot) {
        final topics = snapshot.data ?? <HandbookTopic>[];
        if (topics.isEmpty)
          return const Center(child: CircularProgressIndicator());

        HandbookTopic? exerciseTopic = topics.firstWhere(
          (t) =>
              (t.title ?? '').toLowerCase().contains('bài tập') ||
              (t.title ?? '').toLowerCase().contains('bai tap'),
          orElse: () => topics.first,
        );

        return HandbookDetailScreen(
          topicId: exerciseTopic.id,
          initialTopic: exerciseTopic,
          showAppBar: false,
        );
      },
    );
  }
}
