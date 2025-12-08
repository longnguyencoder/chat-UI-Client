import 'package:flutter/material.dart';
import 'package:mobilev2/viewmodels/auth/reset_password_viewmodel.dart';
import 'package:provider/provider.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPasswordView({super.key ,required this.email, required this.otp});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResetPasswordViewModel(email: widget.email, otp: widget.otp),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đặt lại mật khẩu'),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Consumer<ResetPasswordViewModel>(
                builder: (context, viewModel, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_reset,
                          size: 40,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Tạo mật khẩu mới',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nhập mật khẩu mới cho tài khoản của bạn',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Thông tin xác thực
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.green.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Thông tin đã xác thực',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  color: Colors.grey.shade600,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Email: ${widget.email}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.otp.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.security,
                                    color: Colors.grey.shade600,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'OTP: ${widget.otp}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // New Password field
                      TextField(
                        controller: viewModel.newPasswordController,
                        focusNode: viewModel.newPasswordFocusNode,
                        obscureText: viewModel.obscureResetPassword,
                        onChanged: (value) => viewModel.onTextChanged(),
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu mới',
                          hintText: 'Nhập mật khẩu mới (ít nhất 6 ký tự)',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              viewModel.obscureResetPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: viewModel.toggleNewPasswordVisibility,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // New Password Confirm field
                      TextField(
                        controller: viewModel.confirmPasswordController,
                        focusNode: viewModel.newPasswordConfirmFocusNode,
                        obscureText: viewModel.obscureResetConfirmPassword,
                        onChanged: (value) => viewModel.onTextChanged(),
                        decoration: InputDecoration(
                          labelText: 'Xác nhận mật khẩu mới',
                          hintText: 'Nhập lại mật khẩu mới',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              viewModel.obscureResetConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed:
                                viewModel.toggleNewConfirmPasswordVisibility,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Error message
                      if (viewModel.errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.red.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  viewModel.errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed:
                              viewModel.canResetPassword && !viewModel.isLoading
                                  ? () async {
                                    await viewModel.resetPassword(context);
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                viewModel.canResetPassword
                                    ? Colors.blue.shade600
                                    : Colors.blue.withOpacity(0.5),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child:
                              viewModel.isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                  : const Text(
                                    'Đặt lại mật khẩu',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Back to login
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Quay lại đăng nhập',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
