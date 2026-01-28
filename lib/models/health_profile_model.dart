class HealthProfileModel {
  final int? id;
  final int userId;
  final DateTime? dateOfBirth;
  final String? gender;
  final List<String> allergies;
  final List<String> chronicDiseases;
  final List<String> currentMedications;
  final String? bloodType;
  final double? height;
  final double? weight;
  final String? familyHistory;
  final String? aiAnalysis; // AI-generated health advice

  HealthProfileModel({
    this.id,
    required this.userId,
    this.dateOfBirth,
    this.gender,
    this.allergies = const [],
    this.chronicDiseases = const [],
    this.currentMedications = const [],
    this.bloodType,
    this.height,
    this.weight,
    this.familyHistory,
    this.aiAnalysis,
  });

  HealthProfileModel copyWith({
    int? id,
    int? userId,
    DateTime? dateOfBirth,
    String? gender,
    List<String>? allergies,
    List<String>? chronicDiseases,
    List<String>? currentMedications,
    String? bloodType,
    double? height,
    double? weight,
    String? familyHistory,
    String? aiAnalysis,
  }) {
    return HealthProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      currentMedications: currentMedications ?? this.currentMedications,
      bloodType: bloodType ?? this.bloodType,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      familyHistory: familyHistory ?? this.familyHistory,
      aiAnalysis: aiAnalysis ?? this.aiAnalysis,
    );
  }

  factory HealthProfileModel.fromJson(Map<String, dynamic> json) {
    return HealthProfileModel(
      id: json['id'],
      userId: json['user_id'],
      dateOfBirth: json['date_of_birth'] != null 
          ? DateTime.parse(json['date_of_birth'])
          : null,
      gender: genderToVietnamese(json['gender']),
      allergies: json['allergies'] != null 
          ? List<String>.from(json['allergies'])
          : [],
      // Hỗ trợ cả chronic_conditions (từ backend) và chronic_diseases
      chronicDiseases: (json['chronic_conditions'] ?? json['chronic_diseases']) != null
          ? List<String>.from(json['chronic_conditions'] ?? json['chronic_diseases'])
          : [],
      // Hỗ trợ cả medications (từ backend) và current_medications
      currentMedications: (json['medications'] ?? json['current_medications']) != null
          ? List<String>.from(json['medications'] ?? json['current_medications'])
          : [],
      bloodType: json['blood_type'],
      height: json['height'] != null ? (json['height'] as num).toDouble() : null,
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      familyHistory: json['family_history'],
      aiAnalysis: json['ai_analysis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'date_of_birth': dateOfBirth != null 
          ? '${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}'
          : null,
      'gender': genderToEnglish(gender),
      'allergies': allergies,
      'chronic_conditions': chronicDiseases,  // Backend dùng chronic_conditions
      'medications': currentMedications,       // Backend dùng medications
      'blood_type': bloodType,
      'height': height,
      'weight': weight,
      'family_history': familyHistory,
    };
  }

  bool get isEmpty {
    return dateOfBirth == null &&
        gender == null &&
        allergies.isEmpty &&
        chronicDiseases.isEmpty &&
        currentMedications.isEmpty &&
        bloodType == null &&
        height == null &&
        weight == null &&
        familyHistory == null;
  }

  /// Tính BMI real-time
  double? get bmi {
    if (height == null || weight == null || height == 0) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// Phân loại BMI
  String get bmiCategory {
    final value = bmi;
    if (value == null) return 'N/A';
    if (value < 18.5) return 'Thiếu cân';
    if (value < 25) return 'Bình thường';
    if (value < 30) return 'Thừa cân';
    return 'Béo phì';
  }

  /// Chuyển đổi giới tính từ tiếng Việt sang tiếng Anh (cho API)
  static String? genderToEnglish(String? vietnameseGender) {
    if (vietnameseGender == null) return null;
    switch (vietnameseGender) {
      case 'Nam':
        return 'Male';
      case 'Nữ':
        return 'Female';
      case 'Khác':
        return 'Other';
      default:
        return vietnameseGender; // Trả về giá trị gốc nếu đã là tiếng Anh
    }
  }

  /// Chuyển đổi giới tính từ tiếng Anh sang tiếng Việt (cho hiển thị)
  static String? genderToVietnamese(String? englishGender) {
    if (englishGender == null) return null;
    switch (englishGender) {
      case 'Male':
        return 'Nam';
      case 'Female':
        return 'Nữ';
      case 'Other':
        return 'Khác';
      default:
        return englishGender; // Trả về giá trị gốc nếu đã là tiếng Việt
    }
  }
}
