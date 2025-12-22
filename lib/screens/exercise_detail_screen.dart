import 'package:flutter/material.dart';
import '../models/handbook_topic.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final ExerciseDetail exercise;

  const ExerciseDetailScreen({Key? key, required this.exercise})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Màu chủ đạo xanh Teal hiện đại
    const primaryColor = Color(0xFF1AB7B0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          exercise.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Khu vực hiển thị ảnh hướng dẫn
            if (exercise.instructionImages.isNotEmpty)
              Container(
                height: 320,
                width: double.infinity,
                color: Colors.white,
                child: PageView.builder(
                  itemCount: exercise.instructionImages.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      exercise.instructionImages[index],
                      fit: BoxFit.contain,
                    );
                  },
                ),
              )
            else
              Image.asset(
                exercise.image,
                height: 280,
                width: double.infinity,
                fit: BoxFit.contain,
              ),

            if (exercise.instructionImages.length > 1)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Vuốt sang để xem thêm hình ảnh",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phần Lý thuyết
                  _buildHeader('Lý thuyết', primaryColor),
                  const SizedBox(height: 10),
                  Text(
                    exercise.theory.isNotEmpty
                        ? exercise.theory
                        : 'Đang cập nhật nội dung...',
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Phần Cách tập
                  _buildHeader('Cách tập chi tiết', primaryColor),
                  const SizedBox(height: 15),
                  if (exercise.steps.isNotEmpty)
                    ...exercise.steps.asMap().entries.map((entry) {
                      return _buildStep(
                        entry.key + 1,
                        entry.value,
                        primaryColor,
                      );
                    }).toList()
                  else
                    const Text(
                      'Hướng dẫn đang được cập nhật.',
                      style: TextStyle(fontSize: 16),
                    ),

                  const SizedBox(height: 30),

                  // Phần Lưu ý an toàn (Đã đổi màu đồng bộ)
                  _buildWarningBox(primaryColor),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tiêu đề mục
  Widget _buildHeader(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Widget từng bước tập
  Widget _buildStep(int number, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color,
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 17, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // Widget hộp lưu ý
  Widget _buildWarningBox(Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Nền xanh nhạt theo màu chủ đạo
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Lưu ý: Khởi động kỹ và tập đúng kỹ thuật để tránh chấn thương.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
