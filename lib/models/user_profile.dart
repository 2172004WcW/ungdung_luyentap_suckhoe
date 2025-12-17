class UserProfile {
  final String id;
  String name;
  String avatar;
  String gender;
  int age;
  double weight;
  double height;
  String goal;
  String location;    // Nơi tập (Gym/Home)
  String workoutPlan; // Tên kế hoạch đã chọn

  UserProfile({
    required this.id, // ĐÃ THÊM DẤU PHẨY Ở ĐÂY
    this.name = 'Người dùng mới',
    this.avatar = 'assets/onboarding/1.jpg',
    this.gender = 'Nam',
    this.age = 20,
    this.weight = 60,
    this.height = 170,
    this.goal = 'Giảm cân',
    this.location = 'Tại nhà',
    this.workoutPlan = 'Chưa chọn',
  });

  // Thêm hàm này để chuyển dữ liệu từ Firebase về Object Flutter
  factory UserProfile.fromFirestore(Map<String, dynamic> json, String docId) {
    return UserProfile(
      id: docId,
      name: json['name'] ?? 'Người dùng mới',
      avatar: json['avatar'] ?? 'assets/onboarding/1.jpg',
      gender: json['gender'] ?? 'Nam',
      age: json['age'] ?? 20,
      weight: (json['weight'] ?? 60).toDouble(),
      height: (json['height'] ?? 170).toDouble(),
      goal: json['goal'] ?? 'Giảm cân',
      location: json['location'] ?? 'Tại nhà',
      workoutPlan: json['workoutPlan'] ?? 'Chưa chọn',
    );
  }

  // Thêm hàm này để gửi dữ liệu từ App lên Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatar': avatar,
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
      'goal': goal,
      'location': location,
      'workoutPlan': workoutPlan,
    };
  }
}