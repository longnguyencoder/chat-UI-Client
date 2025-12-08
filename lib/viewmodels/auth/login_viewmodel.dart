import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobilev2/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  final bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  bool get obscurePassword => _obscurePassword;

  bool get isLoading => _isLoading;

  bool get canLogin => _validateInputs();

  String? get errorMessage => _errorMessage;

  LoginViewModel() {
    emailController.addListener(_onTextChanged);
    passwordController.addListener(_onTextChanged);
  }

  bool _validateInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    _errorMessage = null;

    final emailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    final passwordValid = password.length >= 6;

    return emailValid && passwordValid;
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void _onTextChanged() {
    notifyListeners();
  }

  Future<bool> login(BuildContext context) async {
    if (!canLogin) return false;
    _isLoading = true;
    notifyListeners();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final result = await _authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!(result['success'] as bool)) {
        print("==============result false==============: \n");
        print(result);
        _errorMessage = result['message'];
      }else{
        print("==============result true==============: \n");
        print(result);
      }

      if (result.containsKey('user')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(result['user']));
      }

      // ✅ Lưu token nếu có
      if (result.containsKey('token')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result['token']);
      }

      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        final user = UserModel.fromJson(jsonDecode(userJson));
        // Provider.of<UserProvider>(context, listen: false).setUser(user);
        userProvider.setUser(user);
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

  void goToRegister(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/register');
  }

  void goToForgotPassword(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/forgot_password');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
