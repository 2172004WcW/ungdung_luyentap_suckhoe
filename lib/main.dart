import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';
// import 'services/health_service.dart'; // Tạm tắt
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();

  // Tạm tắt HealthService để tránh treo máy ảo Android
  /*
  if (!kIsWeb) {
    await HealthService.startStepTracking();
  }
  */

  await initializeDateFormatting('vi');

  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(MyApp(seenOnboarding: seenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;

  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health & Nutrition App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthWrapper(seenOnboarding: seenOnboarding),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final bool seenOnboarding;
  const AuthWrapper({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    // 1. Nếu chưa xem Onboarding -> Vào Onboarding luôn
    if (!seenOnboarding) {
      return const OnboardingScreen();
    }
    // 2. Nếu đã xem rồi -> Vào LoginScreen (LoginScreen sẽ tự kiểm tra trạng thái đăng nhập)
    return const LoginScreen();
  }
}