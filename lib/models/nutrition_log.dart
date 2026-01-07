import 'thuc_pham.dart';

/// Model cho bữa ăn
class Meal {
  final String id;
  final DateTime date;
  final MealType type; // Sáng, Trưa, Tối, Bữa phụ
  final List<MealItem> items; //Danh sách món ăn
  final String? notes;

  Meal({
    required this.id,
    required this.date,
    required this.type,
    required this.items,
    this.notes,
  });

  //Tính tổng calo của bữa ăn
  double get totalCalories {
    return items.fold(0.0, (sum, item) => sum + item.totalCalories);
  }

  //Tính tổng protein
  double get totalProtein {
    return items.fold(0.0, (sum, item) => sum + item.totalProtein);
  }

  //Tính tổng carbs
  double get totalCarbs {
    return items.fold(0.0, (sum, item) => sum + item.totalCarbs);
  }

  //Tính tổng fat
  double get totalFat {
    return items.fold(0.0, (sum, item) => sum + item.totalFat);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type.toString().split('.').last,
      'items': items.map((i) => i.toJson()).toList(),
      'notes': notes,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      type: MealType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MealType.other,
      ),
      items: (json['items'] as List)
          .map((i) => MealItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );
  }
}

/// Loại bữa ăn
enum MealType {
  breakfast, // Sáng
  lunch, // Trưa
  dinner, // Tối
  snack, // Bữa phụ
  other, 
}

extension MealTypeExtension on MealType {
  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Bữa sáng';
      case MealType.lunch:
        return 'Bữa trưa';
      case MealType.dinner:
        return 'Bữa tối';
      case MealType.snack:
        return 'Bữa phụ';
      case MealType.other:
        return 'Khác';
    }
  }
}

/// Model cho món ăn trong bữa
class MealItem {
  final ThucPham food;
  final double quantity; // Số lượng (gram)

  MealItem({
    required this.food,
    required this.quantity,
  });

  /// Tính calo dựa trên số lượng
  double get totalCalories {
    final nutrition = food.tinhDinhDuong(quantity);
    return nutrition['calorie'] ?? 0;
  }

  double get totalProtein {
    final nutrition = food.tinhDinhDuong(quantity);
    return nutrition['protein'] ?? 0;
  }

  double get totalCarbs {
    final nutrition = food.tinhDinhDuong(quantity);
    return nutrition['carbs'] ?? 0;
  }

  double get totalFat {
    final nutrition = food.tinhDinhDuong(quantity);
    return nutrition['fat'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson(),
      'quantity': quantity,
    };
  }

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      food: ThucPham.fromJson(json['food'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
    );
  }
}

/// Model cho dinh dưỡng trong ngày
class DailyNutrition {
  final DateTime date;
  final List<Meal> meals;
  final double? targetCalories; // Mục tiêu calo
  final double? targetProtein;
  final double? targetCarbs;
  final double? targetFat;
  final double waterIntake; // Lượng nước uống (ml)

  DailyNutrition({
    required this.date,
    required this.meals,
    this.targetCalories,
    this.targetProtein,
    this.targetCarbs,
    this.targetFat,
    this.waterIntake = 0,
  });

  /// Tổng calo trong ngày
  double get totalCalories {
    return meals.fold(0.0, (sum, meal) => sum + meal.totalCalories);
  }

  /// Tổng protein
  double get totalProtein {
    return meals.fold(0.0, (sum, meal) => sum + meal.totalProtein);
  }

  /// Tổng carbs
  double get totalCarbs {
    return meals.fold(0.0, (sum, meal) => sum + meal.totalCarbs);
  }

  /// Tổng fat
  double get totalFat {
    return meals.fold(0.0, (sum, meal) => sum + meal.totalFat);
  }

  /// Phần trăm hoàn thành mục tiêu calo
  double get caloriesProgress {
    if (targetCalories == null || targetCalories == 0) return 0;
    return (totalCalories / targetCalories!).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'meals': meals.map((m) => m.toJson()).toList(),
      'targetCalories': targetCalories,
      'targetProtein': targetProtein,
      'targetCarbs': targetCarbs,
      'targetFat': targetFat,
      'waterIntake': waterIntake,
    };
  }

  factory DailyNutrition.fromJson(Map<String, dynamic> json) {
    return DailyNutrition(
      date: DateTime.parse(json['date'] as String),
      meals: (json['meals'] as List)
          .map((m) => Meal.fromJson(m as Map<String, dynamic>))
          .toList(),
      targetCalories: json['targetCalories'] as double?,
      targetProtein: json['targetProtein'] as double?,
      targetCarbs: json['targetCarbs'] as double?,
      targetFat: json['targetFat'] as double?,
      waterIntake: (json['waterIntake'] as num?)?.toDouble() ?? 0,
    );
  }
}

