// lib/screens/edit_profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile userProfile;

  const EditProfileScreen({super.key, required this.userProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Màu chủ đạo
  final Color _primaryColor = const Color(0xFF1AB7B0);
  
  late TextEditingController _nameController;
  late String _avatar; 
  late String _gender;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late String _goal;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _avatar = widget.userProfile.avatar;
    _gender = widget.userProfile.gender;
    _ageController = TextEditingController(text: widget.userProfile.age.toString());
    _weightController = TextEditingController(text: widget.userProfile.weight.toString());
    _heightController = TextEditingController(text: widget.userProfile.height.toString());
    _goal = widget.userProfile.goal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _avatar = image.path;
      });
    }
  }

  ImageProvider _getAvatarImage(String path) {
    if (path.contains('assets/')) {
      return AssetImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = UserProfile(
        id: widget.userProfile.id,
        name: _nameController.text,
        avatar: _avatar,
        gender: _gender,
        age: int.tryParse(_ageController.text) ?? widget.userProfile.age,
        weight: double.tryParse(_weightController.text) ?? widget.userProfile.weight,
        height: double.tryParse(_heightController.text) ?? widget.userProfile.height,
        goal: _goal,
        location: widget.userProfile.location,
        workoutPlan: widget.userProfile.workoutPlan,
      );

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator(color: _primaryColor)),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(updatedProfile.id)
            .set(updatedProfile.toMap(), SetOptions(merge: true));

        if (!mounted) return;
        Navigator.pop(context); 

        Navigator.pop(context, updatedProfile);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thành công!'), backgroundColor: Colors.green),
        );
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // GIỮ NGUYÊN NỀN TRẮNG
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildAvatarPicker()),
              const SizedBox(height: 30),

              _buildSectionTitle("Thông tin cơ bản"),
              const SizedBox(height: 15),
              _buildTextField("Họ và tên", _nameController, Icons.person_outline),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(child: _buildDropdown("Giới tính", _gender, ['Nam', 'Nữ'], (val) => setState(() => _gender = val!))),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTextField("Tuổi", _ageController, Icons.calendar_today, isNumber: true)),
                ],
              ),
              
              const SizedBox(height: 30),
              _buildSectionTitle("Chỉ số cơ thể"),
              const SizedBox(height: 15),
              
              Row(
                children: [
                  Expanded(child: _buildTextField("Cân nặng (kg)", _weightController, Icons.monitor_weight_outlined, isNumber: true)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTextField("Chiều cao (cm)", _heightController, Icons.height, isNumber: true)),
                ],
              ),

              const SizedBox(height: 30),
              _buildSectionTitle("Mục tiêu tập luyện"),
              const SizedBox(height: 15),
              _buildDropdown(
                "Mục tiêu hiện tại", 
                _goal, 
                ['Giảm cân', 'Tăng cơ', 'Duy trì vóc dáng', 'Nâng cao sức bền'], 
                (val) => setState(() => _goal = val!)
              ),

              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    shadowColor: _primaryColor.withOpacity(0.4),
                  ),
                  child: const Text('LƯU THAY ĐỔI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- CÁC WIDGET CON (ĐÃ SỬA MÀU SẮC) ---

  Widget _buildAvatarPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _primaryColor.withOpacity(0.5), width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: Colors.grey.shade200, // Đậm hơn chút cho background avatar
              backgroundImage: _getAvatarImage(_avatar),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: _primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(color: Colors.grey.shade800, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // SỬA: Thay đổi fillColor thành shade200
  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: (val) => val!.isEmpty ? 'Không được để trống' : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: _primaryColor.withOpacity(0.7)),
            filled: true,
            // SỬA Ở ĐÂY: Dùng shade200 để đậm hơn, tách biệt với nền trắng
            fillColor: Colors.grey.shade200, 
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primaryColor, width: 1.5)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
          ),
        ),
      ],
    );
  }

  // SỬA: Thay đổi fillColor thành shade200
  Widget _buildDropdown(String label, String currentValue, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: currentValue,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.sort, color: _primaryColor.withOpacity(0.7)),
            filled: true,
            // SỬA Ở ĐÂY: Dùng shade200
            fillColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primaryColor, width: 1.5)),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          dropdownColor: Colors.white,
        ),
      ],
    );
  }
}