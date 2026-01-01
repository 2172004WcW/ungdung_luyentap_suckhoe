import 'package:flutter/material.dart';
import '../models/handbook_topic.dart';
import '../models/thuc_pham.dart';
import '../widgets/thuc_pham_card.dart';
import 'exercise_list_screen.dart';
import 'ThucPham_List_Screen.dart';
import 'specific_content_screen.dart';
import '../services/handbook_firestore_service.dart';

class HandbookDetailScreen extends StatefulWidget {
  final String topicId;
  final HandbookTopic? initialTopic; // fallback
  final bool showAppBar;
  const HandbookDetailScreen({
    Key? key,
    required this.topicId,
    this.initialTopic,
    this.showAppBar = true,
  }) : super(key: key);

  @override
  State<HandbookDetailScreen> createState() => _HandbookDetailScreenState();
}

class _HandbookDetailScreenState extends State<HandbookDetailScreen> {
  late TextEditingController searchController;
  late List<ContentSection> filteredSections;
  late List<ThucPham> filteredFoods;
  HandbookTopic? currentTopic;

  static const Color primaryColor = Color(0xFF1AB7B0);

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    currentTopic = widget.initialTopic;
    filteredSections = currentTopic?.sections ?? [];
    filteredFoods = currentTopic?.foodList ?? [];
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterContent(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSections = currentTopic?.sections ?? [];
        filteredFoods = currentTopic?.foodList ?? [];
      } else {
        filteredSections = (currentTopic?.sections ?? [])
            .where((s) => s.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
        filteredFoods = (currentTopic?.foodList ?? [])
            .where((f) => f.ten.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(
                currentTopic?.title ?? widget.initialTopic?.title ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            )
          : null,
      body: StreamBuilder<HandbookTopic?>(
        stream: HandbookFirestoreService().topicStream(widget.topicId),
        builder: (context, snapshot) {
          // if Firestore provides data, use it; otherwise fall back to initialTopic
          currentTopic = snapshot.data ?? widget.initialTopic ?? currentTopic;
          filteredSections = currentTopic?.sections ?? [];
          filteredFoods = currentTopic?.foodList ?? [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm nội dung...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFFF5F7F9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _filterContent,
                ),
              ),
              Expanded(
                child: (currentTopic?.isFoodList ?? false)
                    ? _buildFoodList()
                    : _buildContentSections(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContentSections() {
    if (filteredSections.isEmpty) {
      return const Center(child: Text('Không tìm thấy nội dung'));
    }

    // SỬA TẠI ĐÂY: Thêm ID '4' vào danh sách hiển thị kiểu Row (giống Topic 2)
    final t = currentTopic ?? widget.initialTopic;
    final id = t?.id;
    final title = t?.title;
    bool isStyleWithRow =
        (id == '2') || (id == '4') || (title?.contains('Dược lý học') ?? false);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredSections.length,
      itemBuilder: (context, index) {
        final section = filteredSections[index];
        return isStyleWithRow
            ? _buildNutritionRow(section) // Hiển thị: Ảnh trái - Chữ phải
            : _buildCategoryCard(
                section,
              ); // Hiển thị: Chữ đè lên ảnh (Kiểu Card)
      },
    );
  }

  // --- STYLE CHO TOPIC 2: ẢNH TRÁI CHỮ PHẢI - CHỈNH TO VÀ ĐẦY ĐẶN HƠN ---
  Widget _buildNutritionRow(ContentSection section) {
    return InkWell(
      onTap: () => _handleNavigation(section),
      child: Container(
        // Tăng padding dọc để hàng nhìn "dài" và thoáng hơn
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white, // Thêm nền trắng
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
        ),
        child: Row(
          children: [
            // Khối chứa ảnh: Tăng kích thước từ 60 lên 90 để nhìn đầy đặn
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F9), // Nền nhẹ cho ảnh
                borderRadius: BorderRadius.circular(15), // Bo góc ảnh đẹp hơn
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: section.imageUrl != null
                    ? Image.asset(
                        section.imageUrl!,
                        fit: BoxFit.contain,
                        // Thêm padding nhỏ để ảnh không sát mép khung
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.fastfood, color: primaryColor),
                      )
                    : const Icon(
                        Icons.inventory_2,
                        color: primaryColor,
                        size: 40,
                      ),
              ),
            ),
            const SizedBox(width: 20),
            // Khối chứa chữ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 19, // Tăng cỡ chữ tiêu đề
                      fontWeight: FontWeight.bold, // Làm đậm hơn
                      color: Colors.black87,
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 4),
                  // Thêm dòng phụ hoặc khoảng cách để nhìn đầy đặn hơn
                  Text(
                    "Xem chi tiết danh mục",
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            // Icon mũi tên chỉ hướng
            Icon(Icons.arrow_forward_ios, color: Colors.grey[300], size: 18),
          ],
        ),
      ),
    );
  }

  // --- STYLE CHO TOPIC 1 & 3: CARD LỚN, CHỮ ĐÈ LÊN ẢNH ---
  Widget _buildCategoryCard(ContentSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 180, // Chiều cao thẻ
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _handleNavigation(section),
          child: Stack(
            children: [
              // 1. Ảnh nền
              Positioned.fill(
                child: section.imageUrl != null
                    ? Image.asset(section.imageUrl!, fit: BoxFit.cover)
                    : Container(color: Colors.grey[200]),
              ),
              // 2. Lớp phủ Gradient để chữ trắng dễ đọc hơn
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // 3. Phần tiêu đề và Icon
              Positioned(
                left: 16,
                right: 60, // Chừa chỗ cho icon mũi tên
                bottom: 16,
                child: Text(
                  section.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                  ),
                  softWrap: true, // Tự động xuống dòng nếu chữ dài
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Positioned(
                right: 16,
                bottom: 16,
                child: Icon(
                  Icons.arrow_circle_right,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(ContentSection section) {
    // 1. Xử lý trường hợp có danh sách foods (Thực phẩm/Kiến thức)
    if (section.foods != null && section.foods!.isNotEmpty) {
      // KIỂM TRA: Nếu là Topic ID '5' (Bách khoa toàn thư)
      if ((currentTopic?.id ?? widget.initialTopic?.id) == '5') {
        // Bỏ qua màn hình danh sách (Hình 1), bay thẳng vào chi tiết (Hình 2)
        // Lưu ý: Ở đây tôi dùng Navigator để đẩy sang trang mới.
        // Bạn hãy tạo Class 'SpecificContentScreen' như tôi hướng dẫn ở dưới để hết lỗi đỏ.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpecificContentScreen(
              topicId: widget.topicId,
              thucPhamId: section.foods![0].id,
              initialFood: section.foods![0],
            ),
          ),
        );
      } else {
        // Các Topic khác (Dinh dưỡng, Supplement...) vẫn hiện danh sách như cũ (Hình 1)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ThucPhamListScreen(
              title: section.title,
              topicId: widget.topicId,
              items: section.foods!,
              isSupplement: section.isSupplement,
            ),
          ),
        );
      }
    }
    // 2. Xử lý trường hợp có danh sách exercises (Bài tập)
    else if (section.exercises != null && section.exercises!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExerciseListScreen(
            title: section.title,
            topicId: widget.topicId,
            initialExercises: section.exercises!,
          ),
        ),
      );
    }
  }

  // --- DANH SÁCH THỰC PHẨM CHI TIẾT ---
  Widget _buildFoodList() {
    if (filteredFoods.isEmpty) {
      return const Center(child: Text('Không tìm thấy thực phẩm'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredFoods.length,
      itemBuilder: (context, index) => ThucPhamCard(
        thucPham: filteredFoods[index],
        onTap: () => _showFoodDetail(filteredFoods[index]),
      ),
    );
  }

  void _showFoodDetail(ThucPham food) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              food.ten,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFoodInfoBox('Năng lượng', '${food.calorie}', 'kcal'),
                _buildFoodInfoBox('Đạm', '${food.protein}', 'g'),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodInfoBox(String label, String value, String unit) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
