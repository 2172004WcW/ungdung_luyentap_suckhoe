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
    await prefs.setString(_profileKey, jsonEncode(profile.toMap()));
  }

  static Future<UserProfile?> loadProfile() async {
    final prefs = await _prefs;
    final data = prefs.getString(_profileKey);
    if (data == null) return null;

    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return UserProfile.fromFirestore(map, map['id'] ?? 'local_user');
    } catch (e) {
      print("Lỗi load profile local: $e");
      return null;
    }
  }

  // ================= WORKOUT (LOCAL) =================
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
    try {
      final list = jsonDecode(data) as List;
      return list
          .map((e) => WorkoutSession.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ================= WORKOUT (FIREBASE) =================
  static Future<void> saveWorkoutSessionToFirebase({
    required String userId,
    required WorkoutSession session,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('workout_sessions')
          .doc(session.id)
          .set(session.toFirestore());
    } catch (e) {
      print("Lỗi lưu workout lên Firebase: $e");
    }
  }

  static Future<List<WorkoutSession>> loadWorkoutSessionsFromFirebase({
    required String userId,
  }) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('workout_sessions')
          .orderBy('date', descending: true)
          .get();

      return snap.docs
          .map((d) => WorkoutSession.fromFirestore(d.data()))
          .toList();
    } catch (e) {
      print("Lỗi load workout từ Firebase: $e");
      return [];
    }
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
    try {
      final list = jsonDecode(data) as List;
      return list
          .map((e) => DailyNutrition.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
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
    try {
      final list = jsonDecode(data) as List;
      return list
          .map((e) => HealthStats.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ================= STREAK & UTILS =================
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

  // ================== TÍNH TOÁN THỐNG KÊ (NEW) ==================
  // Trả về Map gồm: {'calories': int, 'minutes': int, 'streak': int}
  static Future<Map<String, int>> getHomeStats(String userId) async {
    try {
      // 1. Lấy toàn bộ lịch sử tập luyện từ Firebase
      final sessions = await loadWorkoutSessionsFromFirebase(userId: userId);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day); 

      int todayCalories = 0;
      int todaySeconds = 0;
      
      // Dùng Set để lưu các ngày đã tập (tránh trùng lặp) cho việc tính Streak
      Set<String> uniqueDates = {};

      for (var session in sessions) {
        DateTime sDate = DateTime(session.date.year, session.date.month, session.date.day);
        
        // --- Tính Calo & Thời gian cho HÔM NAY ---
        if (sDate.isAtSameMomentAs(today)) {
          todayCalories += (session.caloriesBurned ?? 0);
          todaySeconds += (session.durationMinutes * 60) + (session.durationSeconds ?? 0);
        }

        // Lưu ngày vào Set (dạng chuỗi yyyy-MM-dd)
        uniqueDates.add("${sDate.year}-${sDate.month}-${sDate.day}");
      }

      // --- TÍNH STREAK (CHUỖI NGÀY) ---
      int currentStreak = 0;
      DateTime checkDate = today;
      String checkString = "${checkDate.year}-${checkDate.month}-${checkDate.day}";
      
      // Nếu hôm nay KHÔNG tập, kiểm tra xem hôm qua CÓ tập không?
      // Nếu hôm qua có tập -> Chuỗi chưa đứt, bắt đầu đếm từ hôm qua.
      if (!uniqueDates.contains(checkString)) {
         // Lùi lại 1 ngày (Hôm qua)
         DateTime yesterday = checkDate.subtract(const Duration(days: 1));
         String yesterdayString = "${yesterday.year}-${yesterday.month}-${yesterday.day}";
         
         if (uniqueDates.contains(yesterdayString)) {
           checkDate = yesterday; // Bắt đầu đếm từ hôm qua
         } else {
           // Cả hôm nay và hôm qua đều không tập -> Mất chuỗi
           return {
             'calories': todayCalories,
             'minutes': (todaySeconds / 60).ceil(),
             'streak': 0,
           };
         }
      }

      // Vòng lặp đếm ngược quá khứ
      while (true) {
        String dateStr = "${checkDate.year}-${checkDate.month}-${checkDate.day}";
        if (uniqueDates.contains(dateStr)) {
          currentStreak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break; // Ngắt chuỗi
        }
      }

      return {
        'calories': todayCalories,
        'minutes': (todaySeconds / 60).ceil(), // Làm tròn phút
        'streak': currentStreak,
      };

    } catch (e) {
      print("Lỗi tính thống kê: $e");
      return {'calories': 0, 'minutes': 0, 'streak': 0};
    }
  }
}