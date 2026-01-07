import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart'; 
import '../models/thuc_pham.dart';
import '../models/nutrition_log.dart';

class NutritionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _getDateId(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  // 1. Lấy danh sách món ăn từ Handbook (Đã sửa cho đúng cấu trúc của bạn)
  Stream<List<ThucPham>> getCommonFoods() {
    return _firestore.collection('handbook_topics').doc('3').snapshots().map((doc) {
      List<ThucPham> allFoods = [];
      if (!doc.exists || doc.data() == null) return allFoods;

      final data = doc.data()!;
      
      // Tìm mảng sections
      List<dynamic>? sections;
      if (data['sections'] != null && data['sections'] is List) {
        sections = data['sections'];
      } else if (data['foodList'] != null && data['foodList'] is Map) {
         final foodMap = data['foodList'] as Map;
         if (foodMap['sections'] != null && foodMap['sections'] is List) {
           sections = foodMap['sections'];
         }
      }

      if (sections != null) {
        for (var section in sections) {
          if (section is Map && section['foods'] != null && section['foods'] is List) {
            final foods = section['foods'] as List;
            for (var item in foods) {
              if (item is Map) {
                try {
                  final foodMap = Map<String, dynamic>.from(item);
                  if (foodMap['id'] == null) foodMap['id'] = const Uuid().v4();
                  if (foodMap['ten'] == null) foodMap['ten'] = 'Món chưa đặt tên';
                  allFoods.add(ThucPham.fromJson(foodMap));
                } catch (e) {
                  print("Lỗi parse món: $e");
                }
              }
            }
          }
        }
      }
      return allFoods;
    });
  }

  // 2. Lấy dữ liệu dinh dưỡng
  Stream<DailyNutrition> getDailyNutritionStream(DateTime date) {
    final user = _auth.currentUser;
    // Nếu chưa login trả về Stream mặc định rỗng
    if (user == null) {
      return Stream.value(DailyNutrition(date: date, meals: []));
    }

    final dateId = _getDateId(date);
    
    // Lắng nghe liên tục (snapshots)
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('daily_nutrition')
        .doc(dateId)
        .snapshots()
        .map((doc) {
          if (doc.exists && doc.data() != null) {
            return DailyNutrition.fromJson(doc.data()!);
          } else {
            // Chưa có dữ liệu ngày này -> Trả về mặc định
            return DailyNutrition(
              date: date,
              meals: [],
              targetCalories: 2000,
              targetProtein: 150,
              targetCarbs: 250,
              targetFat: 65,
            );
          }
        });
  }
  
  Future<DailyNutrition> getDailyNutrition(DateTime date) async {
    final user = _auth.currentUser;
    if (user == null) return DailyNutrition(date: date, meals: []);
    final dateId = _getDateId(date);
    try {
      final doc = await _firestore.collection('users').doc(user.uid).collection('daily_nutrition').doc(dateId).get();
      if (doc.exists && doc.data() != null) return DailyNutrition.fromJson(doc.data()!);
      return DailyNutrition(date: date, meals: [], targetCalories: 2000, targetProtein: 150, targetCarbs: 250, targetFat: 65);
    } catch (e) {
      return DailyNutrition(date: date, meals: []);
    }
  }

  // 3. Lưu dữ liệu
  Future<void> saveDailyNutrition(DailyNutrition nutrition) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final dateId = _getDateId(nutrition.date);
    await _firestore.collection('users').doc(user.uid).collection('daily_nutrition').doc(dateId).set(nutrition.toJson());
  }
}