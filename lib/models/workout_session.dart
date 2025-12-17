import 'package:cloud_firestore/cloud_firestore.dart';
import 'exercise.dart';

class WorkoutSession {
  final String id;
  final DateTime date;
  final String workoutPlanName;
  final List<WorkoutExercise> exercises;

  final int durationMinutes;
  final int? durationSeconds; // ✅ tổng giây (tùy chọn)

  final int? caloriesBurned;
  final String? notes;

  WorkoutSession({
    required this.id,
    required this.date,
    required this.workoutPlanName,
    required this.exercises,
    required this.durationMinutes,
    this.durationSeconds,
    this.caloriesBurned,
    this.notes,
  });

  // ===== Local JSON (SharedPreferences) =====
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'workoutPlanName': workoutPlanName,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'durationMinutes': durationMinutes,
      'durationSeconds': durationSeconds,
      'caloriesBurned': caloriesBurned,
      'notes': notes,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      workoutPlanName: (json['workoutPlanName'] ?? '') as String,
      exercises: ((json['exercises'] as List?) ?? [])
          .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      caloriesBurned: (json['caloriesBurned'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );
  }

  // ===== Firestore =====
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'date': Timestamp.fromDate(date),
      'workoutPlanName': workoutPlanName,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'durationMinutes': durationMinutes,
      'durationSeconds': durationSeconds,
      'caloriesBurned': caloriesBurned,
      'notes': notes,
    };
  }

  factory WorkoutSession.fromFirestore(Map<String, dynamic> firestoreData) {
    final rawDate = firestoreData['date'];

    DateTime parsedDate;
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.parse(rawDate);
    } else {
      parsedDate = DateTime.now();
    }

    return WorkoutSession(
      id: (firestoreData['id'] ?? '') as String,
      date: parsedDate,
      workoutPlanName: (firestoreData['workoutPlanName'] ?? '') as String,
      exercises: ((firestoreData['exercises'] as List?) ?? [])
          .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      durationMinutes: (firestoreData['durationMinutes'] as num?)?.toInt() ?? 0,
      durationSeconds: (firestoreData['durationSeconds'] as num?)?.toInt(),
      caloriesBurned: (firestoreData['caloriesBurned'] as num?)?.toInt(),
      notes: firestoreData['notes'] as String?,
    );
  }
}
