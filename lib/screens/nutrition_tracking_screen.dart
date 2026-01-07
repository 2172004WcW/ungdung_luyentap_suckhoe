import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; 
import '../models/nutrition_log.dart';
import '../services/nutrition_service.dart';
import 'add_meal_screen.dart';

class NutritionTrackingScreen extends StatefulWidget {
  const NutritionTrackingScreen({super.key});

  @override
  State<NutritionTrackingScreen> createState() =>
      _NutritionTrackingScreenState();
}

class _NutritionTrackingScreenState extends State<NutritionTrackingScreen> {
  DateTime _selectedDate = DateTime.now();
  final NutritionService _nutritionService = NutritionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theo dõi dinh dưỡng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ],
      ),
      body: StreamBuilder<DailyNutrition>(
        stream: _nutritionService.getDailyNutritionStream(_selectedDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
             return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
          }

          final nutrition = snapshot.data ?? DailyNutrition(
            date: _selectedDate, 
            meals: [],
            targetCalories: 2000,
            targetProtein: 150,
            targetCarbs: 250,
            targetFat: 65,
          );

          return Column(
            children: [
              //Header Thống kê
              Container(
                padding: const EdgeInsets.all(20),
                color: const Color(0xFF1AB7B0).withOpacity(0.1),
                child: Column(
                  children: [
                    Text(
                      _formatDate(_selectedDate),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('Calo', '${nutrition.totalCalories.toStringAsFixed(0)} / ${nutrition.targetCalories ?? 0}', nutrition.caloriesProgress, Colors.orange),
                        _buildStatCard('Protein', '${nutrition.totalProtein.toStringAsFixed(1)}g / ${nutrition.targetProtein ?? 0}g', nutrition.targetProtein != null ? (nutrition.totalProtein / nutrition.targetProtein!).clamp(0.0, 1.0) : 0, Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('Carbs', '${nutrition.totalCarbs.toStringAsFixed(1)}g / ${nutrition.targetCarbs ?? 0}g', nutrition.targetCarbs != null ? (nutrition.totalCarbs / nutrition.targetCarbs!).clamp(0.0, 1.0) : 0, Colors.green),
                        _buildStatCard('Fat', '${nutrition.totalFat.toStringAsFixed(1)}g / ${nutrition.targetFat ?? 0}g', nutrition.targetFat != null ? (nutrition.totalFat / nutrition.targetFat!).clamp(0.0, 1.0) : 0, Colors.purple),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Nước uống
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Nước uống:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${nutrition.waterIntake}ml'),
                          IconButton(icon: const Icon(Icons.add_circle), onPressed: () => _addWater(nutrition)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Danh sách bữa ăn
              Expanded(child: _buildMealsList(nutrition)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddMealScreen(),
        backgroundColor: const Color(0xFF1AB7B0),
        icon: const Icon(Icons.add),
        label: const Text('Thêm món'),
      ),
    );
  }

  //Các Widget con giữ nguyên
  Widget _buildStatCard(String label, String value, double progress, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress, backgroundColor: color.withOpacity(0.2), valueColor: AlwaysStoppedAnimation<Color>(color)),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsList(DailyNutrition nutrition) {
    final mealTypes = MealType.values;
    if (nutrition.meals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Icon(Icons.restaurant, size: 64, color: Colors.grey), SizedBox(height: 16), Text('Chưa có bữa ăn nào', style: TextStyle(fontSize: 18, color: Colors.grey))],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mealTypes.length,
      itemBuilder: (context, index) {
        final type = mealTypes[index];
        final mealsOfType = nutrition.meals.where((m) => m.type == type).toList();
        if (mealsOfType.isEmpty) return const SizedBox.shrink();

        return Column(
          children: mealsOfType.map((meal) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                title: Text(type.displayName),
                subtitle: Text('${meal.totalCalories.toStringAsFixed(0)} kcal'),
                leading: Icon(_getMealIcon(type), color: const Color(0xFF1AB7B0)),
                children: meal.items.map((item) {
                  return ListTile(
                    title: Text(item.food.ten),
                    subtitle: Text('${item.quantity.toStringAsFixed(0)}g • ${item.totalCalories.toStringAsFixed(0)} kcal'),
                    trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteMealItem(meal, item, nutrition)),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  IconData _getMealIcon(MealType type) {
    switch (type) {
      case MealType.breakfast: return Icons.wb_sunny;
      case MealType.lunch: return Icons.restaurant;
      case MealType.dinner: return Icons.dinner_dining;
      case MealType.snack: return Icons.cookie;
      default: return Icons.fastfood;
    }
  }

  // --- Logic ---
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _openAddMealScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMealScreen(date: _selectedDate),
      ),
    );
  }

  Future<void> _addWater(DailyNutrition nutrition) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm nước'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Số ml', hintText: '250'), keyboardType: TextInputType.number),
        actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')), ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Thêm'))],
      ),
    );
    if (confirmed == true) {
      final ml = int.tryParse(controller.text) ?? 0;
      final updated = DailyNutrition(date: nutrition.date, meals: nutrition.meals, targetCalories: nutrition.targetCalories, targetProtein: nutrition.targetProtein, targetCarbs: nutrition.targetCarbs, targetFat: nutrition.targetFat, waterIntake: nutrition.waterIntake + ml);
      await _nutritionService.saveDailyNutrition(updated);
    }
  }

  Future<void> _deleteMealItem(Meal meal, MealItem item, DailyNutrition nutrition) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa món ăn?'),
        content: Text('Bạn có chắc muốn xóa ${item.food.ten}?'),
        actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.pop(context, true), child: const Text('Xóa'))],
      ),
    );

    if (confirmed == true) {
      List<Meal> updatedMeals = List.from(nutrition.meals);
      int mealIndex = updatedMeals.indexWhere((m) => m.id == meal.id);
      if (mealIndex != -1) {
        Meal targetMeal = updatedMeals[mealIndex];
        List<MealItem> newItems = List.from(targetMeal.items)..remove(item);
        if (newItems.isEmpty) {
          updatedMeals.removeAt(mealIndex);
        } else {
          updatedMeals[mealIndex] = Meal(id: targetMeal.id, date: targetMeal.date, type: targetMeal.type, items: newItems, notes: targetMeal.notes);
        }
        final updatedNutrition = DailyNutrition(date: nutrition.date, meals: updatedMeals, targetCalories: nutrition.targetCalories, targetProtein: nutrition.targetProtein, targetCarbs: nutrition.targetCarbs, targetFat: nutrition.targetFat, waterIntake: nutrition.waterIntake);
        await _nutritionService.saveDailyNutrition(updatedNutrition);
      }
    }
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}