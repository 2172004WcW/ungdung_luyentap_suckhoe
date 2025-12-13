// lib/screens/edit_profile_screen.dart
import 'dart:io'; // Cần thêm thư viện này để xử lý File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import '../models/user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile userProfile;

  const EditProfileScreen({super.key, required this.userProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
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

  // --- HÀM MỞ THƯ VIỆN ẢNH ---
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Mở thư viện ảnh (gallery)
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _avatar = image.path; // Lưu đường dẫn file ảnh trên điện thoại
      });
    }
  }

  // Hàm kiểm tra xem nên hiển thị ảnh từ Assets hay từ File
  ImageProvider _getAvatarImage(String path) {
    if (path.contains('assets/')) {
      return AssetImage(path); // Ảnh mặc định ban đầu
    } else {
      return FileImage(File(path)); // Ảnh chọn từ điện thoại
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = UserProfile(
        name: _nameController.text,
        avatar: _avatar,
        gender: _gender,
        age: int.tryParse(_ageController.text) ?? widget.userProfile.age,
        weight: double.tryParse(_weightController.text) ?? widget.userProfile.weight,
        height: double.tryParse(_heightController.text) ?? widget.userProfile.height,
        goal: _goal,
      );

      Navigator.pop(context, updatedProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa thông tin')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- PHẦN ẢNH ĐẠI DIỆN ---
              Center(
                child: GestureDetector(
                  onTap: _pickImage, // Bấm vào ảnh để mở thư viện
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _getAvatarImage(_avatar), // Dùng hàm helper
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1AB7B0),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(child: Text('Chạm để đổi ảnh', style: TextStyle(color: Colors.grey))),
              const SizedBox(height: 30),

              // --- FORM NHẬP LIỆU (Giữ nguyên) ---
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên hiển thị', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Giới tính', border: OutlineInputBorder()),
                items: ['Nam', 'Nữ'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _gender = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Tuổi', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cân nặng (kg)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Chiều cao (cm)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _goal,
                decoration: const InputDecoration(labelText: 'Mục tiêu', border: OutlineInputBorder()),
                items: ['Giảm cân', 'Tăng cơ', 'Duy trì vóc dáng', 'Nâng cao sức bền'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _goal = val!),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _saveProfile,
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFF1AB7B0)),
                  child: const Text('LƯU THAY ĐỔI', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}