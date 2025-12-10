class MedicationLog {
  final int? logId;
  final int scheduleId;
  final int userId;
  final DateTime scheduledTime;
  final DateTime? actualTime;
  final String status; // 'taken', 'skipped', 'pending'
  final String? notes;
  final DateTime? createdAt;

  MedicationLog({
    this.logId,
    required this.scheduleId,
    required this.userId,
    required this.scheduledTime,
    this.actualTime,
    required this.status,
    this.notes,
    this.createdAt,
  });

  factory MedicationLog.fromJson(Map<String, dynamic> json) {
    return MedicationLog(
      logId: json['log_id'],
      scheduleId: json['schedule_id'],
      userId: json['user_id'],
      scheduledTime: DateTime.parse(json['scheduled_time']),
      actualTime: json['actual_time'] != null 
          ? DateTime.parse(json['actual_time']) 
          : null,
      status: json['status'],
      notes: json['notes'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (logId != null) 'log_id': logId,
      'schedule_id': scheduleId,
      'user_id': userId,
      'scheduled_time': scheduledTime.toIso8601String(),
      if (actualTime != null) 'actual_time': actualTime!.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }

  /// Lấy trạng thái hiển thị
  String get statusDisplay {
    switch (status) {
      case 'taken':
        return 'Đã uống';
      case 'skipped':
        return 'Bỏ qua';
      case 'pending':
        return 'Chưa uống';
      default:
        return status;
    }
  }

  /// Kiểm tra có uống đúng giờ không (trong vòng 30 phút)
  bool get isTakenOnTime {
    if (status != 'taken' || actualTime == null) return false;
    final difference = actualTime!.difference(scheduledTime).abs();
    return difference.inMinutes <= 30;
  }

  /// Lấy màu sắc theo trạng thái
  String get statusColor {
    switch (status) {
      case 'taken':
        return '#4CAF50'; // Green
      case 'skipped':
        return '#F44336'; // Red
      case 'pending':
        return '#FF9800'; // Orange
      default:
        return '#9E9E9E'; // Grey
    }
  }
}

/// Model cho thống kê tuân thủ
class MedicationStats {
  final int totalScheduled;
  final int totalTaken;
  final int totalSkipped;
  final int totalPending;
  final double complianceRate;
  final int onTimeCount;
  final int lateCount;

  MedicationStats({
    required this.totalScheduled,
    required this.totalTaken,
    required this.totalSkipped,
    required this.totalPending,
    required this.complianceRate,
    required this.onTimeCount,
    required this.lateCount,
  });

  factory MedicationStats.fromJson(Map<String, dynamic> json) {
    return MedicationStats(
      totalScheduled: json['total_scheduled'] ?? 0,
      totalTaken: json['total_taken'] ?? 0,
      totalSkipped: json['total_skipped'] ?? 0,
      totalPending: json['total_pending'] ?? 0,
      complianceRate: (json['compliance_rate'] ?? 0.0).toDouble(),
      onTimeCount: json['on_time_count'] ?? 0,
      lateCount: json['late_count'] ?? 0,
    );
  }

  /// Tỷ lệ uống đúng giờ
  double get onTimeRate {
    if (totalTaken == 0) return 0.0;
    return (onTimeCount / totalTaken) * 100;
  }

  /// Đánh giá mức độ tuân thủ
  String get complianceLevel {
    if (complianceRate >= 90) return 'Xuất sắc';
    if (complianceRate >= 75) return 'Tốt';
    if (complianceRate >= 50) return 'Trung bình';
    return 'Cần cải thiện';
  }
}
