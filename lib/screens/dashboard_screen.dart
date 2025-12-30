import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

import '../models/user_profile.dart';
import '../models/nutrition_log.dart';
import '../services/nutrition_service.dart';
import 'nutrition_tracking_screen.dart';
import 'workout_tracking_screen.dart'; 

class DashboardScreen extends StatefulWidget {
  final UserProfile userProfile;

  const DashboardScreen({super.key, required this.userProfile});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NutritionService _nutritionService = NutritionService();

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    // Lấy User ID hiện tại, nếu null thì trả về chuỗi rỗng
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header chào mừng
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Xin chào, ${widget.userProfile.name} 👋",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, d MMMM', 'vi').format(today),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(widget.userProfile.avatar.isNotEmpty 
                      ? widget.userProfile.avatar 
                      : 'assets/onboarding/1.jpg'),
                ),
              ],
            ),
            
            const SizedBox(height: 30),

            // PHẦN CALO
            StreamBuilder<DailyNutrition>(
              stream: _nutritionService.getDailyNutritionStream(today),
              builder: (context, snapshot) {
                double consumed = 0;
                double target = 2000; 

                if (snapshot.hasData) {
                  consumed = snapshot.data!.totalCalories;
                  target = snapshot.data!.targetCalories ?? 2000;
                }

                return _buildCaloriesCard(consumed, target);
              },
            ),

            const SizedBox(height: 20),

            const Text("Hoạt động hôm nay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // CARD TẬP LUYỆN
            _buildActivityCard(
              "Tập luyện", 
              "30 phút", 
              Icons.fitness_center, 
              Colors.orange,
              () {
                // --- ĐÃ SỬA TẠI ĐÂY ---
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (_) => WorkoutTrackingScreen(
                      userId: currentUserId, // Truyền ID vào đây
                    ),
                  )
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị Card Calo
  Widget _buildCaloriesCard(double consumed, double target) {
    double percent = (consumed / target).clamp(0.0, 1.0);
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => const NutritionTrackingScreen())
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1AB7B0), 
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: const Color(0xFF1AB7B0).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80, height: 80,
                  child: CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const Icon(Icons.local_fire_department, color: Colors.white, size: 32),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Calo tiêu thụ", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    "${consumed.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}",
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text("kcal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}