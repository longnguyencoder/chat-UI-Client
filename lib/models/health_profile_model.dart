class HealthProfileModel {
  final int? id;
  final int userId;
  final DateTime? dateOfBirth;
  final String? gender;
  final List<String> allergies;
  final List<String> chronicDiseases;
  final List<String> currentMedications;

  HealthProfileModel({
    this.id,
    required this.userId,
    this.dateOfBirth,
    this.gender,
    this.allergies = const [],
    this.chronicDiseases = const [],
    this.currentMedications = const [],
  });

  HealthProfileModel copyWith({
    int? id,
    int? userId,
    DateTime? dateOfBirth,
    String? gender,
    List<String>? allergies,
    List<String>? chronicDiseases,
    List<String>? currentMedications,
  }) {
    return HealthProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      currentMedications: currentMedications ?? this.currentMedications,
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
    };
  }

  bool get isEmpty {
    return dateOfBirth == null &&
        gender == null &&
        allergies.isEmpty &&
        chronicDiseases.isEmpty &&
        currentMedications.isEmpty;
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
