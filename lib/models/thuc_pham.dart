/// Model thuc pham voi thong tin dinh duong
class ThucPham {
  final String id;
  final String ten;
  final String theLoai;
  final double calorie;
  final double protein;
  final double carbs;
  final double fat;
  final String? hinhAnh;
  final String? moTa;

  ThucPham({
    required this.id,
    required this.ten,
    required this.theLoai,
    required this.calorie,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.hinhAnh,
    this.moTa,
  });

  /// Tinh toan dinh duong dua tren trong luong (gram)
  Map<String, double> tinhDinhDuong(double trongLuong) {
    double soLan = trongLuong / 100;
    return {
      'calorie': calorie * soLan,
      'protein': protein * soLan,
      'carbs': carbs * soLan,
      'fat': fat * soLan,
    };
  }

  /// Chuyen thanh JSON
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

  /// Khoi tao tu JSON
  factory ThucPham.fromJson(Map<String, dynamic> json) {
    return ThucPham(
      id: json['id'] as String,
      ten: json['ten'] as String,
      theLoai: json['theLoai'] as String,
      calorie: (json['calorie'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      hinhAnh: json['hinhAnh'] as String?,
      moTa: json['moTa'] as String?,
    );
  }
}
