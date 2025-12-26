import 'handbook_topic.dart';
import 'thuc_pham.dart';

// Serialization helpers for Firestore / JSON
extension ExerciseDetailSerializable on ExerciseDetail {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'instructionImages': instructionImages,
      'theory': theory,
      'steps': steps,
    };
  }
}

ExerciseDetail exerciseDetailFromJson(Map<String, dynamic> json) {
  return ExerciseDetail(
    name: json['name'] as String? ?? '',
    image: json['image'] as String? ?? '',
    instructionImages:
        (json['instructionImages'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    theory: json['theory'] as String? ?? '',
    steps:
        (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
  );
}

extension ContentSectionSerializable on ContentSection {
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'isSupplement': isSupplement,
      'exercises': exercises?.map((e) => e.toJson()).toList(),
      'foods': foods?.map((f) => f.toJson()).toList(),
    };
  }
}

ContentSection contentSectionFromJson(Map<String, dynamic> json) {
  return ContentSection(
    title: json['title'] as String? ?? '',
    imageUrl: json['imageUrl'] as String?,
    isSupplement: json['isSupplement'] as bool? ?? false,
    exercises: (json['exercises'] as List<dynamic>?)
        ?.map(
          (e) => exerciseDetailFromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList(),
    foods: (json['foods'] as List<dynamic>?)
        ?.map((e) => ThucPham.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
  );
}

extension HandbookTopicSerializable on HandbookTopic {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'isSupplement': isSupplement,
      'sections': sections.map((s) => s.toJson()).toList(),
      'foodList': foodList?.map((f) => f.toJson()).toList(),
    };
  }
}

HandbookTopic handbookTopicFromJson(Map<String, dynamic> json) {
  return HandbookTopic(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    imageUrl: json['imageUrl'] as String? ?? '',
    isSupplement: json['isSupplement'] as bool? ?? false,
    sections:
        (json['sections'] as List<dynamic>?)
            ?.map(
              (e) =>
                  contentSectionFromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList() ??
        [],
    foodList: (json['foodList'] as List<dynamic>?)
        ?.map((e) => ThucPham.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
  );
}
