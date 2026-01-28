import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mobilev2/models/medical_report_analysis_model.dart';
import 'package:mobilev2/services/api_service.dart';
import 'package:http_parser/http_parser.dart';

class MedicalReportService {
  Future<MedicalReportAnalysis> analyzeReport(Uint8List bytes, String filename, String token) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.analyzeMedicalReportUrl),
      );

      // Add Headers
      request.headers['Authorization'] = 'Bearer $token';

      // Detect MIME type
      String mimeType = 'application/pdf';
      final ext = filename.split('.').last.toLowerCase();
      if (ext == 'jpg' || ext == 'jpeg') {
        mimeType = 'image/jpeg';
      } else if (ext == 'png') {
        mimeType = 'image/png';
      }

      // Add File from bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);

      // Send Request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return MedicalReportAnalysis.fromJson(data);
      } else {
        throw Exception('Lỗi khi phân tích báo cáo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in MedicalReportService.analyzeReport: $e');
      rethrow;
    }
  }
}
