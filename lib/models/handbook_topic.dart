import '../models/thuc_pham.dart';

/// Model for handbook topics/categories
class HandbookTopic {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<ContentSection> sections;
  final List<ThucPham>? foodList; // Danh sách thực phẩm tùy chọn
  final bool isSupplement;

  HandbookTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.sections,
    this.foodList,
    this.isSupplement = false,
  });

  bool get isFoodList => foodList != null && foodList!.isNotEmpty;
}

class ExerciseDetail {
  final String name;
  final String image; // Ảnh đại diện ở danh sách ngoài
  final List<String> instructionImages; // Danh sách ảnh hướng dẫn (47-56)
  final String theory;
  final List<String> steps;

  ExerciseDetail({
    required this.name,
    required this.image,
    required this.instructionImages, // Thêm cái này
    this.theory = "",
    this.steps = const [],
  });
}

/// Content section within a topic - Đã loại bỏ hoàn toàn content
class ContentSection {
  final String title;
  final String? imageUrl;
  final List<ExerciseDetail>? exercises;
  final List<ThucPham>? foods;
  final bool isSupplement;
  ContentSection({
    required this.title,
    this.imageUrl,
    this.exercises,
    this.foods,
    this.isSupplement = false,
  });
}

// Local sample dataset removed. If you need to add local samples later,
// create a separate helper that returns valid `HandbookTopic` instances.
