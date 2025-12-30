// lib/screens/plan_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';

class PlanSelectionScreen extends StatelessWidget {
  // 1. SỬA TÊN BIẾN: Đổi 'tempProfile' thành 'userProfile' để khớp với UserInfoScreen
  final UserProfile userProfile;

  const PlanSelectionScreen({super.key, required this.userProfile});

  final List<Map<String, String>> plans = const [
    {'title': 'Giảm mỡ toàn thân', 'desc': 'Đốt cháy calo tối đa với các bài cardio cường độ cao.', 'goal': 'Giảm cân'},
    {'title': 'Tăng cơ bắp cơ bản', 'desc': 'Xây dựng nền tảng cơ bắp vững chắc cho người mới.', 'goal': 'Tăng cơ'},
    {'title': 'Cơ bụng 6 múi', 'desc': 'Tập trung vào nhóm cơ core và giảm mỡ bụng.', 'goal': 'Tăng cơ'},
    {'title': 'Yoga thư giãn', 'desc': 'Cải thiện độ dẻo dai và giảm căng thẳng.', 'goal': 'Duy trì vóc dáng'},
    {'title': 'Cardio HIIT', 'desc': 'Bài tập cường độ cao ngắt quãng giúp tim khỏe mạnh.', 'goal': 'Nâng cao sức bền'},
    {'title': 'Tăng sức mạnh', 'desc': 'Tập tạ nặng để tăng sức mạnh tổng thể.', 'goal': 'Tăng cơ'},
    {'title': 'Bodyweight tại nhà', 'desc': 'Không cần dụng cụ, chỉ sử dụng trọng lượng cơ thể.', 'goal': 'Duy trì vóc dáng'},
    {'title': 'Chạy bộ 5K', 'desc': 'Giáo án luyện tập để chinh phục cự ly 5km.', 'goal': 'Nâng cao sức bền'},
    {'title': 'Giãn cơ phục hồi', 'desc': 'Nhẹ nhàng, giúp cơ thể phục hồi sau chấn thương.', 'goal': 'Duy trì vóc dáng'},
    {'title': 'Thử thách 30 ngày', 'desc': 'Lịch trình nghiêm ngặt để thay đổi bản thân trong 1 tháng.', 'goal': 'Giảm cân'},
  ];

  // HÀM XỬ LÝ LƯU DỮ LIỆU
  Future<void> _handlePlanSelection(BuildContext context, Map<String, String> plan) async {
    // 2. Cập nhật thông tin vào biến userProfile
    userProfile.goal = plan['goal']!;
    userProfile.workoutPlan = plan['title']!;

    try {
      // Hiển thị vòng xoay chờ
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF1AB7B0))),
      );

      // 3. LƯU LÊN FIREBASE (QUAN TRỌNG: Thêm cờ isInfoCompleted)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userProfile.id)
          .set({
            ...userProfile.toMap(), // Lấy toàn bộ dữ liệu profile
            'isInfoCompleted': true, // Đánh dấu ĐÃ HOÀN TẤT để lần sau vào thẳng Home
          }, SetOptions(merge: true)); // Dùng merge để an toàn hơn

      // 4. LƯU VÀO BỘ NHỚ MÁY
      await StorageService.saveProfile(userProfile);

      // Tắt loading
      if (!context.mounted) return;
      Navigator.pop(context);

      // 5. CHUYỂN VÀO MÀN HÌNH CHÍNH (Xóa hết lịch sử back để không quay lại được)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(userProfile: userProfile),
        ),
        (route) => false,
      );
    } catch (e) {
      // Tắt loading nếu lỗi
      if (context.mounted) Navigator.pop(context);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu dữ liệu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn kế hoạch tập')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Dựa trên thông tin của bạn, hãy chọn một lộ trình phù hợp:',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _handlePlanSelection(context, plan),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1AB7B0).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1AB7B0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan['title']!,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  plan['desc']!,
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    plan['goal']!,
                                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}