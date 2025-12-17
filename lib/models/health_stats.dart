import 'package:cloud_firestore/cloud_firestore.dart';

/// Model cho thống kê sức khỏe
class HealthStats {
  final DateTime date;
  final double? weight;
  final int? steps;
  final int? heartRate;
  final double? waterIntake;
  final int? sleepHours;
  final int? caloriesBurned;
  final int? caloriesConsumed;

  HealthStats({
    required this.date,
    this.weight,
    this.steps,
    this.heartRate,
    this.waterIntake,
    this.sleepHours,
    this.caloriesBurned,
    this.caloriesConsumed,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'weight': weight,
      'steps': steps,
      'heartRate': heartRate,
      'waterIntake': waterIntake,
      'sleepHours': sleepHours,
      'caloriesBurned': caloriesBurned,
      'caloriesConsumed': caloriesConsumed,
    };
  }

  factory HealthStats.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    if (json['date'] is Timestamp) {
      parsedDate = (json['date'] as Timestamp).toDate();
    } else {
      parsedDate = DateTime.parse(json['date'] as String? ?? DateTime.now().toIso8601String());
    }

    return HealthStats(
      date: parsedDate,
      weight: (json['weight'] as num?)?.toDouble(),
      steps: json['steps'] as int?,
      heartRate: json['heartRate'] as int?,
      waterIntake: (json['waterIntake'] as num?)?.toDouble(),
      sleepHours: json['sleepHours'] as int?,
      caloriesBurned: json['caloriesBurned'] as int?,
      caloriesConsumed: json['caloriesConsumed'] as int?,
    );
  }
}

/// Model cho streak (chuỗi ngày liên tiếp)
class Streak {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;

  Streak({
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActivityDate': lastActivityDate != null ? Timestamp.fromDate(lastActivityDate!) : null,
    };
  }

  factory Streak.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['lastActivityDate'] != null) {
      if (json['lastActivityDate'] is Timestamp) {
        parsedDate = (json['lastActivityDate'] as Timestamp).toDate();
      } else {
        parsedDate = DateTime.parse(json['lastActivityDate'] as String);
      }
    }

    return Streak(
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastActivityDate: parsedDate,
    );
  }
}