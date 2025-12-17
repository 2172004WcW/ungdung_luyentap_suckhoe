import 'package:flutter/material.dart';
import '../models/nutrition_log.dart';
import '../models/thuc_pham.dart';
import '../models/handbook_topic.dart';
import '../services/storage_service.dart';

class AddMealScreen extends StatefulWidget {
  final DateTime date;

  const AddMealScreen({super.key, required this.date});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  MealType _selectedType = MealType.breakfast;
  final List<MealItem> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm bữa ăn'),
      ),
      body: Column(
        children: [
          // Chọn loại bữa ăn
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<MealType>(
              segments: MealType.values.map((type) {
                return ButtonSegment<MealType>(
                  value: type,
                  label: Text(type.displayName),
                );
              }).toList(),
              selected: {_selectedType},
              onSelectionChanged: (Set<MealType> newSelection) {
                setState(() => _selectedType = newSelection.first);
              },
            ),
          ),

          // Danh sách món ăn
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.restaurant_menu,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'Chưa có món ăn nào',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _addFood,
                          icon: const Icon(Icons.add),
                          label: const Text('Thêm món ăn'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1AB7B0),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(item.food.ten),
                          subtitle: Text(
                            '${item.quantity.toStringAsFixed(0)}g • '
                            '${item.totalCalories.toStringAsFixed(0)} kcal',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editItem(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() => _items.removeAt(index));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Tổng calo
          if (_items.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1AB7B0).withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng calo:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_items.fold(0.0, (sum, item) => sum + item.totalCalories).toStringAsFixed(0)} kcal',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1AB7B0),
                    ),
                  ),
                ],
              ),
            ),

          // Nút thêm món và lưu
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_items.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addFood,
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm món ăn'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1AB7B0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                if (_items.isNotEmpty) const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _items.isEmpty ? null : _saveMeal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1AB7B0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Lưu bữa ăn',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addFood() {
    // Lấy danh sách thực phẩm từ handbook
    final foodTopic = HandbookData.topics.firstWhere(
      (t) => t.isFoodList,
      orElse: () => HandbookData.topics.first,
    );
    final foods = foodTopic.foodList ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn thực phẩm'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return ListTile(
                title: Text(food.ten),
                subtitle: Text('${food.calorie} kcal/100g'),
                onTap: () {
                  Navigator.pop(context);
                  _addFoodWithQuantity(food);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _addFoodWithQuantity(ThucPham food) {
    final quantityController = TextEditingController(text: '100');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm ${food.ten}'),
        content: TextField(
          controller: quantityController,
          decoration: const InputDecoration(
            labelText: 'Số lượng (gram)',
            hintText: '100',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = double.tryParse(quantityController.text) ?? 100;
              setState(() {
                _items.add(MealItem(food: food, quantity: quantity));
              });
              Navigator.pop(context);
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _editItem(int index) {
    final item = _items[index];
    final quantityController =
        TextEditingController(text: item.quantity.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chỉnh sửa ${item.food.ten}'),
        content: TextField(
          controller: quantityController,
          decoration: const InputDecoration(
            labelText: 'Số lượng (gram)',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = double.tryParse(quantityController.text) ?? 100;
              setState(() {
                _items[index] = MealItem(food: item.food, quantity: quantity);
              });
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMeal() async {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng thêm ít nhất một món ăn')),
      );
      return;
    }

    // Load daily nutrition hiện tại
    final logs = await StorageService.loadNutritionLogs();
    DailyNutrition? dailyNutrition = logs.firstWhere(
      (log) =>
          log.date.year == widget.date.year &&
          log.date.month == widget.date.month &&
          log.date.day == widget.date.day,
      orElse: () => DailyNutrition(
        date: widget.date,
        meals: [],
        targetCalories: 2000,
        targetProtein: 150,
        targetCarbs: 250,
        targetFat: 65,
      ),
    );

    // Tạo meal mới
    final meal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: widget.date,
      type: _selectedType,
      items: _items,
    );

    // Thêm vào daily nutrition
    final updated = DailyNutrition(
      date: dailyNutrition.date,
      meals: [...dailyNutrition.meals, meal],
      targetCalories: dailyNutrition.targetCalories,
      targetProtein: dailyNutrition.targetProtein,
      targetCarbs: dailyNutrition.targetCarbs,
      targetFat: dailyNutrition.targetFat,
      waterIntake: dailyNutrition.waterIntake,
    );

    await StorageService.saveDailyNutrition(updated);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }
}

