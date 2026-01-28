import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobilev2/models/medical_report_analysis_model.dart';
import 'package:mobilev2/services/medical_report_service.dart';

enum AnalysisStatus { idle, loading, success, error }

class MedicalReportViewModel extends ChangeNotifier {
  final MedicalReportService _service = MedicalReportService();
  
  AnalysisStatus _status = AnalysisStatus.idle;
  AnalysisStatus get status => _status;

  MedicalReportAnalysis? _analysis;
  MedicalReportAnalysis? get analysis => _analysis;

  String? _error;
  String? get error => _error;

  PlatformFile? _selectedFile;
  PlatformFile? get selectedFile => _selectedFile;

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true, // Quan trọng để lấy bytes trên Web
      );

      if (result != null) {
        _selectedFile = result.files.single;
        _error = null;
        _analysis = null;
        _status = AnalysisStatus.idle;
        notifyListeners();
      }
    } catch (e) {
      _error = "Lỗi khi chọn file: $e";
      notifyListeners();
    }
  }

  Future<void> analyzeReport(String token) async {
    if (_selectedFile == null || _selectedFile!.bytes == null) {
      _error = "Dữ liệu file không hợp lệ hoặc chưa được chọn.";
      notifyListeners();
      return;
    }

    _status = AnalysisStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _analysis = await _service.analyzeReport(
        _selectedFile!.bytes!, 
        _selectedFile!.name,
        token,
      );
      _status = AnalysisStatus.success;
    } catch (e) {
      _status = AnalysisStatus.error;
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void clearSelection() {
    _selectedFile = null;
    _analysis = null;
    _status = AnalysisStatus.idle;
    _error = null;
    notifyListeners();
  }
}
