import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobilev2/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiService.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("data: ${jsonEncode(data)}");
        return {
          'success': true,
          'message': 'Login was successful',
          'user': data['user'],
          'token': data['token'],
        };
      } else {
        print("data: ${jsonEncode(data)}");
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error occurred: $e'};
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.setBool('isLoggedIn', false);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> register(String email, String password, String username) async {
    try {
      final response = await http.post(
        Uri.parse(ApiService.registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'full_name': username,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        print("data: ${jsonEncode(data)}");
        return {
          'success': true,
          'message': data['message'] ?? 'Register successful',
        };
      } else {
        print("data: ${jsonEncode(data)}");
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> verifyRegisterOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(ApiService.verifyOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp_code': otp}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("data: ${jsonEncode(data)}");
        return {'success': true, 'message': data['message']};
      } else {
        print("data: ${jsonEncode(data)}");
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> verifyForgotPasswordOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(ApiService.verifyForgotPasswordOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp_code': otp}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("data: ${jsonEncode(data)}");
        return {'success': true, 'message': data['message']};
      } else {
        print("data: ${jsonEncode(data)}");
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(ApiService.forgotPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("data: ${jsonEncode(data)}");
        return {'success': true, 'message': data['message']};
      } else {
        print("data: ${jsonEncode(data)}");
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email, String otp, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse(ApiService.resetPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp_code': otp, 'password': newPassword}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("data: ${jsonEncode(data)}");
        return {'success': true, 'message': data['message']};
      } else {
        print("data: ${jsonEncode(data)}");
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error occurred: $e'};
    }
  }

  // Đổi tên người dùng
  Future<bool> updateUsername(int userId, String newUsername) async {
    try {
      final response = await http.put(
        Uri.parse(ApiService.updateUsernameUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'full_name': newUsername,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("data: ${jsonEncode(data)}");
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Lỗi đổi tên người dùng: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> resendRegisterOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse(ApiService.resendRegisterOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("data: ${jsonEncode(data)}");
        return {'success': true, 'message': data['message']};
      } else {
        print("data: ${jsonEncode(data)}");
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> resendForgotPasswordOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse(ApiService.resendForgotPasswordOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("data: ${jsonEncode(data)}");
        return {'success': true, 'message': data['message']};
      } else {
        print("data: ${jsonEncode(data)}");
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error occurred: $e'};
    }
  }
}
