import '../models/thuc_pham.dart';

/// Model for handbook topics/categories
class HandbookTopic {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<ContentSection> sections;
  final List<ThucPham>? foodList; // Optional food list for ingredient topics

  HandbookTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.sections,
    this.foodList,
  });

  bool get isFoodList => foodList != null && foodList!.isNotEmpty;
}

/// Content section within a topic
class ContentSection {
  final String title;
  final String content;

  ContentSection({required this.title, required this.content});
}

/// Sample handbook data
class HandbookData {
  static final List<HandbookTopic> topics = [
    HandbookTopic(
      id: '1',
      title: 'Các bài tập',
      description: 'Exercise routines and training',
      imageUrl:
          'https://tse2.mm.bing.net/th/id/OIP.RHkckqwuhfVC2K8UlscK6wHaEJ?pid=Api&P=0&h=180',
      sections: [
        ContentSection(
          title: 'Tập luyện với tạ',
          content:
              'Các bài tập sử dụng tạ giúp tăng cơ bắp và sức mạnh. Bắt đầu với trọng lượng nhẹ và tăng dần theo thời gian.',
        ),
        ContentSection(
          title: 'Cardio',
          content:
              'Các bài tập cardio như chạy, đạp xe giúp cải thiện sức khỏe tim mạch.',
        ),
        ContentSection(
          title: 'Yoga và stretching',
          content: 'Yoga giúp tăng độ dẻo dai, cân bằng và giảm căng thẳng.',
        ),
      ],
    ),
    HandbookTopic(
      id: '2',
      title: 'Dinh dưỡng thể thao',
      description: 'Sports nutrition and diet',
      imageUrl:
          'https://tse1.mm.bing.net/th/id/OIP.j0gdSSZHDeoEHv0YpwzEegHaEK?pid=Api&P=0&h=180',
      sections: [
        ContentSection(
          title: 'Protein cho vận động viên',
          content:
              'Protein là cần thiết để xây dựng và sửa chữa cơ bắp sau tập luyện. Mục tiêu là 1.6-2.2g protein trên kg trọng lượng cơ thể.',
        ),
        ContentSection(
          title: 'Carbohydrate',
          content:
              'Carbs cung cấp năng lượng cho tập luyện. Chọn những carbs phức tạp như ngũ cốc, mì ống nguyên hạt.',
        ),
        ContentSection(
          title: 'Hydration',
          content:
              'Uống đủ nước rất quan trọng. Nên uống 500ml nước mỗi 15-20 phút tập luyện.',
        ),
      ],
    ),
    HandbookTopic(
      id: '3',
      title: 'Danh sách các nguyên liệu và lượng calo',
      description: 'Ingredients and calorie content',
      imageUrl:
          'https://tse2.mm.bing.net/th/id/OIP.Z0AxrtMWYaz2dbwz7rqZPwHaE8?pid=Api&P=0&h=180',
      sections: [],
      foodList: [
        ThucPham(
          id: '1',
          ten: 'Com',
          theLoai: 'Staple',
          calorie: 130,
          protein: 2.7,
          carbs: 28,
          fat: 0.3,
          hinhAnh:
              'https://tse3.mm.bing.net/th/id/OIP.guTalt6f98qYgtlyNGguvAHaHa?pid=Api&P=0&h=180',
          moTa: 'Cooked rice',
        ),
        ThucPham(
          id: '2',
          ten: 'Chicken',
          theLoai: 'Meat',
          calorie: 165,
          protein: 31,
          carbs: 0,
          fat: 3.6,
          hinhAnh:
              'https://tse4.mm.bing.net/th/id/OIP.RYw5GyUvAmqooYumgMaPtQHaEK?pid=Api&P=0&h=180',
          moTa: 'Grilled chicken',
        ),
        ThucPham(
          id: '3',
          ten: 'Salmon',
          theLoai: 'Fish',
          calorie: 208,
          protein: 20,
          carbs: 0,
          fat: 13,
          hinhAnh:
              'https://tse3.mm.bing.net/th/id/OIP.b5_mFqwndYli2luZdK_LBgHaFj?pid=Api&P=0&h=180',
          moTa: 'Fresh salmon',
        ),
        ThucPham(
          id: '4',
          ten: 'Bell pepper',
          theLoai: 'Vegetable',
          calorie: 31,
          protein: 1.3,
          carbs: 6,
          fat: 0.3,
          hinhAnh:
              'https://tse2.mm.bing.net/th/id/OIP.EfEGyCbz_PIpNpcarDL-FAHaE8?pid=Api&P=0&h=180',
          moTa: 'Red bell pepper',
        ),
        ThucPham(
          id: '5',
          ten: 'Potato',
          theLoai: 'Staple',
          calorie: 77,
          protein: 1.7,
          carbs: 17,
          fat: 0.1,
          hinhAnh:
              'https://tse1.mm.bing.net/th/id/OIP.fIiV6TUV266ZTwJ5cSF-vwHaEo?pid=Api&P=0&h=180',
          moTa: 'Boiled potato',
        ),
        ThucPham(
          id: '6',
          ten: 'Egg',
          theLoai: 'Meat',
          calorie: 155,
          protein: 13,
          carbs: 1.1,
          fat: 11,
          hinhAnh:
              'https://tse2.mm.bing.net/th/id/OIP.OLfcOSyImw2f9W4A3fboxgHaFJ?pid=Api&P=0&h=180',
          moTa: 'Boiled egg',
        ),
        ThucPham(
          id: '7',
          ten: 'Broccoli',
          theLoai: 'Vegetable',
          calorie: 34,
          protein: 2.8,
          carbs: 7,
          fat: 0.4,
          hinhAnh:
              'https://tse1.mm.bing.net/th/id/OIP.k1v8fz-YberYHzEN-ZM5kQHaEJ?pid=Api&P=0&h=180',
          moTa: 'Steamed broccoli',
        ),
        ThucPham(
          id: '8',
          ten: 'Banana',
          theLoai: 'Fruit',
          calorie: 89,
          protein: 1.1,
          carbs: 23,
          fat: 0.3,
          hinhAnh:
              'https://tse4.mm.bing.net/th/id/OIP.EzoqwHEIxbEZ2mkuXv8UOwHaE4?pid=Api&P=0&h=180',
          moTa: 'Fresh banana',
        ),
        ThucPham(
          id: '9',
          ten: 'Milk',
          theLoai: 'Dairy',
          calorie: 61,
          protein: 3.2,
          carbs: 4.8,
          fat: 3.3,
          hinhAnh:
              'https://tse3.mm.bing.net/th/id/OIP.-0KGQhDALV9r6Nd5dWwjMwHaEy?pid=Api&P=0&h=180',
          moTa: 'Whole milk',
        ),
      ],
    ),
    HandbookTopic(
      id: '4',
      title: 'Được lý học',
      description: 'Health education and theory',
      imageUrl:
          'https://tse3.mm.bing.net/th/id/OIP.0rzxJuYXGbHbdF9VA3vhvgHaEI?pid=Api&P=0&h=180',
      sections: [
        ContentSection(
          title: 'Chỉ số BMI',
          content:
              'BMI = cân nặng(kg) / [chiều cao(m)]². Dưới 18.5: Thiếu cân, 18.5-24.9: Bình thường, 25-29.9: Thừa cân, Trên 30: Béo phì.',
        ),
        ContentSection(
          title: 'Nhu cầu calo hàng ngày',
          content:
              'Nhu cầu calo phụ thuộc vào tuổi, giới tính, mức độ hoạt động. Công thức Harris-Benedict tính BMR.',
        ),
        ContentSection(
          title: 'Chu kỳ giấc ngủ',
          content:
              'Ngủ 7-9 tiếng mỗi đêm giúp phục hồi cơ bắp và cải thiện sức khỏe tâm thần.',
        ),
      ],
    ),
    HandbookTopic(
      id: '5',
      title: 'Bách khoa toàn thư',
      description: 'Comprehensive health encyclopedia',
      imageUrl:
          'https://tse3.mm.bing.net/th/id/OIP.acuvCWaY4g32c7aR87msxwHaFS?pid=Api&P=0&h=180',
      sections: [
        ContentSection(
          title: 'Tổng quan về sức khỏe',
          content:
              'Sức khỏe là tài sản quý giá nhất. Duy trì sức khỏe thông qua chế độ ăn uống cân bằng, tập luyện đều đặn, ngủ đủ giấc và quản lý stress.',
        ),
        ContentSection(
          title: 'Các loại vitamin và khoáng chất',
          content:
              'Vitamin A: tốt cho mắt, Vitamin C: tăng miễn dịch, Vitamin D: hấp thu canxi, Sắt: vận chuyển oxy, Canxi: xương chắc khỏe.',
        ),
        ContentSection(
          title: 'Phòng chống bệnh mãn tính',
          content:
              'Bệnh tim, tiểu đường, ung thư có thể phòng ngừa bằng lối sống lành mạnh. Kiểm tra sức khỏe định kỳ và tuân theo hướng dẫn của bác sĩ.',
        ),
        ContentSection(
          title: 'Tâm lý và sức khỏe',
          content:
              'Sức khỏe tâm lý quan trọng như sức khỏe thể chất. Tập thiền, yoga, hoặc thảo luận với bạn bè/gia đình giúp giảm stress.',
        ),
      ],
    ),
  ];
}
