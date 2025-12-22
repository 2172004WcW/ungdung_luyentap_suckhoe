import 'package:flutter/material.dart';
import '../models/handbook_topic.dart';
import 'handbook_detail_screen.dart';

class HandbookScreen extends StatefulWidget {
  const HandbookScreen({Key? key}) : super(key: key);

  @override
  State<HandbookScreen> createState() => _HandbookScreenState();
}

class _HandbookScreenState extends State<HandbookScreen> {
  // Định nghĩa màu chủ đạo 1AB7B0
  static const Color primaryColor = Color(0xFF1AB7B0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Sổ tay sức khỏe',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevation: 0, // Phẳng hóa để hiện đại hơn
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 16,
          childAspectRatio: 2.2, // Tăng nhẹ chiều cao để không bị ép chữ
        ),
        itemCount: HandbookData.topics.length,
        itemBuilder: (context, index) {
          final topic = HandbookData.topics[index];
          return _buildTopicCard(context, topic);
        },
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, HandbookTopic topic) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HandbookDetailScreen(topic: topic),
                ),
              );
            },
            child: Stack(
              children: [
                // Hình nền chủ đề
                Positioned.fill(
                  child: Image.asset(topic.imageUrl, fit: BoxFit.cover),
                ),

                // Lớp phủ Gradient (Thay cho màu đen đơn thuần để sang trọng hơn)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                ),

                // Nội dung văn bản
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Vạch màu trang trí đồng bộ
                      Container(
                        width: 40,
                        height: 3,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(
                        topic.title,
                        style: const TextStyle(
                          fontSize: 22, // Chữ to rõ hơn
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        topic.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                // Icon mũi tên nhỏ ở góc
                const Positioned(
                  right: 15,
                  bottom: 15,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
