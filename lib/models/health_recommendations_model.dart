/// Model cho khuyến nghị về chế độ ăn
class DietRecommendation {
  final String summary;
  final List<String> recommendations;
  final List<String> foodsToAvoid;
  final List<String> foodsToInclude;

  DietRecommendation({
    required this.summary,
    required this.recommendations,
    required this.foodsToAvoid,
    required this.foodsToInclude,
  });

  factory DietRecommendation.fromJson(Map<String, dynamic> json) {
    return DietRecommendation(
      summary: json['summary'] ?? '',
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : [],
      foodsToAvoid: json['foods_to_avoid'] != null
          ? List<String>.from(json['foods_to_avoid'])
          : [],
      foodsToInclude: json['foods_to_include'] != null
          ? List<String>.from(json['foods_to_include'])
          : [],
    );
  }
}

/// Model cho khuyến nghị về nghỉ ngơi
class RestRecommendation {
  final String sleepHours;
  final String ageGroup;
  final List<String> recommendations;

  RestRecommendation({
    required this.sleepHours,
    required this.ageGroup,
    required this.recommendations,
  });

  factory RestRecommendation.fromJson(Map<String, dynamic> json) {
    return RestRecommendation(
      sleepHours: json['sleep_hours'] ?? '',
      ageGroup: json['age_group'] ?? '',
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : [],
    );
  }
}

/// Model cho khuyến nghị về tập luyện
class ExerciseRecommendation {
  final String frequency;
  final String duration;
  final List<String> types;
  final List<String> recommendations;

  ExerciseRecommendation({
    required this.frequency,
    required this.duration,
    required this.types,
    required this.recommendations,
  });

  factory ExerciseRecommendation.fromJson(Map<String, dynamic> json) {
    return ExerciseRecommendation(
      frequency: json['frequency'] ?? '',
      duration: json['duration'] ?? '',
      types: json['types'] != null
          ? List<String>.from(json['types'])
          : [],
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : [],
    );
  }
}

/// Model cho lời khuyên sức khỏe tổng hợp
class HealthRecommendations {
  final int userId;
  final DietRecommendation diet;
  final RestRecommendation rest;
  final ExerciseRecommendation exercise;
  final String aiInsights;
  final String message;

  HealthRecommendations({
    required this.userId,
    required this.diet,
    required this.rest,
    required this.exercise,
    required this.aiInsights,
    required this.message,
  });

  factory HealthRecommendations.fromJson(Map<String, dynamic> json) {
    return HealthRecommendations(
      userId: json['user_id'] ?? 0,
      diet: DietRecommendation.fromJson(json['diet'] ?? {}),
      rest: RestRecommendation.fromJson(json['rest'] ?? {}),
      exercise: ExerciseRecommendation.fromJson(json['exercise'] ?? {}),
      aiInsights: json['ai_insights'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
