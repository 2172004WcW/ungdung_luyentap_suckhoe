// lib/screens/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'edit_profile_screen.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'login_screen.dart';

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
  // Màu chủ đạo
  final Color _primaryColor = const Color(0xFF1AB7B0);

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

  // --- HÀM XỬ LÝ ĐĂNG XUẤT ---
  void _handleLogout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Đăng xuất"),
        content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Đồng ý", style: TextStyle(color: Colors.white)),
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
        builder: (c) => Center(child: CircularProgressIndicator(color: _primaryColor)),
      );

      await AuthService().signOut();
      await StorageService.clearAll();

      if (!mounted) return;
      Navigator.pop(context); // Tắt loading

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
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero, // Bỏ padding mặc định để header tràn viền
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 60), // Khoảng trống bù cho Avatar đè lên
            _buildNameAndGoal(),
            const SizedBox(height: 20),
            _buildStatsCard(),
            const SizedBox(height: 20),
            _buildBodyInfoCard(),
            const SizedBox(height: 30),
            _buildLogoutButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 1. Header cong với background màu và nút Edit
  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none, // Cho phép avatar tràn ra ngoài
      alignment: Alignment.center,
      children: [
        // Background cong
        Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        // Nút Edit ở góc phải
        Positioned(
          top: 40,
          right: 20,
          child: IconButton(
            onPressed: _navigateToEdit,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.white),
            ),
          ),
        ),
        // Avatar nằm đè lên
        Positioned(
          bottom: -50,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: _getAvatarImage(widget.userProfile.avatar),
            ),
          ),
        ),
      ],
    );
  }

  // 2. Tên và Mục tiêu
  Widget _buildNameAndGoal() {
    return Column(
      children: [
        Text(
          widget.userProfile.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.userProfile.goal,
            style: TextStyle(color: _primaryColor, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  // 3. Thẻ thống kê (Stats)
  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('🔥', '1,250', 'Kcal'),
          Container(height: 40, width: 1, color: Colors.grey.shade200),
          _buildStatItem('⏱️', '45', 'Phút'),
          Container(height: 40, width: 1, color: Colors.grey.shade200),
          _buildStatItem('📅', '7', 'Ngày'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // 4. Thông tin chỉ số cơ thể
  Widget _buildBodyInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Icon(Icons.person_outline, color: _primaryColor),
                const SizedBox(width: 10),
                const Text("Thông tin cơ thể", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildInfoRow("Tuổi", "${widget.userProfile.age} tuổi"),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildInfoRow("Cân nặng", "${widget.userProfile.weight} kg"),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildInfoRow("Chiều cao", "${widget.userProfile.height} cm"),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildInfoRow("Giới tính", widget.userProfile.gender),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 15)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        ],
      ),
    );
  }

  // 5. Nút Đăng xuất
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.redAccent,
            elevation: 0,
            side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          onPressed: _handleLogout,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded),
              SizedBox(width: 10),
              Text("Đăng xuất", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}