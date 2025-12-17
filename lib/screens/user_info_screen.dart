// lib/screens/user_info_screen.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Thư viện tạo ID duy nhất
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
  double _weight = 60.0; 
  double _height = 170.0;
  String _location = 'Tại nhà'; 

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onNext() {
    // TẠO ID DUY NHẤT: Bước này cực kỳ quan trọng để Firebase phân biệt các người dùng
    var uuid = const Uuid();
    final String newId = uuid.v4();

    final incompleteProfile = UserProfile(
      id: newId, // ĐÃ THÊM: Giải quyết lỗi missing_required_argument
      name: _nameController.text.isEmpty ? 'Người dùng' : _nameController.text,
      gender: _gender,
      age: _age.round(),
      weight: double.parse(_weight.toStringAsFixed(1)), 
      height: double.parse(_height.toStringAsFixed(1)),
      location: _location,
      // Các trường còn lại sẽ lấy giá trị mặc định từ Constructor của UserProfile
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
      appBar: AppBar(
        title: const Text('Thiết lập hồ sơ'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tên hiển thị', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Nhập tên của bạn',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: tealColor),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Giới tính', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
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
                  onChanged: (newValue) => setState(() => _gender = newValue!),
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text('Thông số cơ thể', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            
            _buildSliderGroup(
              label: 'Tuổi',
              value: _age,
              min: 10,
              max: 80,
              unit: 'tuổi',
              decimals: 0,
              onChanged: (val) => setState(() => _age = val),
            ),
            
            _buildSliderGroup(
              label: 'Chiều cao',
              value: _height,
              min: 100,
              max: 220,
              unit: 'cm',
              decimals: 1,
              onChanged: (val) => setState(() => _height = val),
            ),

            _buildSliderGroup(
              label: 'Cân nặng',
              value: _weight,
              min: 30,
              max: 150,
              unit: 'kg',
              decimals: 1,
              onChanged: (val) => setState(() => _weight = val),
            ),

            const SizedBox(height: 20),

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

            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton(
                onPressed: _onNext,
                style: FilledButton.styleFrom(
                  backgroundColor: tealColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('TIẾP TỤC: CHỌN KẾ HOẠCH', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderGroup({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required Function(double) onChanged,
    int decimals = 0,
  }) {
    const tealColor = Color(0xFF1AB7B0);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
            Text(
              '${value.toStringAsFixed(decimals)} $unit',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: tealColor),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: decimals == 0 ? (max - min).toInt() : ((max - min) * 10).toInt(),
          activeColor: tealColor,
          inactiveColor: tealColor.withOpacity(0.1),
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
          height: 90,
          decoration: BoxDecoration(
            color: isSelected ? tealColor.withOpacity(0.05) : Colors.white,
            border: Border.all(
              color: isSelected ? tealColor : Colors.grey.shade200,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? tealColor : Colors.grey, size: 28),
              const SizedBox(height: 8),
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