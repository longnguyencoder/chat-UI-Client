import 'dart:async';

import 'package:flutter/material.dart';
import '../../services/auth/auth_service.dart';

class VerifyOtpViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String _email = '';
  String _otpCode = '';
  bool isLoading = false;
  String errorMessage = '';

  // Resend OTP functionality
  bool canResend = false;
  int resendCountdown = 61;
  Timer? _resendTimer;

  String get email => _email;
  String get otpCode => _otpCode;
  bool get canVerify {
    final result = _otpCode.length == 6 && _email.isNotEmpty;
    // print('🔍 canVerify check: otpCode.length=${_otpCode.length}, email.isNotEmpty=${_email.isNotEmpty}, result=$result');
    return result;
  }

  void setEmail(String email) {
    // print('📧 Setting email: $email');
    _email = email;
    _startResendTimer();
    notifyListeners();
  }

  void updateOtpCode(String code) {
    // print('🔢 ViewModel.updateOtpCode called with: "$code" (length: ${code.length})');
    // print('🔢 Before update: _otpCode = "$_otpCode"');
    _otpCode = code;
    errorMessage = '';

    // print('🔢 After update: _otpCode = "$_otpCode"');
    // print('🔔 Calling notifyListeners()');

    notifyListeners();

    // print('✅ notifyListeners() completed');
  }

  void _startResendTimer() {
    canResend = false;
    resendCountdown = 60;

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown > 0) {
        resendCountdown--;
        notifyListeners();
      } else {
        canResend = true;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  Future<void> resendOtp() async {
    if (!canResend || _email.isEmpty) return;

    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      // Gọi API gửi lại OTP đăng ký
      final result = await _authService.resendRegisterOtp(_email);

      if (result['success'] as bool) {
        _startResendTimer();
        errorMessage = '';
      } else {
        errorMessage = result['message'] ?? 'Không thể gửi lại mã OTP';
      }
    } catch (e) {
      errorMessage = 'Có lỗi xảy ra: $e';
      print('❌ Lỗi gửi lại OTP: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp() async {
    // print('🚀 verifyOtp called - Email: $_email, OTP: $_otpCode');
    if (_email.isEmpty) {
      errorMessage = 'Không tìm thấy email';
      notifyListeners();
      return false;
    }

    if (_otpCode.length != 6) {
      errorMessage = 'Vui lòng nhập đầy đủ 6 chữ số';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      // print("ℹ️ Đang xác minh OTP đăng ký");
      // print("📧 Email: $_email");
      // print("🔢 OTP: $_otpCode");
      final result = await _authService.verifyRegisterOtp(
        _email,
        _otpCode,
      );
      // print("📋 Kết quả từ API: $result");
      if (!(result['success'] as bool)) {
        print(result);
        errorMessage = result['message'];
      }
      return result['success'] as bool;
    } catch (e) {
      errorMessage = 'Error occurred: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
