class StreakService {
  static int calculateNewStreak(int currentStreak, DateTime? lastActivityDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastActivityDate == null) return 1;

    final lastDate = DateTime(
      lastActivityDate.year,
      lastActivityDate.month,
      lastActivityDate.day,
    );

    final difference = today.difference(lastDate).inDays;

    if (difference == 0) return currentStreak; // đã tập hôm nay
    if (difference == 1) return currentStreak + 1; // tập liên tiếp
    return 1; // đứt chuỗi
  }
}
