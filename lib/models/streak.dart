class Streak {
  final int currentStreak;
  final DateTime? lastActivityDate;

  Streak({
    required this.currentStreak,
    this.lastActivityDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'lastActivityDate': lastActivityDate?.toIso8601String(),
    };
  }

  factory Streak.fromJson(Map<String, dynamic> json) {
    return Streak(
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      lastActivityDate: json['lastActivityDate'] != null
          ? DateTime.tryParse(json['lastActivityDate'].toString())
          : null,
    );
  }
}
