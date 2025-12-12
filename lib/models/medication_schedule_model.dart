class MedicationSchedule {
  final int? scheduleId;
  final int userId;
  final String medicationName;
  final String? dosage;
  final String frequency;
  final List<String> timeSlots;
  final DateTime startDate;
  final DateTime? endDate;
  final String? notes;
  final bool enableLocalNotification;
  final bool enableEmailNotification;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MedicationSchedule({
    this.scheduleId,
    required this.userId,
    required this.medicationName,
    this.dosage,
    required this.frequency,
    required this.timeSlots,
    required this.startDate,
    this.endDate,
    this.notes,
    this.enableLocalNotification = true,
    this.enableEmailNotification = false,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory MedicationSchedule.fromJson(Map<String, dynamic> json) {
    return MedicationSchedule(
      scheduleId: json['schedule_id'],
      userId: json['user_id'] ?? 0, // Fallback to 0 if missing to prevent crash
      medicationName: json['medication_name'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      // Backend có thể trả về 'time_of_day' hoặc 'time_slots'
      timeSlots: List<String>.from(json['time_of_day'] ?? json['time_slots'] ?? []),
      startDate: DateTime.parse(json['start_date']),
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date']) 
          : null,
      notes: json['notes'],
      enableLocalNotification: json['enable_local_notification'] ?? true,
      enableEmailNotification: json['enable_email_notification'] ?? false,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (scheduleId != null) 'schedule_id': scheduleId,
      'user_id': userId,
      'medication_name': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'time_of_day': timeSlots, // Backend expects 'time_of_day' not 'time_slots'
      'start_date': startDate.toIso8601String().split('T')[0],
      if (endDate != null) 
        'end_date': endDate!.toIso8601String().split('T')[0],
      'notes': notes,
      'enable_local_notification': enableLocalNotification,
      'enable_email_notification': enableEmailNotification,
      'is_active': isActive,
    };
  }

  MedicationSchedule copyWith({
    int? scheduleId,
    int? userId,
    String? medicationName,
    String? dosage,
    String? frequency,
    List<String>? timeSlots,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    bool? enableLocalNotification,
    bool? enableEmailNotification,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicationSchedule(
      scheduleId: scheduleId ?? this.scheduleId,
      userId: userId ?? this.userId,
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      timeSlots: timeSlots ?? this.timeSlots,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      enableLocalNotification: enableLocalNotification ?? this.enableLocalNotification,
      enableEmailNotification: enableEmailNotification ?? this.enableEmailNotification,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Lấy tên tần suất hiển thị
  String get frequencyDisplay {
    switch (frequency) {
      case 'daily':
        return 'Hàng ngày';
      case 'twice_daily':
        return '2 lần/ngày';
      case 'three_times_daily':
        return '3 lần/ngày';
      case 'weekly':
        return 'Hàng tuần';
      case 'custom':
        return 'Tùy chỉnh';
      default:
        return frequency;
    }
  }

  /// Kiểm tra lịch có còn hiệu lực không
  bool get isValid {
    if (!isActive) return false;
    final now = DateTime.now();
    if (now.isBefore(startDate)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    return true;
  }

  /// Lấy giờ tiếp theo cần uống thuốc
  DateTime? get nextReminder {
    if (!isValid) return null;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    DateTime? earliestReminder;
    
    for (final timeSlot in timeSlots) {
      final parts = timeSlot.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      var reminderTime = DateTime(
        today.year,
        today.month,
        today.day,
        hour,
        minute,
      );
      
      // Nếu giờ đã qua hôm nay, lấy ngày mai
      if (reminderTime.isBefore(now)) {
        reminderTime = reminderTime.add(const Duration(days: 1));
      }
      
      // Kiểm tra có vượt quá end_date không
      if (endDate != null && reminderTime.isAfter(endDate!)) {
        continue;
      }
      
      // So sánh với earliestReminder để tìm thời gian sớm nhất
      if (earliestReminder == null || reminderTime.isBefore(earliestReminder)) {
        earliestReminder = reminderTime;
      }
    }
    
    return earliestReminder;
  }
}
