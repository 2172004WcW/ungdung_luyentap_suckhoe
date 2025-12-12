// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart'; // Import màn hình bắt đầu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HAT Fitness App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      // Màn hình bắt đầu là Onboarding
      home: const OnboardingScreen(),
    );
  }
}