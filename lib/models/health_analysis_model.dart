/// Model cho phân tích BMI
class BMIAnalysis {
  final double value;
  final String category;
  final String categoryLabel;
  final String assessment;
  final List<String> recommendations;

  BMIAnalysis({
    required this.value,
    required this.category,
    required this.categoryLabel,
    required this.assessment,
    required this.recommendations,
  });

  factory BMIAnalysis.fromJson(Map<String, dynamic> json) {
    return BMIAnalysis(
      value: (json['value'] as num).toDouble(),
      category: json['category'] ?? '',
      categoryLabel: json['category_label'] ?? '',
      assessment: json['assessment'] ?? '',
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : [],
    );
  }
}

/// Model cho phân tích bệnh mãn tính
class ChronicConditionAnalysis {
  final String condition;
  final String type;
  final List<String> dietRecommendations;
  final List<String> exerciseRecommendations;
  final List<String> monitoring;

  ChronicConditionAnalysis({
    required this.condition,
    required this.type,
    required this.dietRecommendations,
    required this.exerciseRecommendations,
    required this.monitoring,
  });

  factory ChronicConditionAnalysis.fromJson(Map<String, dynamic> json) {
    return ChronicConditionAnalysis(
      condition: json['condition'] ?? '',
      type: json['type'] ?? '',
      dietRecommendations: json['diet_recommendations'] != null
          ? List<String>.from(json['diet_recommendations'])
          : [],
      exerciseRecommendations: json['exercise_recommendations'] != null
          ? List<String>.from(json['exercise_recommendations'])
          : [],
      monitoring: json['monitoring'] != null
          ? List<String>.from(json['monitoring'])
          : [],
    );
  }
}

/// Model cho phân tích tổng quan sức khỏe
class HealthAnalysis {
  final int userId;
  final BMIAnalysis bmi;
  final List<ChronicConditionAnalysis> chronicConditionsAnalysis;
  final String overallHealthStatus;
  final String message;

  HealthAnalysis({
    required this.userId,
    required this.bmi,
    required this.chronicConditionsAnalysis,
    required this.overallHealthStatus,
    required this.message,
  });

  factory HealthAnalysis.fromJson(Map<String, dynamic> json) {
    return HealthAnalysis(
      userId: json['user_id'] ?? 0,
      bmi: BMIAnalysis.fromJson(json['bmi'] ?? {}),
      chronicConditionsAnalysis: json['chronic_conditions_analysis'] != null
          ? (json['chronic_conditions_analysis'] as List)
              .map((item) => ChronicConditionAnalysis.fromJson(item))
              .toList()
          : [],
      overallHealthStatus: json['overall_health_status'] ?? '',
      message: json['message'] ?? '',
    );
  }

  /// Lấy màu sắc theo trạng thái sức khỏe
  String get statusColor {
    switch (overallHealthStatus) {
      case 'good':
        return 'green';
      case 'needs_attention':
        return 'orange';
      case 'critical':
        return 'red';
      default:
        return 'grey';
    }
  }

  /// Lấy label tiếng Việt cho trạng thái
  String get statusLabel {
    switch (overallHealthStatus) {
      case 'good':
        return 'Tốt';
      case 'needs_attention':
        return 'Cần chú ý';
      case 'critical':
        return 'Nghiêm trọng';
      default:
        return 'Chưa xác định';
    }
  }
}
