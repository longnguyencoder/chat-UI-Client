import 'package:flutter/material.dart';
import 'package:mobilev2/services/auth/auth_service.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  final bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  bool get isLoading => _isLoading;

  bool get canContinue => _validateInputs();

  String? get errorMessage => _errorMessage;

  ForgotPasswordViewModel() {
    emailController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    final email = emailController.text.trim();
    _errorMessage = null;
    final emailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);

    return emailValid;
  }

  void _onTextChanged() {
    notifyListeners();
  }

  Future<bool> forgotPassword(BuildContext context) async {
    if (!canContinue) return false;
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.forgotPassword(
        emailController.text.trim(),
      );

      if (!(result['success'] as bool)) {
        _errorMessage = result['message'];
      }

      return result['success'] as bool;
    } catch (e) {
      _errorMessage = 'Error occurred: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
