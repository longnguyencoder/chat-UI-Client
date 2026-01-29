class MedicalReportAnalysis {
  final bool success;
  final AnalysisData data;

  MedicalReportAnalysis({
    required this.success,
    required this.data,
  });

  factory MedicalReportAnalysis.fromJson(Map<String, dynamic> json) {
    return MedicalReportAnalysis(
      success: json['success'] ?? false,
      data: AnalysisData.fromJson(json['data'] ?? {}),
    );
  }
}

class AnalysisData {
  final PatientInfo patientInfo;
  final List<MedicalIndicator> indicators;
  final String summary;
  final String advice;

  AnalysisData({
    required this.patientInfo,
    required this.indicators,
    required this.summary,
    required this.advice,
  });

  factory AnalysisData.fromJson(Map<String, dynamic> json) {
    var indicatorList = (json['indicators'] as List? ?? [])
        .map((i) => MedicalIndicator.fromJson(i))
        .toList();

    return AnalysisData(
      patientInfo: PatientInfo.fromJson(json['patient_info'] ?? {}),
      indicators: indicatorList,
      summary: json['summary'] ?? '',
      advice: json['advice'] ?? '',
    );
  }
}

class PatientInfo {
  final String name;
  final String date;

  PatientInfo({
    required this.name,
    required this.date,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      name: json['name'] ?? 'Không rõ',
      date: json['date'] ?? 'Không rõ',
    );
  }
}

class MedicalIndicator {
  final String name;
  final String result;
  final String referenceRange;
  final String unit;
  final String status;
  final String explanation;

  MedicalIndicator({
    required this.name,
    required this.result,
    required this.referenceRange,
    required this.unit,
    required this.status,
    this.explanation = '',
  });

  factory MedicalIndicator.fromJson(Map<String, dynamic> json) {
    return MedicalIndicator(
      name: json['name'] ?? '',
      result: json['result'] ?? '',
      referenceRange: json['reference_range'] ?? '',
      unit: json['unit'] ?? '',
      status: json['status'] ?? 'Bình thường',
      explanation: json['explanation'] ?? '',
    );
  }

  bool get isAbnormal => status != 'Bình thường';
}
