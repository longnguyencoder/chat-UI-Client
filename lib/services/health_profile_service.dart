import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobilev2/models/health_profile_model.dart';
import 'package:mobilev2/services/api_service.dart';
import 'package:mobilev2/services/auth/auth_service.dart';

class HealthProfileService {
  final AuthService _authService = AuthService();

  /// Lấy hồ sơ sức khỏe của người dùng
  Future<Map<String, dynamic>> getHealthProfile(int userId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token xác thực',
        };
      }

      final response = await http.get(
        Uri.parse(ApiService.getHealthProfileUrl(userId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("✅ Lấy hồ sơ sức khỏe thành công: ${jsonEncode(data)}");
        return {
          'success': true,
          'data': data,
        };
      } else if (response.statusCode == 404) {
        // Chưa có hồ sơ
        print("ℹ️ Chưa có hồ sơ sức khỏe");
        return {
          'success': true,
          'data': null,
        };
      } else {
        print("❌ Lỗi lấy hồ sơ sức khỏe: ${jsonEncode(data)}");
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể lấy hồ sơ sức khỏe',
        };
      }
    } catch (e) {
      print("❌ Exception khi lấy hồ sơ sức khỏe: $e");
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }

  /// Cập nhật hồ sơ sức khỏe
  Future<Map<String, dynamic>> updateHealthProfile(
    HealthProfileModel profile,
  ) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token xác thực',
        };
      }

      final requestBody = jsonEncode(profile.toJson());
      print("📤 Dữ liệu gửi lên API: $requestBody");

      final response = await http.put(
        Uri.parse(ApiService.updateHealthProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Cập nhật hồ sơ sức khỏe thành công: ${jsonEncode(data)}");
        return {
          'success': true,
          'message': data['message'] ?? 'Cập nhật hồ sơ thành công',
          'data': data,
        };
      } else {
        print("❌ Lỗi cập nhật hồ sơ sức khỏe: ${jsonEncode(data)}");
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể cập nhật hồ sơ sức khỏe',
        };
      }
    } catch (e) {
      print("❌ Exception khi cập nhật hồ sơ sức khỏe: $e");
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }

  /// Lấy phân tích sức khỏe (BMI, bệnh mãn tính)
  Future<Map<String, dynamic>> getHealthAnalysis() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token xác thực',
        };
      }

      final response = await http.get(
        Uri.parse(ApiService.getHealthAnalysisUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("✅ Lấy phân tích sức khỏe thành công: ${jsonEncode(data)}");
        return {
          'success': true,
          'data': data,
        };
      } else if (response.statusCode == 404) {
        print("ℹ️ Chưa có dữ liệu phân tích");
        return {
          'success': false,
          'message': 'Chưa có dữ liệu để phân tích. Vui lòng cập nhật hồ sơ sức khỏe.',
        };
      } else {
        print("❌ Lỗi lấy phân tích sức khỏe: ${jsonEncode(data)}");
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể lấy phân tích sức khỏe',
        };
      }
    } catch (e) {
      print("❌ Exception khi lấy phân tích sức khỏe: $e");
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }

  /// Lấy lời khuyên chi tiết (diet, rest, exercise)
  Future<Map<String, dynamic>> getHealthRecommendations() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy token xác thực',
        };
      }

      final response = await http.get(
        Uri.parse(ApiService.getHealthRecommendationsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("✅ Lấy lời khuyên sức khỏe thành công: ${jsonEncode(data)}");
        return {
          'success': true,
          'data': data,
        };
      } else if (response.statusCode == 404) {
        print("ℹ️ Chưa có dữ liệu lời khuyên");
        return {
          'success': false,
          'message': 'Chưa có dữ liệu để tạo lời khuyên. Vui lòng cập nhật hồ sơ sức khỏe.',
        };
      } else {
        print("❌ Lỗi lấy lời khuyên sức khỏe: ${jsonEncode(data)}");
        return {
          'success': false,
          'message': data['message'] ?? 'Không thể lấy lời khuyên sức khỏe',
        };
      }
    } catch (e) {
      print("❌ Exception khi lấy lời khuyên sức khỏe: $e");
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }
}
