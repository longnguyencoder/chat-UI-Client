import 'package:flutter/material.dart';
import '../models/medication_schedule_model.dart';
import '../models/medication_log_model.dart';
import '../services/medication_service.dart';
import '../services/notification_service.dart';

class MedicationViewModel extends ChangeNotifier {
  final MedicationService _medicationService = MedicationService();
  final NotificationService _notificationService = NotificationService();
  final int userId;

  MedicationViewModel(this.userId) {
    _initializeNotifications();
    loadSchedules();
  }

  /// Khởi tạo notification service
  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
    await _notificationService.requestPermission();
  }

  // State
  List<MedicationSchedule> _schedules = [];
  List<MedicationLog> _logs = [];
  MedicationStats? _stats;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<MedicationSchedule> get schedules => _schedules;
  List<MedicationSchedule> get activeSchedules =>
      _schedules.where((s) => s.isActive && s.isValid).toList();
  List<MedicationLog> get logs => _logs;
  MedicationStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ========================================================================
  // SCHEDULES
  // ========================================================================

  /// Load danh sách lịch nhắc nhở
  Future<void> loadSchedules({bool? isActive}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _schedules = await _medicationService.getSchedules(
        userId: userId,
        isActive: isActive,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tạo lịch nhắc nhở mới
  Future<bool> createSchedule(MedicationSchedule schedule) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final newSchedule = await _medicationService.createSchedule(schedule);
      _schedules.insert(0, newSchedule);

      // Schedule local notifications nếu được bật
      if (newSchedule.enableLocalNotification && newSchedule.scheduleId != null) {
        await _notificationService.scheduleMedicationReminder(
          scheduleId: newSchedule.scheduleId!,
          medicationName: newSchedule.medicationName,
          dosage: newSchedule.dosage ?? '',
          timeSlots: newSchedule.timeSlots,
          startDate: newSchedule.startDate,
          endDate: newSchedule.endDate,
        );
        print('✅ Scheduled notifications for ${newSchedule.medicationName}');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Cập nhật lịch nhắc nhở
  Future<bool> updateSchedule(int scheduleId, MedicationSchedule schedule) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedSchedule = await _medicationService.updateSchedule(
        scheduleId,
        schedule,
      );

      final index = _schedules.indexWhere((s) => s.scheduleId == scheduleId);
      if (index != -1) {
        _schedules[index] = updatedSchedule;
      }

      // Reschedule notifications
      await _notificationService.cancelScheduleNotifications(scheduleId);
      if (updatedSchedule.enableLocalNotification) {
        await _notificationService.scheduleMedicationReminder(
          scheduleId: scheduleId,
          medicationName: updatedSchedule.medicationName,
          dosage: updatedSchedule.dosage ?? '',
          timeSlots: updatedSchedule.timeSlots,
          startDate: updatedSchedule.startDate,
          endDate: updatedSchedule.endDate,
        );
        print('✅ Rescheduled notifications for ${updatedSchedule.medicationName}');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Xóa lịch nhắc nhở
  Future<bool> deleteSchedule(int scheduleId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _medicationService.deleteSchedule(scheduleId);
      _schedules.removeWhere((s) => s.scheduleId == scheduleId);

      // Cancel all notifications for this schedule
      await _notificationService.cancelScheduleNotifications(scheduleId);
      print('✅ Cancelled notifications for schedule $scheduleId');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ========================================================================
  // LOGS
  // ========================================================================

  /// Ghi nhận đã uống thuốc
  Future<bool> markAsTaken(MedicationSchedule schedule) async {
    try {
      await _medicationService.logMedication(
        scheduleId: schedule.scheduleId!,
        userId: userId,
        scheduledTime: schedule.nextReminder ?? DateTime.now(),
        status: 'taken',
        actualTime: DateTime.now(),
      );

      // Reload logs để cập nhật UI
      await loadLogs(scheduleId: schedule.scheduleId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Ghi nhận bỏ qua
  Future<bool> markAsSkipped(MedicationSchedule schedule, String? reason) async {
    try {
      await _medicationService.logMedication(
        scheduleId: schedule.scheduleId!,
        userId: userId,
        scheduledTime: schedule.nextReminder ?? DateTime.now(),
        status: 'skipped',
        notes: reason,
      );

      // Reload logs để cập nhật UI
      await loadLogs(scheduleId: schedule.scheduleId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Load lịch sử uống thuốc
  Future<void> loadLogs({
    int? scheduleId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _logs = await _medicationService.getLogs(
        userId: userId,
        scheduleId: scheduleId,
        status: status,
        fromDate: fromDate?.toIso8601String().split('T')[0],
        toDate: toDate?.toIso8601String().split('T')[0],
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load thống kê
  Future<void> loadStats({DateTime? fromDate, DateTime? toDate}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _stats = await _medicationService.getStats(
        userId: userId,
        fromDate: fromDate?.toIso8601String().split('T')[0],
        toDate: toDate?.toIso8601String().split('T')[0],
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ========================================================================
  // HELPERS
  // ========================================================================

  /// Lấy lịch nhắc nhở theo ID
  MedicationSchedule? getScheduleById(int scheduleId) {
    try {
      return _schedules.firstWhere((s) => s.scheduleId == scheduleId);
    } catch (e) {
      return null;
    }
  }

  /// Lấy số lượng lịch nhắc nhở hôm nay
  int getTodayRemindersCount() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    int count = 0;
    for (final schedule in activeSchedules) {
      if (schedule.startDate.isBefore(today.add(const Duration(days: 1))) &&
          (schedule.endDate == null || schedule.endDate!.isAfter(today))) {
        count += schedule.timeSlots.length;
      }
    }
    return count;
  }

  /// Lấy lịch nhắc nhở tiếp theo
  MedicationSchedule? getNextReminder() {
    DateTime? earliestTime;
    MedicationSchedule? nextSchedule;

    for (final schedule in activeSchedules) {
      final nextTime = schedule.nextReminder;
      if (nextTime != null) {
        if (earliestTime == null || nextTime.isBefore(earliestTime)) {
          earliestTime = nextTime;
          nextSchedule = schedule;
        }
      }
    }

    return nextSchedule;
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh tất cả dữ liệu
  Future<void> refresh() async {
    await loadSchedules();
    await loadStats();
  }
}
