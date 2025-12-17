import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

/// Service để quản lý thông báo
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Khởi tạo service
  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// Xử lý khi người dùng tap vào thông báo
  static void _onNotificationTapped(NotificationResponse response) {
    // Có thể xử lý navigation ở đây
  }

  /// Lên lịch thông báo tập luyện
  static Future<void> scheduleWorkoutReminder({
    required int hour,
    required int minute,
    required String message,
  }) async {
    await initialize();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Nếu thời gian đã qua trong ngày, lên lịch cho ngày mai
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'workout_channel',
      'Nhắc nhở tập luyện',
      channelDescription: 'Thông báo nhắc nhở tập luyện',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      0,
      'Nhắc nhở tập luyện',
      message,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Lên lịch thông báo uống nước
  static Future<void> scheduleWaterReminder({
    required int intervalMinutes,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'water_channel',
      'Nhắc nhở uống nước',
      channelDescription: 'Thông báo nhắc nhở uống nước',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Lên lịch thông báo mỗi X phút
    final now = tz.TZDateTime.now(tz.local);
    for (int i = 1; i <= 10; i++) {
      final scheduledDate = now.add(Duration(minutes: intervalMinutes * i));
      await _notifications.zonedSchedule(
        i,
        'Nhắc nhở uống nước',
        'Đã đến lúc uống nước rồi! 💧',
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  /// Hủy tất cả thông báo
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Hiển thị thông báo ngay lập tức
  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'general_channel',
      'Thông báo chung',
      channelDescription: 'Thông báo chung của ứng dụng',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      details,
    );
  }
}

