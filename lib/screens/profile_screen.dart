// lib/screens/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'edit_profile_screen.dart';
import '../services/auth_service.dart'; // THÊM IMPORT
import '../services/storage_service.dart'; // THÊM IMPORT
import 'login_screen.dart'; // THÊM IMPORT

class ProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserProfile) onProfileChanged; 

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.onProfileChanged,
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
      widget.onProfileChanged(updatedData);
    }
  }

  // --- HÀM XỬ LÝ ĐĂNG XUẤT (MỚI THÊM) ---
  void _handleLogout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đăng xuất"),
        content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Đồng ý", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => const Center(child: CircularProgressIndicator(color: Color(0xFF1AB7B0))),
      );

      await AuthService().signOut();
      await StorageService.clearAll();

      if (!mounted) return;
      Navigator.pop(context); // Tắt loading

      // Về màn hình đăng nhập
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi đăng xuất: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Đổi màu nền cho đẹp hơn chút
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, size: 30, color: Color(0xFF1AB7B0)),
            onPressed: _navigateToEdit,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF1AB7B0), width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _getAvatarImage(widget.userProfile.avatar),
                      ),
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
                ],
              ),
            ),
            
            const SizedBox(height: 20),
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

            const SizedBox(height: 20),
            
            // Danh sách thông tin
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.cake, color: Color(0xFF1AB7B0)),
                    title: const Text('Tuổi'),
                    trailing: Text('${widget.userProfile.age} tuổi', style: const TextStyle(fontSize: 16)),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.monitor_weight, color: Color(0xFF1AB7B0)),
                    title: const Text('Cân nặng'),
                    trailing: Text('${widget.userProfile.weight} kg', style: const TextStyle(fontSize: 16)),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.height, color: Color(0xFF1AB7B0)),
                    title: const Text('Chiều cao'),
                    trailing: Text('${widget.userProfile.height} cm', style: const TextStyle(fontSize: 16)),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.transgender, color: Color(0xFF1AB7B0)),
                    title: const Text('Giới tính'),
                    trailing: Text(widget.userProfile.gender, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // NÚT ĐĂNG XUẤT (MỚI THÊM)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text("Đăng xuất", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
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