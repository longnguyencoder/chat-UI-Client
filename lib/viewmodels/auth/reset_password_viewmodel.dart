import 'package:flutter/material.dart';
import 'package:mobilev2/services/auth/auth_service.dart';

class ResetPasswordViewModel extends ChangeNotifier{
  final String email;
  final String otp;

  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final newPasswordFocusNode = FocusNode();
  final newPasswordConfirmFocusNode = FocusNode();

  bool _obscureResetPassword = true;
  bool _obscureResetConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  bool get obscureResetPassword => _obscureResetPassword;
  bool get obscureResetConfirmPassword => _obscureResetConfirmPassword;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get canResetPassword => _validateInputs();

  ResetPasswordViewModel({required this.email, required this.otp}) {
    newPasswordController.addListener(_onTextChanged);
    confirmPasswordController.addListener(_onTextChanged);
    newPasswordFocusNode.addListener(_handleFocusChange);
    newPasswordConfirmFocusNode.addListener(_handleFocusChange);
    print('Email: $email, OTP: $otp');
  }

  bool _validateInputs() {
    final newPassword = newPasswordController.text.trim();
    final newPasswordConfirm = confirmPasswordController.text.trim();

    // Kiểm tra mật khẩu mới
    if (newPassword.isEmpty) {
      return false;
    }

    if (newPassword.length < 6) {
      return false;
    }

    // Kiểm tra xác nhận mật khẩu
    if (newPasswordConfirm.isEmpty) {
      return false;
    }

    if (newPassword != newPasswordConfirm) {
      return false;
    }

    // Kiểm tra email
    if (email.isEmpty) {
      return false;
    }

    // Kiểm tra OTP đã xác nhận
    if (otp.isEmpty) {
      return false;
    }

    return true;
  }

  void toggleNewPasswordVisibility(){
    _obscureResetPassword = !_obscureResetPassword;
    notifyListeners();
  }

  void toggleNewConfirmPasswordVisibility(){
    _obscureResetConfirmPassword = !_obscureResetConfirmPassword;
    notifyListeners();
  }

  void _onTextChanged() {
    _clearErrorAndValidate();
  }

  void onTextChanged() {
    _clearErrorAndValidate();
  }

  void _clearErrorAndValidate() {
    final newPassword = newPasswordController.text.trim();
    final newPasswordConfirm = confirmPasswordController.text.trim();

    // Xóa error message khi user bắt đầu nhập
    if (newPassword.isEmpty && newPasswordConfirm.isEmpty) {
      _errorMessage = null;
      notifyListeners();
      return;
    }

    // Validate và set error message
    if (newPassword.isNotEmpty && newPassword.length < 6) {
      _errorMessage = 'Mật khẩu phải có ít nhất 6 ký tự';
    } else if (newPasswordConfirm.isNotEmpty && newPassword != newPasswordConfirm) {
      _errorMessage = 'Mật khẩu xác nhận không khớp';
    } else {
      _errorMessage = null;
    }

    notifyListeners();
  }

  Future<bool> resetPassword(BuildContext context) async{
    if (!canResetPassword) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final result = await _authService.resetPassword(
          email.trim(),
          otp.trim(),
          newPasswordController.text.trim());

      if (!(result['success'] as bool)) {
        print(result);
        _errorMessage = result['message'] ?? 'Có lỗi xảy ra, vui lòng thử lại';
      }

      // Hiển thị thông báo thành công
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đặt lại mật khẩu thành công!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Chuyển về trang login
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
              (route) => false,
        );
      }

      return result['success'] as bool;
    }catch (e){
      _errorMessage = 'Error occurred: $e';
      return false;
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  void _handleFocusChange() {
    if (newPasswordFocusNode.hasFocus || newPasswordConfirmFocusNode.hasFocus) {
      // Xóa error message khi focus vào field
      _errorMessage = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    newPasswordFocusNode.dispose();
    newPasswordConfirmFocusNode.dispose();
    super.dispose();
  }
}