import '../models/exercise.dart';

/// Thư viện bài tập mẫu
class ExerciseLibrary {
  static final List<Exercise> exercises = [
    // Ngực
    Exercise(
      id: 'ex_1',
      name: 'Push-up',
      description: 'Bài tập cơ bản cho ngực, vai và tay',
      muscleGroup: 'Ngực',
      equipment: 'Bodyweight',
      difficulty: 'Dễ',
      instructions: [
        'Nằm sấp, tay đặt rộng bằng vai',
        'Đẩy người lên cho đến khi tay thẳng',
        'Hạ xuống từ từ, gần chạm sàn',
        'Lặp lại động tác',
      ],
    ),
    Exercise(
      id: 'ex_2',
      name: 'Bench Press',
      description: 'Bài tập tạ nằm cho ngực',
      muscleGroup: 'Ngực',
      equipment: 'Tạ',
      difficulty: 'Trung bình',
      instructions: [
        'Nằm trên ghế, tay cầm tạ rộng bằng vai',
        'Hạ tạ từ từ xuống ngực',
        'Đẩy tạ lên mạnh mẽ',
        'Lặp lại',
      ],
    ),
    Exercise(
      id: 'ex_3',
      name: 'Dumbbell Flyes',
      description: 'Bài tập mở rộng ngực với tạ đơn',
      muscleGroup: 'Ngực',
      equipment: 'Tạ',
      difficulty: 'Trung bình',
      instructions: [
        'Nằm trên ghế, tay cầm tạ đơn',
        'Mở rộng tay sang hai bên',
        'Đưa tạ về vị trí ban đầu',
        'Lặp lại',
      ],
    ),

    // Lưng
    Exercise(
      id: 'ex_4',
      name: 'Pull-up',
      description: 'Kéo xà đơn cho lưng và tay',
      muscleGroup: 'Lưng',
      equipment: 'Bodyweight',
      difficulty: 'Khó',
      instructions: [
        'Treo người trên xà',
        'Kéo người lên cho đến khi cằm qua xà',
        'Hạ xuống từ từ',
        'Lặp lại',
      ],
    ),
    Exercise(
      id: 'ex_5',
      name: 'Bent Over Row',
      description: 'Kéo tạ cho lưng',
      muscleGroup: 'Lưng',
      equipment: 'Tạ',
      difficulty: 'Trung bình',
      instructions: [
        'Đứng cúi người, tay cầm tạ',
        'Kéo tạ lên về phía ngực',
        'Hạ xuống từ từ',
        'Lặp lại',
      ],
    ),

    // Chân
    Exercise(
      id: 'ex_6',
      name: 'Squat',
      description: 'Bài tập cơ bản cho chân và mông',
      muscleGroup: 'Chân',
      equipment: 'Bodyweight',
      difficulty: 'Dễ',
      instructions: [
        'Đứng thẳng, chân rộng bằng vai',
        'Hạ người xuống như ngồi ghế',
        'Đứng lên về vị trí ban đầu',
        'Lặp lại',
      ],
    ),
    Exercise(
      id: 'ex_7',
      name: 'Deadlift',
      description: 'Nâng tạ từ sàn cho lưng và chân',
      muscleGroup: 'Chân',
      equipment: 'Tạ',
      difficulty: 'Khó',
      instructions: [
        'Đứng trước tạ, chân rộng bằng vai',
        'Cúi xuống nắm tạ, lưng thẳng',
        'Đứng lên, nâng tạ',
        'Hạ xuống từ từ',
        'Lặp lại',
      ],
    ),
    Exercise(
      id: 'ex_8',
      name: 'Lunges',
      description: 'Bước chân về phía trước',
      muscleGroup: 'Chân',
      equipment: 'Bodyweight',
      difficulty: 'Trung bình',
      instructions: [
        'Đứng thẳng, bước một chân về phía trước',
        'Hạ người xuống, đầu gối sau gần chạm sàn',
        'Đẩy lên, trở về vị trí ban đầu',
        'Đổi chân và lặp lại',
      ],
    ),

    // Tay
    Exercise(
      id: 'ex_9',
      name: 'Bicep Curl',
      description: 'Cuốn tạ cho cơ tay trước',
      muscleGroup: 'Tay',
      equipment: 'Tạ',
      difficulty: 'Dễ',
      instructions: [
        'Đứng thẳng, tay cầm tạ',
        'Cuốn tạ lên về phía vai',
        'Hạ xuống từ từ',
        'Lặp lại',
      ],
    ),
    Exercise(
      id: 'ex_10',
      name: 'Tricep Dips',
      description: 'Đẩy người cho cơ tay sau',
      muscleGroup: 'Tay',
      equipment: 'Bodyweight',
      difficulty: 'Trung bình',
      instructions: [
        'Ngồi trên mép ghế, tay đặt cạnh hông',
        'Trượt người xuống, gập khuỷu tay',
        'Đẩy lên về vị trí ban đầu',
        'Lặp lại',
      ],
    ),

    // Vai
    Exercise(
      id: 'ex_11',
      name: 'Shoulder Press',
      description: 'Đẩy tạ qua đầu cho vai',
      muscleGroup: 'Vai',
      equipment: 'Tạ',
      difficulty: 'Trung bình',
      instructions: [
        'Ngồi hoặc đứng, tay cầm tạ ngang vai',
        'Đẩy tạ lên qua đầu',
        'Hạ xuống về vị trí ban đầu',
        'Lặp lại',
      ],
    ),
    Exercise(
      id: 'ex_12',
      name: 'Lateral Raise',
      description: 'Nâng tạ sang ngang cho vai',
      muscleGroup: 'Vai',
      equipment: 'Tạ',
      difficulty: 'Dễ',
      instructions: [
        'Đứng thẳng, tay cầm tạ đơn',
        'Nâng tay sang ngang đến ngang vai',
        'Hạ xuống từ từ',
        'Lặp lại',
      ],
    ),

    // Bụng
    Exercise(
      id: 'ex_13',
      name: 'Crunches',
      description: 'Gập bụng cơ bản',
      muscleGroup: 'Bụng',
      equipment: 'Bodyweight',
      difficulty: 'Dễ',
      instructions: [
        'Nằm ngửa, đầu gối gập',
        'Nâng đầu và vai lên',
        'Hạ xuống từ từ',
        'Lặp lại',
      ],
    ),
    Exercise(
      id: 'ex_14',
      name: 'Plank',
      description: 'Giữ tư thế plank cho core',
      muscleGroup: 'Bụng',
      equipment: 'Bodyweight',
      difficulty: 'Trung bình',
      instructions: [
        'Nằm sấp, chống tay và mũi chân',
        'Giữ lưng thẳng, cơ bụng căng',
        'Giữ tư thế trong 30-60 giây',
      ],
    ),
    Exercise(
      id: 'ex_15',
      name: 'Leg Raises',
      description: 'Nâng chân cho bụng dưới',
      muscleGroup: 'Bụng',
      equipment: 'Bodyweight',
      difficulty: 'Trung bình',
      instructions: [
        'Nằm ngửa, tay đặt dưới mông',
        'Nâng chân lên thẳng đứng',
        'Hạ xuống từ từ, không chạm sàn',
        'Lặp lại',
      ],
    ),

    // Cardio
    Exercise(
      id: 'ex_16',
      name: 'Jumping Jacks',
      description: 'Nhảy dang tay chân',
      muscleGroup: 'Cardio',
      equipment: 'Bodyweight',
      difficulty: 'Dễ',
      instructions: [
        'Đứng thẳng, tay xuôi',
        'Nhảy lên, dang tay và chân',
        'Nhảy về vị trí ban đầu',
        'Lặp lại nhanh',
      ],
    ),
    Exercise(
      id: 'ex_17',
      name: 'Burpees',
      description: 'Bài tập toàn thân cường độ cao',
      muscleGroup: 'Cardio',
      equipment: 'Bodyweight',
      difficulty: 'Khó',
      instructions: [
        'Đứng thẳng',
        'Hạ xuống, chống tay, nhảy chân ra sau',
        'Làm một push-up',
        'Nhảy chân về, đứng lên, nhảy lên',
        'Lặp lại',
      ],
    ),
    Exercise(
      id: 'ex_18',
      name: 'Mountain Climbers',
      description: 'Chạy tại chỗ trong tư thế plank',
      muscleGroup: 'Cardio',
      equipment: 'Bodyweight',
      difficulty: 'Trung bình',
      instructions: [
        'Bắt đầu ở tư thế plank',
        'Chạy chân tại chỗ, đổi chân nhanh',
        'Giữ lưng thẳng',
        'Tiếp tục trong 30-60 giây',
      ],
    ),
  ];

  /// Lấy bài tập theo nhóm cơ
  static List<Exercise> getByMuscleGroup(String muscleGroup) {
    return exercises.where((e) => e.muscleGroup == muscleGroup).toList();
  }

  /// Lấy bài tập theo độ khó
  static List<Exercise> getByDifficulty(String difficulty) {
    return exercises.where((e) => e.difficulty == difficulty).toList();
  }

  /// Tìm kiếm bài tập
  static List<Exercise> search(String query) {
    final lowerQuery = query.toLowerCase();
    return exercises
        .where((e) =>
            e.name.toLowerCase().contains(lowerQuery) ||
            e.description.toLowerCase().contains(lowerQuery) ||
            e.muscleGroup.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

