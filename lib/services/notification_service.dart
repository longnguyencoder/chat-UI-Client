import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Khởi tạo notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    // Set local timezone (Vietnam)
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
    print('✅ NotificationService initialized');
  }

  /// Xử lý khi user tap vào notification
  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // TODO: Navigate to medication detail screen
  }

  /// Request permission (iOS)
  Future<bool> requestPermission() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return true; // Android không cần request runtime permission
  }

  /// Schedule medication reminder với 2 thông báo:
  /// 1. Nhắc trước 10 phút
  /// 2. Nhắc đúng giờ
  Future<void> scheduleMedicationReminder({
    required int scheduleId,
    required String medicationName,
    required String dosage,
    required List<String> timeSlots,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Cancel old notifications for this schedule
    await cancelScheduleNotifications(scheduleId);

    final now = DateTime.now();

    for (int i = 0; i < timeSlots.length; i++) {
      final timeSlot = timeSlots[i];
      final parts = timeSlot.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Tính ngày đầu tiên cần nhắc
      var scheduledDate = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        hour,
        minute,
      );

      // Nếu giờ đã qua hôm nay, bắt đầu từ ngày mai
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      // Kiểm tra không vượt quá end_date
      if (endDate != null && scheduledDate.isAfter(endDate)) {
        continue;
      }

      // ID cho notification
      // Format: scheduleId * 1000 + slot_index * 10 + type (0=10min, 1=ontime)
      final notificationId10Min = scheduleId * 1000 + i * 10 + 0;
      final notificationIdOnTime = scheduleId * 1000 + i * 10 + 1;

      // 1. Schedule notification nhắc trước 10 phút
      final time10MinBefore = scheduledDate.subtract(const Duration(minutes: 10));
      if (time10MinBefore.isAfter(now)) {
        await _scheduleNotification(
          id: notificationId10Min,
          title: '⏰ Sắp đến giờ uống thuốc',
          body: 'Còn 10 phút nữa là đến giờ uống $medicationName ($dosage)',
          scheduledTime: time10MinBefore,
          payload: 'schedule_$scheduleId',
        );
        print('📅 Scheduled 10-min reminder: $medicationName at ${time10MinBefore.toString()}');
      }

      // 2. Schedule notification đúng giờ
      await _scheduleNotification(
        id: notificationIdOnTime,
        title: '💊 Đã đến giờ uống thuốc!',
        body: 'Uống $medicationName - $dosage',
        scheduledTime: scheduledDate,
        payload: 'schedule_$scheduleId',
      );
      print('📅 Scheduled on-time reminder: $medicationName at ${scheduledDate.toString()}');
    }
  }

  /// Schedule một notification cụ thể
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'medication_reminder',
      'Medication Reminders',
      channelDescription: 'Nhắc nhở uống thuốc',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      sound: RawResourceAndroidNotificationSound('notification'),
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'notification.aiff',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Hủy tất cả notifications của một schedule
  Future<void> cancelScheduleNotifications(int scheduleId) async {
    // Cancel tất cả notifications có ID từ scheduleId*1000 đến scheduleId*1000+999
    for (int i = 0; i < 100; i++) {
      await _notifications.cancel(scheduleId * 1000 + i);
    }
    print('🗑️ Cancelled notifications for schedule $scheduleId');
  }

  /// Hủy tất cả notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print('🗑️ Cancelled all notifications');
  }

  /// Kiểm tra pending notifications (debug)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Show immediate notification (for testing)
  Future<void> showImmediateNotification({
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'medication_reminder',
      'Medication Reminders',
      channelDescription: 'Nhắc nhở uống thuốc',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
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
