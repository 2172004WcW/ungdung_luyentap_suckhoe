import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../services/auth_service.dart';
import '../models/user_profile.dart'; 
import 'home_screen.dart'; 
import 'user_info_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController(); // Mới thêm: Nhập lại mật khẩu
  final _nameController = TextEditingController();
  
  bool _isLoading = false;
  bool _isLogin = true; 
  final Color primaryColor = const Color(0xFF1AB7B0);

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      _navigateBasedOnUserStatus();
    }
  }

  void _navigateBasedOnUserStatus() async {
    bool hasInfo = await _auth.checkIfUserHasInfo();

    if (!mounted) return;

    if (hasInfo) {
      try {
        DocumentSnapshot? doc = await _auth.getUserData();
        if (doc != null && doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          UserProfile profile = UserProfile.fromFirestore(data, doc.id);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomeScreen(userProfile: profile)),
          );
        }
      } catch (e) {
        print("Lỗi parse data: $e");
        setState(() => _isLoading = false);
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const UserInfoScreen()),
      );
    }
  }

  void _handleAuth() async {
    // 1. Validate cơ bản
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng nhập Email và Mật khẩu")));
      return;
    }

    if (!_isLogin) {
      // Logic kiểm tra khi ĐĂNG KÝ
      if (_nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng nhập tên hiển thị")));
        return;
      }
      if (_passController.text != _confirmPassController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mật khẩu xác nhận không khớp")));
        return;
      }
    }

    setState(() => _isLoading = true);
    
    if (_isLogin) {
      // --- XỬ LÝ ĐĂNG NHẬP ---
      User? user = await _auth.signInWithEmailPassword(
        _emailController.text.trim(), 
        _passController.text.trim()
      );
      if (user != null) {
        _navigateBasedOnUserStatus();
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đăng nhập thất bại. Kiểm tra lại thông tin.")));
      }
    } else {
      // --- XỬ LÝ ĐĂNG KÝ ---
      User? user = await _auth.registerWithEmailPassword(
        _emailController.text.trim(), 
        _passController.text.trim(),
        _nameController.text.trim()
      );

      if (user != null) {
        // Đăng ký thành công -> KHÔNG chuyển trang ngay
        // Mà chuyển về giao diện Đăng nhập, giữ nguyên text đã nhập
        setState(() {
          _isLoading = false;
          _isLogin = true; // Chuyển sang tab Đăng nhập
          // _passController và _emailController giữ nguyên giá trị
          // Xóa mật khẩu xác nhận cho gọn
          _confirmPassController.clear();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng ký thành công! Hãy nhấn TIẾP TỤC để đăng nhập.")),
        );
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email đã tồn tại hoặc lỗi mạng.")));
      }
    }
  }

  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    User? user = await _auth.signInWithGoogle();
    
    if (user != null) {
      _navigateBasedOnUserStatus();
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đăng nhập Google thất bại")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Icon(Icons.fitness_center, size: 80, color: primaryColor),
              const SizedBox(height: 20),
              Text(
                _isLogin ? "ĐĂNG NHẬP" : "ĐĂNG KÝ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 30),
              
              // Ô nhập tên (Chỉ hiện khi Đăng ký)
              if (!_isLogin)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Tên hiển thị", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                  ),
                ),
              
              // Ô nhập Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 16),
              
              // Ô nhập Mật khẩu
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mật khẩu", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
              ),
              
              // Ô xác nhận Mật khẩu (Chỉ hiện khi Đăng ký)
              if (!_isLogin)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: _confirmPassController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Xác nhận mật khẩu", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock_outline)),
                  ),
                ),

              const SizedBox(height: 24),
              
              // Nút bấm chính
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : _handleAuth,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_isLogin ? "TIẾP TỤC" : "ĐĂNG KÝ NGAY"),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Nút Google
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _handleGoogleSignIn,
                icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red),
                label: const Text("Đăng nhập bằng Google", style: TextStyle(color: Colors.black)),
              ),
              
              const SizedBox(height: 20),
              
              // Nút chuyển đổi Đăng nhập <-> Đăng ký
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    // Xóa lỗi hoặc reset form nếu cần
                  });
                },
                child: Text(
                  _isLogin ? "Chưa có tài khoản? Đăng ký" : "Đã có tài khoản? Đăng nhập",
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}