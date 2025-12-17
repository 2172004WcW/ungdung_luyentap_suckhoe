import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'profile_screen.dart';
import 'handbook_screen.dart';
import 'dashboard_screen.dart';
import 'workout_tracking_screen.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile userProfile;
  const HomeScreen({super.key, required this.userProfile});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late UserProfile _currentProfile;

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.userProfile;
    StorageService.saveProfile(_currentProfile);
  }

  void _updateProfile(UserProfile newProfile) async {
    setState(() => _currentProfile = newProfile);
    await StorageService.saveProfile(newProfile);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardScreen(userProfile: _currentProfile),
      const HandbookScreen(),
      WorkoutTrackingScreen(userId: _currentProfile.id),
      ProfileScreen(userProfile: _currentProfile, onProfileChanged: _updateProfile),
    ];

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(title: const Text('Trang chủ'), automaticallyImplyLeading: false)
          : null,
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Trang chủ'),
          NavigationDestination(icon: Icon(Icons.book_outlined), selectedIcon: Icon(Icons.book), label: 'Sổ tay'),
          NavigationDestination(icon: Icon(Icons.fitness_center_outlined), selectedIcon: Icon(Icons.fitness_center), label: 'Tập luyện'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}
