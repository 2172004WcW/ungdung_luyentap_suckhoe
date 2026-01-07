class ThucPham {
  final String id;
  final String ten;
  final String theLoai;
  final double calorie;
  final double protein;
  final double carbs;
  final double fat;
  final String hinhAnh;
  final String moTa;

  ThucPham({
    required this.id,
    required this.ten,
    required this.theLoai,
    // Ép buộc các chỉ số dinh dưỡng phải có (mặc định 0)
    this.calorie = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    required this.hinhAnh,
    required this.moTa,
  });

  Map<String, double> tinhDinhDuong(double trongLuong) {
    double soLan = trongLuong / 100;
    return {
      'calorie': calorie * soLan,
      'protein': protein * soLan,
      'carbs': carbs * soLan,
      'fat': fat * soLan,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': ten,
      'theLoai': theLoai,
      'calorie': calorie,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'hinhAnh': hinhAnh,
      'moTa': moTa,
    };
  }

  factory ThucPham.fromJson(Map<String, dynamic> json) {
    return ThucPham(
      id: json['id'] as String? ?? '',
      ten: json['ten'] as String? ?? '',
      theLoai: json['theLoai'] as String? ?? '',
      calorie: (json['calorie'] as num?)?.toDouble() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0,
      // Xử lý giá trị trống nếu JSON bị thiếu
      hinhAnh: json['hinhAnh'] as String? ?? 'assets/images/default.png',
      moTa: json['moTa'] as String? ?? 'Chưa có mô tả.',
    );
  }
}
