import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';
import '../models/workout_session.dart';
import '../models/nutrition_log.dart';
import '../models/streak.dart';

import 'workout_tracking_screen.dart';
import 'nutrition_tracking_screen.dart';

class DashboardScreen extends StatefulWidget {
  final UserProfile userProfile;
  const DashboardScreen({super.key, required this.userProfile});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadDashboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Lỗi: ${snapshot.error}'),
            ),
          );
        }

        final data = snapshot.data ?? {};
        final List<dynamic> rawWorkouts = data['todayWorkouts'] ?? [];
        final todayWorkouts = rawWorkouts.map((e) => e as WorkoutSession).toList();

        final todayNutrition = data['todayNutrition'] as DailyNutrition?;
        final streak = (data['streak'] as num?)?.toInt() ?? 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildStreakCard(streak),
              const SizedBox(height: 24),
              const Text('Hôm nay', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildStatsGrid(todayWorkouts, todayNutrition),
              const SizedBox(height: 24),
              _buildGoalCard(),
              if (todayWorkouts.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildWorkoutList(todayWorkouts),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Xin chào, ${widget.userProfile.name}!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(DateFormat('EEEE, dd MMMM yyyy', 'vi').format(DateTime.now()),
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
        CircleAvatar(
          radius: 30,
          backgroundImage: widget.userProfile.avatar.startsWith('assets/')
              ? AssetImage(widget.userProfile.avatar)
              : null,
          child: !widget.userProfile.avatar.startsWith('assets/')
              ? const Icon(Icons.person)
              : null,
        ),
      ],
    );
  }

  Widget _buildStreakCard(int streak) {
    return Card(
      color: const Color(0xFF1AB7B0).withOpacity(0.1),
      elevation: 0,
      child: ListTile(
        leading: const Icon(Icons.local_fire_department, color: Colors.orange, size: 32),
        title: const Text('Chuỗi ngày tập luyện', style: TextStyle(color: Colors.grey, fontSize: 13)),
        subtitle: Text('$streak ngày',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1AB7B0))),
      ),
    );
  }

  Widget _buildStatsGrid(List<WorkoutSession> workouts, DailyNutrition? nutrition) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Buổi tập',
                '${workouts.length}',
                Icons.fitness_center,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutTrackingScreen(userId: widget.userProfile.id),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Calo',
                nutrition?.totalCalories.toStringAsFixed(0) ?? '0',
                Icons.restaurant,
                Colors.orange,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NutritionTrackingScreen()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard('Bước chân', '0', Icons.directions_walk, Colors.green, null)),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Nước',
                nutrition != null ? '${(nutrition.waterIntake / 1000).toStringAsFixed(1)}L' : '0L',
                Icons.water_drop,
                Colors.cyan,
                null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, VoidCallback? onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard() {
    final heightM = widget.userProfile.height / 100;
    final bmi = heightM > 0 ? (widget.userProfile.weight / (heightM * heightM)) : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mục tiêu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.userProfile.goal),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [const Text('Cân nặng'), Text('${widget.userProfile.weight}kg', style: const TextStyle(fontWeight: FontWeight.bold))]),
                Column(children: [const Text('BMI'), Text(bmi.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold))]),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutList(List<WorkoutSession> workouts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Buổi tập hôm nay', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...workouts.map((s) => Card(
              child: ListTile(
                title: Text(s.workoutPlanName),
                subtitle: Text('${s.durationMinutes} phút'),
                trailing: const Icon(Icons.check_circle, color: Color(0xFF1AB7B0)),
              ),
            )),
      ],
    );
  }

  Future<Map<String, dynamic>> _loadDashboardData() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startTs = Timestamp.fromDate(startOfDay);
    final endTs = Timestamp.fromDate(startOfDay.add(const Duration(days: 1)));

    // ✅ Workouts hôm nay (đúng path bạn đang lưu)
    final workoutSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userProfile.id)
        .collection('workout_sessions')
        .where('date', isGreaterThanOrEqualTo: startTs)
        .where('date', isLessThan: endTs)
        .orderBy('date', descending: true)
        .get();

    // ✅ Streak
    int currentStreak = 0;
    try {
      final streakDoc = await FirebaseFirestore.instance
          .collection('streaks')
          .doc(widget.userProfile.id)
          .get();

      if (streakDoc.exists && streakDoc.data() != null) {
        final streak = Streak.fromJson(streakDoc.data()!);
        currentStreak = streak.currentStreak;
      }
    } catch (_) {}

    return {
      'todayWorkouts': workoutSnap.docs.map((d) => WorkoutSession.fromFirestore(d.data())).toList(),
      'streak': currentStreak,
      'todayNutrition': null,
      'weeklyStats': [],
    };
  }
}
