import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobilev2/services/auth/auth_service.dart';
import 'package:mobilev2/views/auth/reset_password_view.dart';

class VerifyOtpForgotPassViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String email;

  // OTP Controllers and Focus Nodes
  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  int _focusedIndex = 0;

  // Resend timer
  Timer? _resendTimer;
  int _resendCountdown = 0;
  bool _canResend = true;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  int get focusedIndex => _focusedIndex;
  int get resendCountdown => _resendCountdown;
  bool get canResend => _canResend;

  bool get canConfirm {
    return otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  String get otpCode {
    return otpControllers.map((controller) => controller.text).join();
  }

  VerifyOtpForgotPassViewModel({this.email=''}) {
    _initializeControllers();
    // Khởi tạo timer ngay khi viewmodel được tạo
    _startResendTimer();
  }

  // Phương thức để cập nhật email sau khi khởi tạo
  void updateEmail(String newEmail) {
    email = newEmail;
  }

  void _initializeControllers() {
    otpControllers = List.generate(6, (index) => TextEditingController());
    focusNodes = List.generate(6, (index) => FocusNode());

    // Add listeners to focus nodes
    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].addListener(() {
        if (focusNodes[i].hasFocus) {
          _focusedIndex = i;
          notifyListeners();
        }
      });
    }
  }

  void onOtpChanged(String value, int index) {
    // Xóa thông báo lỗi và thành công khi người dùng bắt đầu nhập
    if (_errorMessage != null || _successMessage != null) {
      _errorMessage = null;
      _successMessage = null;
    }

    if (value.isNotEmpty) {
      // Move to next field if not the last one
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        // If it's the last field, unfocus
        focusNodes[index].unfocus();
      }
    }

    notifyListeners();
  }

  void onFieldTapped(int index) {
    _focusedIndex = index;

    // Clear the field and all fields after it when tapped
    for (int i = index; i < otpControllers.length; i++) {
      otpControllers[i].clear();
    }

    notifyListeners();
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (!canConfirm) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.verifyForgotPasswordOtp(email, otpCode);

      if (result['success'] as bool) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordView(
                email: email,
                otp: otpCode,
              ),
            ),
          );

        }
      } else {
        _errorMessage = result['message'] ?? 'Mã OTP không đúng';
        _shakeAnimation();
      }
    } catch (e) {
      _errorMessage = 'Lỗi xác thực OTP: $e';
      _shakeAnimation();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resendOtp() async {
    if (!_canResend || email.isEmpty) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
      notifyListeners();

      final result = await _authService.resendForgotPasswordOtp(email);

      if (result['success'] as bool) {
        _startResendTimer();
        _successMessage = 'Mã OTP đã được gửi lại thành công!';
        print('✅ Gửi lại OTP thành công, bắt đầu đếm ngược 60s');
        
        // Tự động ẩn thông báo thành công sau 3 giây
        Timer(const Duration(seconds: 3), () {
          _successMessage = null;
          notifyListeners();
        });
      } else {
        _errorMessage = result['message'] ?? 'Không thể gửi lại mã OTP';
        print('❌ Gửi lại OTP thất bại: ${result['message']}');
      }
    } catch (e) {
      _errorMessage = 'Lỗi khi gửi lại mã OTP: $e';
      print('❌ Lỗi gửi lại OTP: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startResendTimer() {
    // Hủy timer cũ nếu có
    _resendTimer?.cancel();
    
    _canResend = false;
    _resendCountdown = 60; // 60 seconds countdown
    
    print('⏰ Bắt đầu đếm ngược: ${_resendCountdown}s');

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _resendCountdown--;
      
      print('⏰ Đếm ngược: ${_resendCountdown}s');

      if (_resendCountdown <= 0) {
        _canResend = true;
        timer.cancel();
        print('✅ Hết thời gian chờ, có thể gửi lại OTP');
      }

      notifyListeners();
    });
  }

  void _clearOtpFields() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
    _focusedIndex = 0;
  }

  void _shakeAnimation() {
    // Clear all fields and focus on first field for re-entry
    _clearOtpFields();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();

    for (var controller in otpControllers) {
      controller.dispose();
    }

    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }
}
