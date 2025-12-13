// lib/screens/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  
  // --- SỬA LỖI TẠI ĐÂY ---
  // Thêm dòng này để định nghĩa tham số onProfileChanged
  final Function(UserProfile) onProfileChanged; 

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.onProfileChanged, // Bắt buộc phải có dòng này
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  ImageProvider _getAvatarImage(String path) {
    if (path.contains('assets/')) {
      return AssetImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  void _navigateToEdit() async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(userProfile: widget.userProfile),
      ),
    );

    if (updatedData != null && updatedData is UserProfile) {
      // Gọi hàm callback để báo cho HomeScreen biết dữ liệu đã thay đổi
      widget.onProfileChanged(updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
        automaticallyImplyLeading: false, // Ẩn nút Back mặc định
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, size: 30, color: Color(0xFF1AB7B0)),
            onPressed: _navigateToEdit,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _getAvatarImage(widget.userProfile.avatar),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.userProfile.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Mục tiêu: ${widget.userProfile.goal}',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAchievementItem('🔥', '1,250', 'Kcal'),
                  Container(height: 40, width: 1, color: Colors.grey.shade200),
                  _buildAchievementItem('⏱️', '45', 'Phút'),
                  Container(height: 40, width: 1, color: Colors.grey.shade200),
                  _buildAchievementItem('📅', '7', 'Ngày'),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

            ListTile(
              leading: const Icon(Icons.cake, color: Color(0xFF1AB7B0)),
              title: const Text('Tuổi'),
              trailing: Text('${widget.userProfile.age} tuổi', style: const TextStyle(fontSize: 16)),
            ),
            const Divider(height: 1, indent: 20, endIndent: 20),
            ListTile(
              leading: const Icon(Icons.monitor_weight, color: Color(0xFF1AB7B0)),
              title: const Text('Cân nặng'),
              trailing: Text('${widget.userProfile.weight} kg', style: const TextStyle(fontSize: 16)),
            ),
            const Divider(height: 1, indent: 20, endIndent: 20),
            ListTile(
              leading: const Icon(Icons.height, color: Color(0xFF1AB7B0)),
              title: const Text('Chiều cao'),
              trailing: Text('${widget.userProfile.height} cm', style: const TextStyle(fontSize: 16)),
            ),
            const Divider(height: 1, indent: 20, endIndent: 20),
            ListTile(
              leading: const Icon(Icons.transgender, color: Color(0xFF1AB7B0)),
              title: const Text('Giới tính'),
              trailing: Text(widget.userProfile.gender, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(String emoji, String value, String label) {
    return Column(children: [Text(emoji, style: const TextStyle(fontSize: 24)), const SizedBox(height: 5), Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
  }
}