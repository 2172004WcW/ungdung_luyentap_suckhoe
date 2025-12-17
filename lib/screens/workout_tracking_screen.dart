import 'package:flutter/material.dart';
import '../models/workout_session.dart';
import '../data/exercise_library.dart';
import '../services/storage_service.dart';
import 'workout_active_screen.dart';

class WorkoutTrackingScreen extends StatefulWidget {
  final String userId;
  const WorkoutTrackingScreen({super.key, required this.userId});

  @override
  State<WorkoutTrackingScreen> createState() => _WorkoutTrackingScreenState();
}

class _WorkoutTrackingScreenState extends State<WorkoutTrackingScreen> {
  int _selectedIndex = 0;

  String _formatDuration(WorkoutSession s) {
    final totalSec = s.durationSeconds ?? (s.durationMinutes * 60);
    final m = totalSec ~/ 60;
    final sec = totalSec % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  void _showSessionDetails(WorkoutSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.workoutPlanName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Thời gian: ${_formatDuration(session)}'),
                Text('Số bài tập: ${session.exercises.length}'),
                if (session.caloriesBurned != null) Text('Calo: ${session.caloriesBurned} kcal'),
                const SizedBox(height: 16),
                const Text('Danh sách bài tập', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...session.exercises.map((we) => Card(
                      child: ListTile(
                        title: Text(we.exercise.name),
                        subtitle: Text('${we.sets.length} hiệp'),
                      ),
                    )),
              ],
            ),
          );
        },
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
      if (result == true) {
        setState(() => _selectedIndex = 1);
      } else {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tập luyện'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _startNewWorkout),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildTodayTab(),
          _buildHistoryTab(),
          _buildLibraryTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
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
    return FutureBuilder<List<WorkoutSession>>(
      future: StorageService.loadWorkoutSessionsFromFirebase(userId: widget.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final today = DateTime.now();
        final todaySessions = snapshot.data!.where((s) =>
            s.date.year == today.year &&
            s.date.month == today.month &&
            s.date.day == today.day).toList();

        if (todaySessions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Chưa có buổi tập hôm nay', style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _startNewWorkout,
                  icon: const Icon(Icons.add),
                  label: const Text('Bắt đầu tập'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1AB7B0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: todaySessions.length,
          itemBuilder: (context, index) {
            final session = todaySessions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.fitness_center, color: Color(0xFF1AB7B0)),
                title: Text(session.workoutPlanName),
                subtitle: Text('${_formatDuration(session)} • ${session.exercises.length} bài'),
                onTap: () => _showSessionDetails(session),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return FutureBuilder<List<WorkoutSession>>(
      future: StorageService.loadWorkoutSessionsFromFirebase(userId: widget.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final sessions = snapshot.data!..sort((a, b) => b.date.compareTo(a.date));
        if (sessions.isEmpty) return const Center(child: Text('Chưa có lịch sử tập luyện'));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Color(0xFF1AB7B0)),
                title: Text(session.workoutPlanName),
                subtitle: Text('${_formatDuration(session)} • ${session.exercises.length} bài'),
                onTap: () => _showSessionDetails(session),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLibraryTab() {
    final muscleGroups = ['Ngực', 'Lưng', 'Chân', 'Tay', 'Vai', 'Bụng', 'Cardio'];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Thư viện bài tập', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...muscleGroups.map((group) {
          final exercises = ExerciseLibrary.getByMuscleGroup(group);
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text(group),
              subtitle: Text('${exercises.length} bài tập'),
              children: exercises.map((exercise) {
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Text(exercise.description),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}
