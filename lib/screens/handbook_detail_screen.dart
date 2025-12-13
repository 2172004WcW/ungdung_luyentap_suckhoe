import 'package:flutter/material.dart';
import '../models/handbook_topic.dart';
import '../models/thuc_pham.dart';
import '../widgets/thuc_pham_card.dart';

class HandbookDetailScreen extends StatefulWidget {
  final HandbookTopic topic;

  const HandbookDetailScreen({Key? key, required this.topic}) : super(key: key);

  @override
  State<HandbookDetailScreen> createState() => _HandbookDetailScreenState();
}

class _HandbookDetailScreenState extends State<HandbookDetailScreen> {
  late TextEditingController searchController;
  late List<ContentSection> filteredSections;
  late List<ThucPham> filteredFoods;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    filteredSections = widget.topic.sections;
    filteredFoods = widget.topic.foodList ?? [];
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterContent(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSections = widget.topic.sections;
        filteredFoods = widget.topic.foodList ?? [];
      } else {
        // Filter sections
        filteredSections = widget.topic.sections
            .where(
              (section) =>
                  section.title.toLowerCase().contains(query.toLowerCase()) ||
                  section.content.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        // Filter foods
        filteredFoods = (widget.topic.foodList ?? [])
            .where(
              (food) =>
                  food.ten.toLowerCase().contains(query.toLowerCase()) ||
                  (food.moTa?.toLowerCase().contains(query.toLowerCase()) ??
                      false),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
        elevation: 2,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              onChanged: _filterContent,
            ),
          ),
          // Content sections or foods
          Expanded(
            child: widget.topic.isFoodList
                ? _buildFoodList()
                : _buildContentSections(),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList() {
    if (filteredFoods.isEmpty) {
      return const Center(child: Text('Không tìm thấy thức ăn'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: filteredFoods.length,
      itemBuilder: (context, index) {
        return ThucPhamCard(
          thucPham: filteredFoods[index],
          onTap: () => _showFoodDetail(filteredFoods[index]),
        );
      },
    );
  }

  Widget _buildContentSections() {
    if (filteredSections.isEmpty) {
      return const Center(child: Text('Không tìm thấy nội dung'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: filteredSections.length,
      itemBuilder: (context, index) {
        return _buildContentCard(filteredSections[index]);
      },
    );
  }

  void _showFoodDetail(ThucPham food) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              food.ten,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Danh mục: ${food.theLoai}'),
            const SizedBox(height: 12),
            if (food.moTa != null) Text('Mô tả: ${food.moTa}'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dinh dưỡng (trên 100g)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Calo: ${food.calorie} kcal'),
                      Text('Protein: ${food.protein}g'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Carbs: ${food.carbs}g'),
                      Text('Fat: ${food.fat}g'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(ContentSection section) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(
          section.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              section.content,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
