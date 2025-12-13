// lib/screens/user_info_screen.dart
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'plan_selection_screen.dart'; 

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  
  String _gender = 'Nam';
  double _age = 20;
  double _weight = 60.0; // Để dạng double
  double _height = 170.0;
  String _location = 'Tại nhà'; 

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onNext() {
    final incompleteProfile = UserProfile(
      name: _nameController.text.isEmpty ? 'Người dùng' : _nameController.text,
      gender: _gender,
      age: _age.round(), // Tuổi làm tròn thành số nguyên
      // MỚI: Lưu cân nặng và chiều cao chính xác 1 số lẻ
      weight: double.parse(_weight.toStringAsFixed(1)), 
      height: double.parse(_height.toStringAsFixed(1)),
      location: _location,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlanSelectionScreen(tempProfile: incompleteProfile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF1AB7B0);

    return Scaffold(
      appBar: AppBar(title: const Text('Thiết lập hồ sơ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. NHẬP TÊN
            const Text('Tên hiển thị', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Nhập tên của bạn',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 24),

            // 2. GIỚI TÍNH
            const Text('Giới tính', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _gender,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: tealColor),
                  items: ['Nam', 'Nữ'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _gender = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 3. THÔNG SỐ CƠ THỂ
            const Text('Thông số cơ thể', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            
            // Slider Tuổi (Số nguyên => decimals: 0)
            _buildSliderGroup(
              label: 'Tuổi',
              value: _age,
              min: 10,
              max: 80,
              unit: 'tuổi',
              decimals: 0, // Không lấy số lẻ
              onChanged: (val) => setState(() => _age = val),
            ),
            
            // Slider Chiều cao (Lấy 1 số lẻ => decimals: 1)
            _buildSliderGroup(
              label: 'Chiều cao',
              value: _height,
              min: 100,
              max: 220,
              unit: 'cm',
              decimals: 1, // MỚI: Lấy 1 số lẻ
              onChanged: (val) => setState(() => _height = val),
            ),

            // Slider Cân nặng (Lấy 1 số lẻ => decimals: 1)
            _buildSliderGroup(
              label: 'Cân nặng',
              value: _weight,
              min: 30,
              max: 150,
              unit: 'kg',
              decimals: 1, // MỚI: Lấy 1 số lẻ
              onChanged: (val) => setState(() => _weight = val),
            ),

            const SizedBox(height: 20),

            // 4. NƠI TẬP LUYỆN
            const Text('Nơi tập luyện', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildLocationCard('Tại nhà', Icons.home),
                const SizedBox(width: 15),
                _buildLocationCard('Tại Gym', Icons.fitness_center),
              ],
            ),

            const SizedBox(height: 40),

            // NÚT TIẾP TỤC
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _onNext,
                style: FilledButton.styleFrom(backgroundColor: tealColor),
                child: const Text('TIẾP TỤC: CHỌN KẾ HOẠCH', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget con: Thanh trượt
  Widget _buildSliderGroup({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required Function(double) onChanged,
    int decimals = 0, // MỚI: Tham số quyết định số lượng số lẻ
  }) {
    const tealColor = Color(0xFF1AB7B0);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
            Text(
              // MỚI: toStringAsFixed để hiển thị đúng số lượng số lẻ mong muốn
              '${value.toStringAsFixed(decimals)} $unit',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: tealColor),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          // MỚI: Chia nhỏ slider nếu là số thập phân để kéo mượt hơn
          divisions: (max - min).toInt() * (decimals == 0 ? 1 : 10), 
          activeColor: tealColor,
          inactiveColor: tealColor.withOpacity(0.2),
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLocationCard(String label, IconData icon) {
    final isSelected = _location == label;
    const tealColor = Color(0xFF1AB7B0);

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _location = label),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: isSelected ? tealColor.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: isSelected ? tealColor : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? tealColor : Colors.grey),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? tealColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}