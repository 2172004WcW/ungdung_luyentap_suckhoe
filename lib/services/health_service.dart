import 'package:pedometer/pedometer.dart';
import 'dart:async';
import '../models/health_stats.dart';
import '../services/storage_service.dart';

/// Service để theo dõi sức khỏe (bước chân, nhịp tim, etc.)
class HealthService {
  static StreamSubscription<StepCount>? _stepCountSubscription;
  static StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;
  static int _currentSteps = 0;
  static bool _isListening = false;

  /// Bắt đầu theo dõi bước chân
  static Future<void> startStepTracking() async {
    if (_isListening) return;

    try {
      late Stream<StepCount> stepCountStream;
      late Stream<PedestrianStatus> pedestrianStatusStream;

      stepCountStream = Pedometer.stepCountStream;
      pedestrianStatusStream = Pedometer.pedestrianStatusStream;

      _stepCountSubscription = stepCountStream.listen(
        _onStepCount,
        onError: _onStepCountError,
      );

      _pedestrianStatusSubscription = pedestrianStatusStream.listen(
        _onPedestrianStatus,
        onError: _onPedestrianStatusError,
      );

      _isListening = true;
    } catch (e) {
      print('Lỗi khởi tạo pedometer: $e');
    }
  }

  /// Dừng theo dõi bước chân
  static void stopStepTracking() {
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    _isListening = false;
  }

  /// Xử lý khi có số bước mới
  static void _onStepCount(StepCount event) {
    _currentSteps = event.steps;
    _saveTodaySteps(_currentSteps);
  }

  /// Xử lý lỗi đếm bước
  static void _onStepCountError(error) {
    print('Lỗi đếm bước: $error');
  }

  /// Xử lý trạng thái đi bộ
  static void _onPedestrianStatus(PedestrianStatus event) {
    // Có thể xử lý trạng thái ở đây nếu cần
  }

  /// Xử lý lỗi trạng thái đi bộ
  static void _onPedestrianStatusError(error) {
    print('Lỗi trạng thái đi bộ: $error');
  }

  /// Lưu số bước hôm nay
  static Future<void> _saveTodaySteps(int steps) async {
    final today = DateTime.now();
    final stats = await _getTodayStats();
    
    final updated = HealthStats(
      date: today,
      steps: steps,
      weight: stats?.weight,
      heartRate: stats?.heartRate,
      waterIntake: stats?.waterIntake,
      sleepHours: stats?.sleepHours,
      caloriesBurned: stats?.caloriesBurned,
      caloriesConsumed: stats?.caloriesConsumed,
    );

    await StorageService.saveHealthStats(updated);
  }

  /// Lấy số bước hôm nay
  static Future<int> getTodaySteps() async {
    final stats = await _getTodayStats();
    return stats?.steps ?? 0;
  }

  /// Lấy health stats hôm nay
  static Future<HealthStats?> _getTodayStats() async {
    final today = DateTime.now();
    final allStats = await StorageService.loadHealthStats();
    
    try {
      return allStats.firstWhere(
        (s) =>
            s.date.year == today.year &&
            s.date.month == today.month &&
            s.date.day == today.day,
      );
    } catch (e) {
      return null;
    }
  }

  /// Lưu cân nặng
  static Future<void> saveWeight(double weight) async {
    final today = DateTime.now();
    final stats = await _getTodayStats();
    
    final updated = HealthStats(
      date: today,
      weight: weight,
      steps: stats?.steps,
      heartRate: stats?.heartRate,
      waterIntake: stats?.waterIntake,
      sleepHours: stats?.sleepHours,
      caloriesBurned: stats?.caloriesBurned,
      caloriesConsumed: stats?.caloriesConsumed,
    );

    await StorageService.saveHealthStats(updated);
  }

  /// Lưu nhịp tim
  static Future<void> saveHeartRate(int heartRate) async {
    final today = DateTime.now();
    final stats = await _getTodayStats();
    
    final updated = HealthStats(
      date: today,
      heartRate: heartRate,
      weight: stats?.weight,
      steps: stats?.steps,
      waterIntake: stats?.waterIntake,
      sleepHours: stats?.sleepHours,
      caloriesBurned: stats?.caloriesBurned,
      caloriesConsumed: stats?.caloriesConsumed,
    );

    await StorageService.saveHealthStats(updated);
  }
}

