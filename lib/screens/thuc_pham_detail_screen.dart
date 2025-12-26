import 'package:flutter/material.dart';
import '../models/thuc_pham.dart';
import '../services/handbook_firestore_service.dart';
import '../models/handbook_topic.dart';

class ThucPhamDetailScreen extends StatelessWidget {
  final String topicId;
  final String thucPhamId;
  final ThucPham? initialThucPham;

  const ThucPhamDetailScreen({
    Key? key,
    required this.topicId,
    required this.thucPhamId,
    this.initialThucPham,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HandbookTopic?>(
      stream: HandbookFirestoreService().topicStream(topicId),
      builder: (context, snapshot) {
        final topic = snapshot.data;
        ThucPham? thucPham = initialThucPham;
        if (topic != null) {
          for (var s in topic.sections) {
            final found = s.foods?.firstWhere(
              (f) => f.id == thucPhamId,
              orElse: () =>
                  ThucPham(id: '', ten: '', theLoai: '', hinhAnh: '', moTa: ''),
            );
            if (found != null && found.id.isNotEmpty) {
              thucPham = found;
              break;
            }
          }
        }

        // If still null, show message
        if (thucPham == null || thucPham.id.isEmpty) {
          return Scaffold(
            appBar: AppBar(backgroundColor: const Color(0xFF1AB7B0)),
            body: const Center(
              child: Text('Không tìm thấy thông tin thực phẩm'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              thucPham.theLoai, // Hiển thị thể loại trên thanh tiêu đề
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF1AB7B0),
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0, // Làm thanh AppBar phẳng cho hiện đại
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Ảnh lớn phía trên
                Container(
                  width: double.infinity,
                  height: 300,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color:
                        Colors.grey[50], // Nền nhạt giúp làm nổi bật sản phẩm
                  ),
                  child: Hero(
                    tag: thucPham.id, // Hiệu ứng Hero khi chuyển trang
                    child: Image.asset(thucPham.hinhAnh, fit: BoxFit.contain),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 25.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Tiêu đề tên sản phẩm
                      Text(
                        thucPham.ten,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 3. Đường kẻ trang trí nhẹ
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1AB7B0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 4. Nội dung mô tả chi tiết
                      Text(
                        thucPham.moTa,
                        textAlign: TextAlign
                            .justify, // Căn lề hai bên như hình 2 bạn gửi
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.7, // Khoảng cách dòng rộng rãi, dễ đọc
                          color: Color(0xFF444444), // Màu xám đậm chuyên nghiệp
                        ),
                      ),
                      const SizedBox(height: 40), // Khoảng trống cuối trang
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
