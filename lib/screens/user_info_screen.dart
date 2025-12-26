// lib/screens/user_info_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
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

  static const Color primaryTeal = Color(0xFF1AB7B0);
  static const Color lightGreenBg = Color(0xFFF1F9F8);
  static const Color cardColor = Colors.white;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onNext() {
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng nhập tên của bạn'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orangeAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final incompleteProfile = UserProfile(
      id: const Uuid().v4(),
      name: name,
      gender: _gender,
      age: _age.round(),
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

  void _showValuePicker({
    required String label,
    required double currentValue,
    required double min,
    required double max,
    required String unit,
    required int decimals,
    required Function(double) onChanged,
  }) {
    final step = (decimals == 0) ? 1.0 : 0.1;
    final int itemCount = ((max - min) / step).round() + 1;
    final List<double> options = List.generate(
      itemCount,
      (i) => double.parse((min + (i * step)).toStringAsFixed(decimals)),
    );

    int initialIndex = options.indexOf(
      double.parse(currentValue.toStringAsFixed(decimals)),
    );
    if (initialIndex == -1) initialIndex = 0;
    double tempValue = currentValue;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Chọn $label",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Expanded(
              child: ListWheelScrollView.useDelegate(
                itemExtent: 50,
                physics: const FixedExtentScrollPhysics(),
                controller: FixedExtentScrollController(
                  initialItem: initialIndex,
                ),
                onSelectedItemChanged: (idx) {
                  HapticFeedback.selectionClick();
                  tempValue = options[idx];
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: options.length,
                  builder: (context, index) => Center(
                    child: Text(
                      '${options[index]} $unit',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryTeal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    onChanged(tempValue);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "XÁC NHẬN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: lightGreenBg,
        appBar: AppBar(
          title: const Text(
            'Hồ sơ sức khỏe',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
          ),
          backgroundColor: lightGreenBg,
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10), // Giảm khoảng cách đỉnh
              _buildSectionTitle('Thông tin cơ bản'),
              _buildCard([
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(
                    'Tên của bạn',
                    Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 12), // Tối ưu Spacing
                _buildDropdownGender(),
              ]),
              const SizedBox(height: 20), // Giảm Spacing giữa các mục
              _buildSectionTitle('Chỉ số cơ thể'),
              _buildCard([
                _buildPickerItem(
                  'Tuổi',
                  _age,
                  10,
                  100,
                  'tuổi',
                  0,
                  (v) => setState(() => _age = v),
                ),
                Divider(height: 1, color: Colors.grey.shade100),
                _buildPickerItem(
                  'Chiều cao',
                  _height,
                  100,
                  250,
                  'cm',
                  1,
                  (v) => setState(() => _height = v),
                ),
                Divider(height: 1, color: Colors.grey.shade100),
                _buildPickerItem(
                  'Cân nặng',
                  _weight,
                  20,
                  200,
                  'kg',
                  1,
                  (v) => setState(() => _weight = v),
                ),
              ]),
              const SizedBox(height: 20),
              _buildSectionTitle('Địa điểm tập'),
              Row(
                children: [
                  _buildLocationCard('Tại nhà', Icons.home_rounded),
                  const SizedBox(width: 12),
                  _buildLocationCard('Tại Gym', Icons.fitness_center_rounded),
                ],
              ),
              const SizedBox(height: 30), // Khoảng đệm vừa đủ
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomButton(),
      ),
    );
  }

  // --- UI COMPONENTS FIX ---

  Widget _buildCard(List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(children: children),
  );

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.blueGrey,
      ),
    ),
  );

  InputDecoration _inputDecoration(String label, IconData icon) =>
      InputDecoration(
        prefixIcon: Icon(icon, color: primaryTeal, size: 22),
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        floatingLabelBehavior:
            FloatingLabelBehavior.auto, // Tự động đẩy label lên khi click
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        filled: true,
        fillColor: lightGreenBg.withOpacity(0.5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryTeal, width: 1),
        ),
      );

  Widget _buildDropdownGender() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: lightGreenBg.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _gender,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down_rounded, color: primaryTeal),
        dropdownColor: cardColor, // Đảm bảo nền dropdown trắng sạch
        alignment: AlignmentDirectional.centerStart,
        menuMaxHeight:
            200, // Giới hạn chiều cao menu để không bị sổ ngược lên trên
        items: ['Nam', 'Nữ']
            .map(
              (v) => DropdownMenuItem(
                value: v,
                child: Text(
                  v,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => _gender = v!),
      ),
    ),
  );

  Widget _buildPickerItem(
    String label,
    double val,
    double min,
    double max,
    String unit,
    int dec,
    Function(double) onChg,
  ) => InkWell(
    onTap: () => _showValuePicker(
      label: label,
      currentValue: val,
      min: min,
      max: max,
      unit: unit,
      decimals: dec,
      onChanged: onChg,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),
          Text(
            '${val.toStringAsFixed(dec)} $unit',
            style: const TextStyle(
              color: primaryTeal,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildLocationCard(String label, IconData icon) {
    bool isSel = _location == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _location = label),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSel ? primaryTeal : cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSel ? primaryTeal : Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSel ? Colors.white : Colors.grey, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSel ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() => Container(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
    decoration: const BoxDecoration(color: lightGreenBg),
    child: SizedBox(
      height: 54,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: _onNext,
        child: const Text(
          "TIẾP TỤC",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: 1.1,
          ),
        ),
      ),
    ),
  );
}
