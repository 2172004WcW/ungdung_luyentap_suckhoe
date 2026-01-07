import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/nutrition_log.dart';
import '../models/thuc_pham.dart';
import '../services/nutrition_service.dart';

class AddMealScreen extends StatefulWidget {
  final DateTime date;

  const AddMealScreen({super.key, required this.date});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final NutritionService _nutritionService = NutritionService();
  
  MealType _selectedType = MealType.breakfast;
  final List<MealItem> _items = [];
  String _searchQuery = ''; 

  //Xử lý hiển thị ảnh thông minh
  Widget _buildFoodImage(String? url) {
    if (url == null || url.isEmpty) {
      return const Icon(Icons.fastfood, size: 40, color: Colors.grey);
    }
    return Image(
      image: url.contains('assets/') ? AssetImage(url) : NetworkImage(url) as ImageProvider,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm bữa ăn')),
      body: Column(
        children: [
          //1.Chọn loại bữa ăn
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<MealType>(
              segments: const [
                ButtonSegment<MealType>(value: MealType.breakfast, label: Text("Sáng")),
                ButtonSegment<MealType>(value: MealType.lunch, label: Text("Trưa")),
                ButtonSegment<MealType>(value: MealType.dinner, label: Text("Tối")),
                ButtonSegment<MealType>(value: MealType.snack, label: Text("Phụ")),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<MealType> newSelection) {
                setState(() => _selectedType = newSelection.first);
              },
            ),
          ),

          //2.Danh sách món ĐÃ CHỌN
          if (_items.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Món đã chọn:", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              height: 120,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.green.shade50,
                    child: ListTile(
                      dense: true,
                      // Sử dụng hàm hiển thị ảnh mới
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildFoodImage(item.food.hinhAnh),
                      ),
                      title: Text(item.food.ten),
                      subtitle: Text('${item.quantity.toStringAsFixed(0)}g • ${item.totalCalories.toStringAsFixed(0)} kcal'),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => setState(() => _items.removeAt(index)),
                      ),
                      onTap: () => _editItem(index),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
          ],

          //3.Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Tìm món ăn (Phở, Cơm, Gà...)",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),

          //4.Danh sách món ăn TỪ FIREBASE
          Expanded(
            child: StreamBuilder<List<ThucPham>>(
              stream: _nutritionService.getCommonFoods(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Chưa có dữ liệu món ăn trên hệ thống"));
                }

                final foods = snapshot.data!.where((f) {
                  return f.ten.toLowerCase().contains(_searchQuery);
                }).toList();

                if (foods.isEmpty) {
                  return const Center(child: Text("Không tìm thấy món ăn nào"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        // Sử dụng hàm hiển thị ảnh mới
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildFoodImage(food.hinhAnh),
                        ),
                        title: Text(food.ten, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${food.calorie} kcal / 100g"),
                        trailing: const Icon(Icons.add_circle_outline, color: Color(0xFF1AB7B0), size: 28),
                        onTap: () => _addFoodWithQuantity(food),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          //5.Nút LƯU BỮA ĂN
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tổng cộng:", style: TextStyle(color: Colors.grey)),
                    Text(
                      "${_items.fold(0.0, (sum, item) => sum + item.totalCalories).toStringAsFixed(0)} kcal",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1AB7B0)),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _items.isEmpty ? null : _saveMeal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1AB7B0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text("LƯU BỮA ĂN", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Thêm/Sửa Món
  void _addFoodWithQuantity(ThucPham food) {
    final quantityController = TextEditingController(text: '100');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm ${food.ten}'),
        content: TextField(
          controller: quantityController,
          decoration: const InputDecoration(labelText: 'Số lượng (gram)', suffixText: 'g'),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(onPressed: () {
            final quantity = double.tryParse(quantityController.text) ?? 100;
            setState(() => _items.add(MealItem(food: food, quantity: quantity)));
            Navigator.pop(context);
          }, child: const Text('Thêm')),
        ],
      ),
    );
  }

  void _editItem(int index) {
    final item = _items[index];
    final quantityController = TextEditingController(text: item.quantity.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sửa ${item.food.ten}'),
        content: TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Số lượng (gram)', suffixText: 'g'), keyboardType: TextInputType.number),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(onPressed: () {
            final quantity = double.tryParse(quantityController.text) ?? 100;
            setState(() => _items[index] = MealItem(food: item.food, quantity: quantity));
            Navigator.pop(context);
          }, child: const Text('Cập nhật')),
        ],
      ),
    );
  }

  Future<void> _saveMeal() async {
    if (_items.isEmpty) return;
    try {
      DailyNutrition currentNutrition = await _nutritionService.getDailyNutrition(widget.date);
      final mealId = const Uuid().v4(); 
      final newMeal = Meal(id: mealId, date: widget.date, type: _selectedType, items: _items);
      
      List<Meal> updatedMeals = List.from(currentNutrition.meals);
      int existingIndex = updatedMeals.indexWhere((m) => m.type == _selectedType);
      if (existingIndex != -1) {
         Meal existing = updatedMeals[existingIndex];
         updatedMeals[existingIndex] = Meal(
           id: existing.id, 
           date: existing.date, 
           type: existing.type, 
           items: [...existing.items, ..._items]
         );
      } else {
         updatedMeals.add(newMeal);
      }

      final updatedNutrition = currentNutrition.copyWith(meals: updatedMeals);

      await _nutritionService.saveDailyNutrition(updatedNutrition);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã lưu bữa ăn thành công!")));
        Navigator.pop(context, true); 
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi khi lưu: $e")));
    }
  }
}