// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'profile_screen.dart'; // Import màn hình hồ sơ
import 'handbook_screen.dart'; // Import màn hình sổ tay

class HomeScreen extends StatefulWidget {
  final UserProfile userProfile;

  const HomeScreen({super.key, required this.userProfile});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // 0: Trang chủ, 1: Sổ tay, 2: Tập luyện, 3: Hồ sơ
  late UserProfile _currentProfile;

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.userProfile;
  }

  // Hàm cập nhật Profile khi sửa xong (từ tab Hồ sơ)
  void _updateProfile(UserProfile newProfile) {
    setState(() {
      _currentProfile = newProfile;
    });
  }

  // Giao diện cho TAB 1: TRANG CHỦ (Viết hàm riêng cho gọn)
  Widget _buildHomeTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Xin chào, ${_currentProfile.name}!',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Mục tiêu hiện tại:',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            _currentProfile.goal.toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1AB7B0),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF1AB7B0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monitor_weight, color: Color(0xFF1AB7B0)),
                const SizedBox(width: 10),
                Text(
                  'Cân nặng: ${_currentProfile.weight} kg',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Danh sách các màn hình
    final List<Widget> pages = [
      _buildHomeTab(), // Tab 0
      const HandbookScreen(), // Tab 1: Sổ tay
      const Center(child: Text('Màn hình Bài tập (Đang phát triển)')), // Tab 2
      ProfileScreen(
        // Tab 3
        userProfile: _currentProfile,
        onProfileChanged: _updateProfile,
      ),
    ];

    return Scaffold(
      // Nếu ở tab Home hoặc Tập luyện thì hiện AppBar, tab Profile thì ẩn (vì ProfileScreen đã có AppBar riêng)
      appBar: _selectedIndex != 3
          ? AppBar(
              title: const Text('Fitness App'),
              automaticallyImplyLeading: false,
            )
          : null,

      body: pages[_selectedIndex], // Hiển thị nội dung theo tab đang chọn

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Sổ tay',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Tập luyện',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}
