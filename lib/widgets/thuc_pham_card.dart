import 'package:flutter/material.dart';
import '../models/thuc_pham.dart';

class ThucPhamCard extends StatelessWidget {
  final ThucPham thucPham;
  final VoidCallback? onTap;
  final bool showNutrition;

  const ThucPhamCard({
    Key? key,
    required this.thucPham,
    this.onTap,
    this.showNutrition = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1AB7B0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // Sử dụng InkWell bên trong Card để có hiệu ứng nhấn (splash effect)
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // --- HÌNH ẢNH ---
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: thucPham.hinhAnh.isNotEmpty
                    ? Image.asset(
                        thucPham.hinhAnh,
                        width: 80, // Giảm nhẹ kích thước để cân đối hơn
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(primaryColor),
                      )
                    : _buildPlaceholder(primaryColor),
              ),
              const SizedBox(width: 16),

              // --- NỘI DUNG ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min, // Giúp Column co giãn theo nội dung
                  children: [
                    Text(
                      thucPham.ten,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (showNutrition) ...[
                      const SizedBox(height: 4),
                      Text(
                        thucPham.theLoai,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildTag(
                            'Cal: ${thucPham.calorie.toStringAsFixed(0)}',
                            primaryColor,
                          ),
                          const SizedBox(width: 8),
                          _buildTag(
                            'Pro: ${thucPham.protein.toStringAsFixed(1)}g',
                            const Color(0xFF0D8C87),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // --- ICON MŨI TÊN ---
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị khi không có ảnh hoặc ảnh lỗi
  Widget _buildPlaceholder(Color color) {
    return Container(
      width: 80,
      height: 80,
      color: color.withOpacity(0.1),
      child: Icon(Icons.fastfood, color: color),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2), width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
