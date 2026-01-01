/// Model cho bài tập
class Exercise {
  final String id;
  final String name;
  final String description;
  final String muscleGroup; // Nhóm cơ: Ngực, Lưng, Chân, Tay, Vai, Bụng
  final String equipment; // Dụng cụ: Tạ, Bodyweight, Máy, Dây
  final String? imageUrl;
  final String? videoUrl;
  final List<String>? instructionImages;
  final List<String> instructions; // Hướng dẫn thực hiện
  final String? theory;
  final String difficulty; // Dễ, Trung bình, Khó
  final int? durationSeconds;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.muscleGroup,
    required this.equipment,
    this.imageUrl,
    this.videoUrl,
    this.instructionImages,
    required this.instructions,
    this.theory,
    required this.difficulty,
    this.durationSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'muscleGroup': muscleGroup,
      'equipment': equipment,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'instructionImages': instructionImages,
      'instructions': instructions,
      'theory': theory,
      'difficulty': difficulty,
      'durationSeconds': durationSeconds,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      muscleGroup: json['muscleGroup'] as String,
      equipment: json['equipment'] as String,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      instructionImages: json['instructionImages'] != null
          ? List<String>.from(json['instructionImages'] as List)
          : null,
      instructions: List<String>.from(json['instructions'] as List),
      theory: json['theory'] as String?,
      difficulty: json['difficulty'] as String,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
    );
  }
}

/// Model cho set trong bài tập
class ExerciseSet {
  final int reps; // Số lần lặp
  final double? weight; // Trọng lượng (kg), null nếu bodyweight
  final int? restSeconds; // Thời gian nghỉ (giây)

  ExerciseSet({required this.reps, this.weight, this.restSeconds});

  Map<String, dynamic> toJson() {
    return {'reps': reps, 'weight': weight, 'restSeconds': restSeconds};
  }

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      reps: json['reps'] as int,
      weight: json['weight'] as double?,
      restSeconds: json['restSeconds'] as int?,
    );
  }
}

/// Model cho bài tập trong buổi tập
class WorkoutExercise {
  final Exercise exercise;
  final List<ExerciseSet> sets;
  final String? notes; // Ghi chú

  WorkoutExercise({required this.exercise, required this.sets, this.notes});

  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise.toJson(),
      'sets': sets.map((s) => s.toJson()).toList(),
      'notes': notes,
    };
  }

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      exercise: Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
      sets: (json['sets'] as List)
          .map((s) => ExerciseSet.fromJson(s as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );
  }
}
