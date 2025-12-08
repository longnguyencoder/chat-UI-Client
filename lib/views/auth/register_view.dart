import 'package:flutter/material.dart';
import 'package:mobilev2/viewmodels/auth/register_viewmodel.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => RegisterViewModel().goToLogin(context),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Consumer<RegisterViewModel>(
                builder: (context, viewModel, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      const Text(
                        'Tạo tài khoản mới',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bắt đầu hành trình của bạn với chúng tôi',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Form container
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Username field
                            TextField(
                              controller: viewModel.usernameController,
                              decoration: InputDecoration(
                                labelText: 'Tên người dùng',
                                hintText: 'Nhập tên của bạn',
                                prefixIcon: Icon(Icons.person_outline, color: Colors.grey.shade600),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),

                            // Email field
                            TextField(
                              controller: viewModel.emailController,
                              decoration: InputDecoration(
                                labelText: 'Địa chỉ email',
                                hintText: 'example@email.com',
                                prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 20),

                            // Password field
                            TextField(
                              controller: viewModel.passwordController,
                              obscureText: viewModel.obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                hintText: 'Tối thiểu 6 ký tự',
                                prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey.shade600),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    viewModel.obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: viewModel.togglePasswordVisibility,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Error message
                            if (viewModel.errorMessage != null)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 24),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        viewModel.errorMessage!,
                                        style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Register button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: viewModel.canRegister && !viewModel.isLoading
                                    ? () async {
                                        final success = await viewModel.register();
                                        if (success && context.mounted) {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/verify_otp',
                                            arguments: {
                                              'email': viewModel.emailController.text.trim(),
                                              'otp_type': 'register',
                                            },
                                          );
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  disabledBackgroundColor: Colors.grey.shade300,
                                  disabledForegroundColor: Colors.grey.shade600,
                                ),
                                child: viewModel.isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Đăng ký',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Bạn đã có tài khoản? ",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                          TextButton(
                            onPressed: () => viewModel.goToLogin(context),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue.shade600,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                            child: const Text(
                              'Đăng nhập ngay',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}