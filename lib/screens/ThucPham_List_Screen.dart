import 'package:flutter/material.dart';
import '../models/thuc_pham.dart';
import '../widgets/thuc_pham_card.dart';
// Đảm bảo đường dẫn này đúng với thư mục của bạn
import 'thuc_pham_detail_screen.dart';

class ThucPhamListScreen extends StatefulWidget {
  final String title;
  final List<ThucPham> items;
  final bool isSupplement;

  const ThucPhamListScreen({
    Key? key,
    required this.title,
    required this.items,
    this.isSupplement = false,
  }) : super(key: key);

  @override
  State<ThucPhamListScreen> createState() => _ThucPhamListScreenState();
}

class _ThucPhamListScreenState extends State<ThucPhamListScreen> {
  late List<ThucPham> filteredItems;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Gán danh sách ban đầu từ widget truyền vào
    filteredItems = widget.items;
  }

  void _filterSearch(String query) {
    setState(() {
      filteredItems = widget.items
          .where((item) => item.ten.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1AB7B0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm đẹp hơn
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterSearch,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm trong ${widget.title}...',
                prefixIcon: const Icon(Icons.search, color: primaryColor),
                filled: true,
                fillColor: const Color(0xFFF5F7F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          // Danh sách Card món ăn (Hình 1 của bạn)
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text('Không tìm thấy dữ liệu'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ThucPhamCard(
                        thucPham: item,
                        // Nếu là thực phẩm bổ sung thì ẩn chỉ số nhanh,
                        // nếu là nguyên liệu thì hiện
                        showNutrition: !widget.isSupplement,
                        onTap: () {
                          // Chuyển sang trang mô tả chi tiết (Hình 2 của bạn)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ThucPhamDetailScreen(thucPham: item),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
