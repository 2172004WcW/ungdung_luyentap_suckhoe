import 'package:flutter/material.dart';
import '../models/thuc_pham.dart';

class SpecificContentScreen extends StatelessWidget {
  final ThucPham food;
  const SpecificContentScreen({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Kiến thức",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF1AB7B0),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh đã được thu nhỏ và bo góc nhẹ
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  food.hinhAnh,
                  width: double.infinity,
                  height: 180, // Giảm từ 250 xuống 180 cho cân đối
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề vừa vặn
                  Text(
                    food.ten,
                    style: const TextStyle(
                      fontSize: 22, // Chỉnh xuống 22 cho tinh tế
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Thanh gạch chân
                  Container(
                    height: 3,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1AB7B0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nội dung mô tả căn biên đều 2 bên
                  Text(
                    food.moTa,
                    textAlign: TextAlign.justify, // Căn lề đều cho đẹp
                    style: TextStyle(
                      fontSize: 15, // Size 15 là chuẩn nhất để đọc nội dung dài
                      height: 1.6,
                      color: Colors.grey[800],
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 30), // Khoảng trống cuối trang
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
