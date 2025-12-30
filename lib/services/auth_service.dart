import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 1. Kiểm tra User đã hoàn tất nhập thông tin chưa
  Future<bool> checkIfUserHasInfo() async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['isInfoCompleted'] == true) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 2. Lấy dữ liệu User
  Future<DocumentSnapshot?> getUserData() async {
    User? user = _auth.currentUser;
    if (user == null) return null;
    return await _firestore.collection('users').doc(user.uid).get();
  }

  // 3. Đăng ký Email/Pass (ĐÃ SỬA LỖI NULL CHECK)
  Future<User?> registerWithEmailPassword(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password
      );
      User? user = result.user;
      
      if (user != null) {
        // Cập nhật tên hiển thị
        await user.updateDisplayName(name);
        await user.reload(); 
        user = _auth.currentUser; // Lấy lại user mới nhất
        
        // --- SỬA LỖI Ở ĐÂY: Kiểm tra null một lần nữa trước khi dùng .uid ---
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'id': user.uid,
            'email': email,
            'name': name,
            'avatar': 'assets/onboarding/1.jpg',
            'gender': 'Nam',
            'age': 20,
            'weight': 60,
            'height': 170,
            'goal': 'Giảm cân',
            'location': 'Tại nhà',
            'workoutPlan': 'Chưa chọn',
            'createdAt': FieldValue.serverTimestamp(),
            'isInfoCompleted': false,
          });
        }
      }
      return user;
    } catch (e) {
      print("Lỗi đăng ký: $e");
      return null;
    }
  }

  // 4. Đăng nhập
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password
      );
      return result.user;
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      return null;
    }
  }

  // 5. Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'id': user.uid,
            'email': user.email,
            'name': user.displayName ?? "Người dùng mới",
            'avatar': user.photoURL ?? 'assets/onboarding/1.jpg',
            'gender': 'Nam',
            'age': 20,
            'weight': 60,
            'height': 170,
            'goal': 'Giảm cân',
            'location': 'Tại nhà',
            'workoutPlan': 'Chưa chọn',
            'createdAt': FieldValue.serverTimestamp(),
            'isInfoCompleted': false,
          });
        }
      }
      return user;
    } catch (e) {
      print("Lỗi Google Sign In: $e");
      return null;
    }
  }
  
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}