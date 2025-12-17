import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';
import '../models/workout_session.dart';
import '../models/nutrition_log.dart';
import '../models/health_stats.dart';

class StorageService {
  static const String _profileKey = 'user_profile';
  static const String _workoutSessionsKey = 'workout_sessions';
  static const String _nutritionLogsKey = 'nutrition_logs';
  static const String _healthStatsKey = 'health_stats';
  static const String _streakKey = 'streak';

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  // ================= PROFILE (LOCAL) =================
  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await _prefs;
    await prefs.setString(_profileKey, jsonEncode({
      'id': profile.id,
      'name': profile.name,
      'avatar': profile.avatar,
      'gender': profile.gender,
      'age': profile.age,
      'weight': profile.weight,
      'height': profile.height,
      'goal': profile.goal,
      'location': profile.location,
      'workoutPlan': profile.workoutPlan,
    }));
  }

  static Future<UserProfile?> loadProfile() async {
    final prefs = await _prefs;
    final data = prefs.getString(_profileKey);
    if (data == null) return null;

    final map = jsonDecode(data) as Map<String, dynamic>;
    return UserProfile(
      id: map['id'] as String? ?? 'temp_id_001',
      name: map['name'] as String? ?? 'Người dùng',
      avatar: map['avatar'] as String? ?? 'assets/onboarding/1.jpg',
      gender: map['gender'] as String? ?? 'Nam',
      age: map['age'] as int? ?? 20,
      weight: (map['weight'] as num?)?.toDouble() ?? 60,
      height: (map['height'] as num?)?.toDouble() ?? 170,
      goal: map['goal'] as String? ?? 'Giảm cân',
      location: map['location'] as String? ?? 'Tại nhà',
      workoutPlan: map['workoutPlan'] as String? ?? 'Chưa chọn',
    );
  }

  // ================= WORKOUT (LOCAL - để dự phòng / tránh lỗi cũ) =================
  static Future<void> saveWorkoutSession(WorkoutSession session) async {
    final prefs = await _prefs;
    final sessions = await loadWorkoutSessions();
    sessions.add(session);
    await prefs.setString(
      _workoutSessionsKey,
      jsonEncode(sessions.map((s) => s.toJson()).toList()),
    );
  }

  static Future<List<WorkoutSession>> loadWorkoutSessions() async {
    final prefs = await _prefs;
    final data = prefs.getString(_workoutSessionsKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list
        .map((e) => WorkoutSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ================= WORKOUT (FIREBASE) =================
  static Future<void> saveWorkoutSessionToFirebase({
    required String userId,
    required WorkoutSession session,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('workout_sessions')
        .doc(session.id)
        .set(session.toFirestore());
  }

  static Future<List<WorkoutSession>> loadWorkoutSessionsFromFirebase({
    required String userId,
  }) async {
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('workout_sessions')
        .orderBy('date', descending: true)
        .get();

    return snap.docs
        .map((d) => WorkoutSession.fromFirestore(d.data()))
        .toList();
  }

  // ================= NUTRITION (LOCAL) =================
  static Future<void> saveDailyNutrition(DailyNutrition nutrition) async {
    final prefs = await _prefs;
    final logs = await loadNutritionLogs();
    logs.removeWhere((log) =>
        log.date.year == nutrition.date.year &&
        log.date.month == nutrition.date.month &&
        log.date.day == nutrition.date.day);
    logs.add(nutrition);
    await prefs.setString(
      _nutritionLogsKey,
      jsonEncode(logs.map((l) => l.toJson()).toList()),
    );
  }

  static Future<List<DailyNutrition>> loadNutritionLogs() async {
    final prefs = await _prefs;
    final data = prefs.getString(_nutritionLogsKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list
        .map((e) => DailyNutrition.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ================= HEALTH STATS (LOCAL) =================
  static Future<void> saveHealthStats(HealthStats stats) async {
    final prefs = await _prefs;
    final allStats = await loadHealthStats();
    allStats.removeWhere((s) =>
        s.date.year == stats.date.year &&
        s.date.month == stats.date.month &&
        s.date.day == stats.date.day);
    allStats.add(stats);
    await prefs.setString(
      _healthStatsKey,
      jsonEncode(allStats.map((s) => s.toJson()).toList()),
    );
  }

  static Future<List<HealthStats>> loadHealthStats() async {
    final prefs = await _prefs;
    final data = prefs.getString(_healthStatsKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list
        .map((e) => HealthStats.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ================= STREAK (LOCAL - giữ nếu bạn cần) =================
  static Future<void> saveStreakLocal(Map<String, dynamic> streakJson) async {
    final prefs = await _prefs;
    await prefs.setString(_streakKey, jsonEncode(streakJson));
  }

  static Future<Map<String, dynamic>?> loadStreakLocal() async {
    final prefs = await _prefs;
    final data = prefs.getString(_streakKey);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  static Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}
