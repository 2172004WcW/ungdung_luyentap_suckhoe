// lib/screens/edit_profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Thêm Firestore
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

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // CẬP NHẬT HÀM LƯU DỮ LIỆU LÊN FIREBASE
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // 1. Tạo đối tượng đã cập nhật (Bổ sung tham số id ở đây để hết lỗi)
      final updatedProfile = UserProfile(
        id: widget.userProfile.id, // SỬA LỖI: Thêm ID từ profile cũ
        name: _nameController.text,
        avatar: _avatar,
        gender: _gender,
        age: int.tryParse(_ageController.text) ?? widget.userProfile.age,
        weight: double.tryParse(_weightController.text) ?? widget.userProfile.weight,
        height: double.tryParse(_heightController.text) ?? widget.userProfile.height,
        goal: _goal,
        location: widget.userProfile.location, // Giữ nguyên các giá trị cũ
        workoutPlan: widget.userProfile.workoutPlan,
      );

      try {
        // Hiển thị vòng xoay chờ
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        // 2. Lưu lên Firestore (Sử dụng hàm toMap đã tạo ở UserProfile)
        await FirebaseFirestore.instance
            .collection('users')
            .doc(updatedProfile.id)
            .set(updatedProfile.toMap(), SetOptions(merge: true));

        // Tắt vòng xoay chờ
        if (!mounted) return;
        Navigator.pop(context); 

        // 3. Quay lại và trả về profile mới để UI cập nhật
        Navigator.pop(context, updatedProfile);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thành công!')),
        );
      } catch (e) {
        Navigator.pop(context); // Tắt vòng xoay
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu dữ liệu: $e')),
        );
      }
    }
  }

  // --- UI giữ nguyên như code của bạn ---
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
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _getAvatarImage(_avatar),
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