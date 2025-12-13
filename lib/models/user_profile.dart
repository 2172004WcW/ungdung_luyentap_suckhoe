// lib/models/user_profile.dart

class UserProfile {
  String name;
  String avatar;
  String gender;
  int age;
  double weight;
  double height;
  String goal;
  String location;    // MỚI: Nơi tập (Gym/Home)
  String workoutPlan; // MỚI: Tên kế hoạch đã chọn

  UserProfile({
    this.name = 'Người dùng mới',
    this.avatar = 'assets/onboarding/1.jpg',
    this.gender = 'Nam',
    this.age = 20,
    this.weight = 60,
    this.height = 170,
    this.goal = 'Giảm cân',
    this.location = 'Tại nhà',       // Mặc định
    this.workoutPlan = 'Chưa chọn',  // Mặc định
  });
}