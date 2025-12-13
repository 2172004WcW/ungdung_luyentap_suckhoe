// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'user_info_screen.dart'; // Import để chuyển sang màn hình nhập tin

class OnboardingPageData {
  final String imageAsset;
  final String title;
  final String description;

  const OnboardingPageData({
    required this.imageAsset,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  final pages = const [
    OnboardingPageData(
      imageAsset: 'assets/onboarding/1.jpg',
      title: 'Tập luyện tại nhà hoặc tại gym',
      description: 'Giảm cân, tăng khối lượng cơ bắp, nâng cơ mông và sở hữu cơ bắp sắc nét hơn\nvới các kế hoạch tập luyện và dinh dưỡng\nđược lập sẵn của chúng tôi.',
    ),
    OnboardingPageData(
      imageAsset: 'assets/onboarding/2.jpg',
      title: 'Tự tạo chương trình tập luyện của riêng bạn',
      description: 'Tự tạo kế hoạch tập luyện bằng cách sử dụng cơ sở dữ liệu tập luyện đa dạng và\nmiễn phí của chúng tôi.',
    ),
    OnboardingPageData(
      imageAsset: 'assets/onboarding/3.jpg',
      title: 'Chọn một huấn luyện viên',
      description: 'Đạt kết quả nhanh chóng với các nhà vô địch thế giới! Hoàn thành bài tập của huấn\nluyện viên ở bất cứ nơi đâu, hỗ trợ trực tuyến liên tục, nhiều loại bài tập khác nhau.',
    ),
    OnboardingPageData(
      imageAsset: 'assets/onboarding/4.jpg',
      title: 'Tham gia\ncộng đồng tập luyện',
      description: 'Chia sẻ kết quả của bạn trong Sports Feed\nvà đặt câu hỏi; gặp gỡ các thành viên khác\ncủa cộng đồng.\n\nCó một lượng người theo dõi tích cực\ngiúp cho ứng dụng trở nên thu hút hơn.',
    ),
  ];

  bool get isLast => _index == pages.length - 1;

  void _skip() {
    _controller.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _nextOrFinish() {
    if (isLast) {
      // Chuyển sang màn hình nhập thông tin
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const UserInfoScreen()),
      );
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF1AB7B0);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: _skip,
                    child: const Text(
                      'Bỏ qua',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final p = pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    // Dùng ListView để tránh lỗi viền vàng
                    child: ListView(
                      children: [
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: AspectRatio(
                              aspectRatio: 1.25,
                              child: Image.asset(
                                p.imageAsset,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          p.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.45,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (i) {
                  final isActive = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isActive ? teal : const Color(0xFFD9D9D9),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: isLast
                    ? FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _nextOrFinish,
                        child: const Text('BẮT ĐẦU',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      )
                    : OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFBDBDBD)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _nextOrFinish,
                        child: const Text('TIẾP',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}