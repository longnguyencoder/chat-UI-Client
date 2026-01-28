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



  /// Load danh sách lịch nhắc nhở VÀ logs hôm nay để check status
  Future<void> loadSchedules({bool? isActive}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // 1. Load schedules
      _schedules = await _medicationService.getSchedules(
        userId: userId,
        isActive: isActive,
      );

      // 2. Load logs cho hôm nay để biết trạng thái
      // Lưu ý: loadLogs sẽ cập nhật biến _logs
      // Ta lấy log từ đầu ngày đến cuối ngày nay (hoặc rộng hơn chút nếu cần)
      final now = DateTime.now();
      await loadLogs(
        fromDate: now, 
        toDate: now,
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
      try {
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
      } catch (e) {
        print('⚠️ Notification schedule failed: $e');
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
      try {
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
      } catch (e) {
        print('⚠️ Notification invalid on this platform or failed: $e');
        // Ignore notification error on web/unsupported platforms
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
      try {
        await _notificationService.cancelScheduleNotifications(scheduleId);
        print('✅ Cancelled notifications for schedule $scheduleId');
      } catch (e) {
        print('⚠️ Notification cancel failed: $e');
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

  // ========================================================================
  // LOGS
  // ========================================================================

  /// Ghi nhận đã uống thuốc
  Future<bool> markAsTaken(MedicationSchedule schedule) async {
    try {
      // Tìm log entry pending cho lần uống thuốc này
      final logId = await _findPendingLogId(
        schedule.scheduleId!,
        schedule.nextReminder ?? DateTime.now(),
      );

      if (logId == null) {
        // Nếu không tìm thấy log pending, tạo mới
        await _medicationService.logMedication(
          scheduleId: schedule.scheduleId!,
          userId: userId,
          scheduledTime: schedule.nextReminder ?? DateTime.now(),
          status: 'taken',
          actualTime: DateTime.now(),
        );
      } else {
        // Nếu tìm thấy, cập nhật log đó
        await _medicationService.logMedication(
          scheduleId: schedule.scheduleId!,
          userId: userId,
          scheduledTime: schedule.nextReminder ?? DateTime.now(),
          status: 'taken',
          actualTime: DateTime.now(),
          logId: logId, // Truyền log_id thực sự
        );
      }

      // Reload logs và schedules để cập nhật UI
      await loadLogs(scheduleId: schedule.scheduleId);
      await loadSchedules(); // Reload danh sách để cập nhật nextReminder
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
      // Tìm log entry pending cho lần uống thuốc này
      final logId = await _findPendingLogId(
        schedule.scheduleId!,
        schedule.nextReminder ?? DateTime.now(),
      );

      if (logId == null) {
        // Nếu không tìm thấy log pending, tạo mới
        await _medicationService.logMedication(
          scheduleId: schedule.scheduleId!,
          userId: userId,
          scheduledTime: schedule.nextReminder ?? DateTime.now(),
          status: 'skipped',
          notes: reason,
        );
      } else {
        // Nếu tìm thấy, cập nhật log đó
        await _medicationService.logMedication(
          scheduleId: schedule.scheduleId!,
          userId: userId,
          scheduledTime: schedule.nextReminder ?? DateTime.now(),
          status: 'skipped',
          notes: reason,
          logId: logId, // Truyền log_id thực sự
        );
      }

      // Reload logs và schedules để cập nhật UI
      await loadLogs(scheduleId: schedule.scheduleId);
      await loadSchedules(); // Reload danh sách để cập nhật nextReminder
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

      // Debug: In ra logs để kiểm tra
      print('📋 Loaded ${_logs.length} logs for schedule $scheduleId');
      for (final log in _logs) {
        print('   - Log ${log.logId}: ${log.status} at ${log.scheduledTime}');
      }

      // Lọc logs trùng lặp - Ưu tiên taken/skipped hơn pending
      final Map<String, MedicationLog> uniqueLogs = {};
      for (final log in _logs) {
        final key = log.scheduledTime.toIso8601String();
        
        if (!uniqueLogs.containsKey(key)) {
          // Chưa có log cho thời gian này, thêm vào
          uniqueLogs[key] = log;
        } else {
          // Đã có log, so sánh priority
          final existing = uniqueLogs[key]!;
          // Priority: taken > skipped > pending
          final logPriority = log.status == 'taken' ? 3 : (log.status == 'skipped' ? 2 : 1);
          final existingPriority = existing.status == 'taken' ? 3 : (existing.status == 'skipped' ? 2 : 1);
          
          if (logPriority > existingPriority) {
            uniqueLogs[key] = log;
          }
        }
      }
      
      _logs = uniqueLogs.values.toList();
      print('📋 After filtering: ${_logs.length} unique logs');

      // Sắp xếp logs theo thời gian giảm dần (mới nhất lên đầu)
      _logs.sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tìm log_id của log entry pending
  Future<int?> _findPendingLogId(int scheduleId, DateTime scheduledTime) async {
    try {
      // Lấy danh sách logs cho schedule này
      final logs = await _medicationService.getLogs(
        userId: userId,
        scheduleId: scheduleId,
        status: 'pending',
      );

      // Tìm log có scheduled_time khớp (trong vòng 1 phút)
      for (final log in logs) {
        final diff = log.scheduledTime.difference(scheduledTime).abs();
        if (diff.inMinutes < 1) {
          return log.logId;
        }
      }

      return null;
    } catch (e) {
      print('❌ Error finding pending log: $e');
      return null;
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

  /// Lấy lịch nhắc nhở tiếp theo (có kiểm tra đã uống chưa)
  MedicationSchedule? getNextReminder() {
    DateTime? earliestTime;
    MedicationSchedule? nextSchedule;

    for (final schedule in activeSchedules) {
      if (!schedule.isActive) continue;

      // Logic cũ: chỉ lấy thời gian tương lai
      // Logic mới: cần kiểm tra xem thời gian đó đã uống chưa
      // Tuy nhiên, hàm này dùng để hiển thị "Next Reminder" global cho toàn bộ app (nếu có widget dashboard).
      // Ở đây ta giữ logic tìm thời gian, nhưng lọc bớt các slot đã "taken" trong ngày hôm nay.
      
      final nextTime = schedule.nextReminder;
      if (nextTime != null) {
        // Kiểm tra xem nextTime này đã có log 'taken' chưa
        final isTaken = _checkIfTaken(schedule.scheduleId!, nextTime);
        if (!isTaken) {
          if (earliestTime == null || nextTime.isBefore(earliestTime)) {
            earliestTime = nextTime;
            nextSchedule = schedule;
          }
        } else {
            // Nếu slot này đã taken, ta cần tìm slot TIẾP THEO của schedule này
            // (Hiện tại schedule.nextReminder chỉ trả về 1 mốc sớm nhất chưa qua giờ hiện tại (hoặc ngày mai))
            // Để đơn giản, nếu đã taken slot này, ta bỏ qua schedule này trong việc tìm "Next Reminder" *ngay lúc này*
            // Hoặc lý tưởng hơn là tìm slot sau đó nữa.
        }
      }
    }

    return nextSchedule;
  }

  /// Kiểm tra xem một mốc thời gian cụ thể của schedule đã được uống chưa
  bool _checkIfTaken(int scheduleId, DateTime scheduledTime) {
    if (_logs.isEmpty) return false;
    
    // Tìm log khớp với scheduleId và scheduledTime (trong khoảng < 1 phút hoặc cùng ngày cùng giờ phút)
    try {
        final hasLog = _logs.any((log) {
            if (log.scheduleId != scheduleId) return false;
            if (log.status != 'taken') return false; // Chỉ quan tâm đã uống
            
            final logTime = log.scheduledTime;
            // So sánh chính xác phút
            return logTime.year == scheduledTime.year && 
                   logTime.month == scheduledTime.month && 
                   logTime.day == scheduledTime.day &&
                   logTime.hour == scheduledTime.hour &&
                   logTime.minute == scheduledTime.minute;
        });
        return hasLog;
    } catch (e) {
        return false;
    }
  }

  /// Hàm helper cho View: Trạng thái của lần nhắc tiếp theo
  /// Trả về: 
  /// - null: Không có nhắc nhở nào sắp tới
  /// - Map: {'time': DateTime, 'isTaken': bool, 'status': String}
  Map<String, dynamic>? getNextReminderStatus(MedicationSchedule schedule) {
      final nextTime = schedule.nextReminder;
      if (nextTime == null) return null;

      final isTaken = _checkIfTaken(schedule.scheduleId!, nextTime);
      
      return {
          'time': nextTime,
          'isTaken': isTaken,
          'status': isTaken ? 'taken' : 'pending',
      };
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ========================================================================
  // SLOTS GENERATION & HANDLING
  // ========================================================================

  List<MedicationSlot> _currentSlots = [];
  List<MedicationSlot> get currentSlots => _currentSlots;

  /// Generate slots for a specific schedule within a date range
  Future<void> generateSlotsForSchedule(MedicationSchedule schedule, {DateTime? from, DateTime? to}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final now = DateTime.now();
      // Default: Last 7 days to next 30 days (or end date)
      final startDate = from ?? now.subtract(const Duration(days: 7));
      final endDate = to ?? (schedule.endDate != null && schedule.endDate!.isBefore(now.add(const Duration(days: 30))) 
          ? schedule.endDate! 
          : now.add(const Duration(days: 30)));

      // 1. Load existing logs for this period
      final logs = await _medicationService.getLogs(
        userId: userId,
        scheduleId: schedule.scheduleId,
        fromDate: startDate.toIso8601String().split('T')[0],
        toDate: endDate.toIso8601String().split('T')[0],
      );

      // 2. Generate theoretical slots
      List<MedicationSlot> slots = [];
      DateTime current = DateTime(startDate.year, startDate.month, startDate.day);
      final listEnd = DateTime(endDate.year, endDate.month, endDate.day);

      while (current.isBefore(listEnd) || current.isAtSameMomentAs(listEnd)) {
        // Skip dates before schedule start
        if (current.isBefore(DateTime(schedule.startDate.year, schedule.startDate.month, schedule.startDate.day))) {
          current = current.add(const Duration(days: 1));
          continue;
        }

        // Apply frequency logic (simplified for daily/mult-daily)
        // Note: For weekly or custom, we need more complex logic. 
        // Assuming daily/time_slots for now based on current app usage.
        
        for (final timeStr in schedule.timeSlots) {
          final parts = timeStr.split(':');
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          final slotTime = DateTime(current.year, current.month, current.day, hour, minute);

          // Find matching log
          // We look for a log that matches this scheduled time
          MedicationLog? matchingLog;
          try {
            matchingLog = logs.firstWhere((log) {
               // Initial simpler check: same day and same scheduled time
               // Note: Backend might store scheduledTime differently based on how it was created
               // We should compare fuzzy logic if needed, but strict comparison is best for "slots"
               final logTime = log.scheduledTime;
               return logTime.year == slotTime.year && 
                      logTime.month == slotTime.month && 
                      logTime.day == slotTime.day &&
                      logTime.hour == slotTime.hour &&
                      logTime.minute == slotTime.minute;
            });
          } catch (e) {
            // No matching log found
          }

          slots.add(MedicationSlot(
            scheduleId: schedule.scheduleId!,
            time: slotTime,
            status: matchingLog?.status ?? (slotTime.isBefore(now) ? 'missed' : 'pending'),
            logId: matchingLog?.logId,
          ));
        }

        current = current.add(const Duration(days: 1));
      }

      // Sort: Newest first? Or Oldest first? 
      // User likely wants to see today/upcoming. 
      // Let's sort chronological (Oldest -> Newest) so they can scroll down to today.
      slots.sort((a, b) => a.time.compareTo(b.time));

      _currentSlots = slots;
      _isLoading = false;
      notifyListeners();

    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mark a specific slot as taken
  Future<bool> markSlotAsTaken(MedicationSlot slot, MedicationSchedule schedule) async {
    try {
      if (slot.logId != null) {
        // Update existing log
        await _medicationService.logMedication(
          scheduleId: slot.scheduleId,
          userId: userId,
          scheduledTime: slot.time,
          status: 'taken',
          actualTime: DateTime.now(),
          logId: slot.logId,
        );
      } else {
        // Create new log
        await _medicationService.logMedication(
          scheduleId: slot.scheduleId,
          userId: userId,
          scheduledTime: slot.time,
          status: 'taken',
          actualTime: DateTime.now(),
        );
      }
      
      // Refresh slots
      await generateSlotsForSchedule(schedule);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Mark a specific slot as skipped
  Future<bool> markSlotAsSkipped(MedicationSlot slot, MedicationSchedule schedule, String? reason) async {
    try {
      if (slot.logId != null) {
        await _medicationService.logMedication(
          scheduleId: slot.scheduleId,
          userId: userId,
          scheduledTime: slot.time,
          status: 'skipped',
          notes: reason,
          logId: slot.logId,
        );
      } else {
        await _medicationService.logMedication(
          scheduleId: slot.scheduleId,
          userId: userId,
          scheduledTime: slot.time,
          status: 'skipped',
          notes: reason,
        );
      }

      await generateSlotsForSchedule(schedule);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Refresh tất cả dữ liệu
  Future<void> refresh() async {
    await loadSchedules();
    await loadStats();
  }
}

class MedicationSlot {
  final int scheduleId;
  final DateTime time;
  final String status; // 'pending', 'taken', 'skipped', 'missed'
  final int? logId;

  MedicationSlot({
    required this.scheduleId,
    required this.time,
    required this.status,
    this.logId,
  });

  String get statusDisplay {
    switch (status) {
      case 'taken': return 'Đã uống';
      case 'skipped': return 'Bỏ qua';
      case 'pending': return 'Chưa uống';
      case 'missed': return 'Quên uống';
      default: return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'taken': return Colors.green;
      case 'skipped': return Colors.orange;
      case 'pending': return Colors.blue;
      case 'missed': return Colors.red;
      default: return Colors.grey;
    }
  }
}

