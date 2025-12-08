import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobilev2/viewmodels/auth/otp_forgotpass_view_model.dart';
import 'package:provider/provider.dart';

class VerifyOtpForgotPassView extends StatefulWidget {
  const VerifyOtpForgotPassView({super.key});

  @override
  State<VerifyOtpForgotPassView> createState() => _OtpForgotPassViewState();
}

class _OtpForgotPassViewState extends State<VerifyOtpForgotPassView> {
  late VerifyOtpForgotPassViewModel _viewModel;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _viewModel = VerifyOtpForgotPassViewModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      // Lấy email từ route arguments và cập nhật vào ViewModel
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final email = arguments?['email'] ?? '';

      // Cập nhật email vào ViewModel
      if (email.isNotEmpty) {
        _viewModel.updateEmail(email);
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final email = arguments?['email'] ?? '';

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Consumer<VerifyOtpForgotPassViewModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Header
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(25, 0, 0, 0),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Xác thực email',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Chúng tôi đã gửi mã xác thực 6 chữ số đến\n',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: email,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return _buildOtpField(context, viewModel, index);
                      }),
                    ),

                    const SizedBox(height: 16),

                    // Error message
                    if (viewModel.errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                viewModel.errorMessage!,
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Success message
                    if (viewModel.successMessage != null)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                viewModel.successMessage!,
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Confirm button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            viewModel.canConfirm && !viewModel.isLoading
                                ? () => viewModel.verifyOtp(context)
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              viewModel.canConfirm
                                  ? Colors.blue
                                  : Colors.grey[300],
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            viewModel.isLoading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'Xác nhận',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Resend code
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Không nhận được mã? ',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: viewModel.canResend && !viewModel.isLoading
                              ? () => viewModel.resendOtp()
                              : null,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: viewModel.isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                  ),
                                )
                              : Text(
                                  viewModel.canResend
                                      ? 'Gửi lại'
                                      : 'Gửi lại (${viewModel.resendCountdown}s)',
                                  style: TextStyle(
                                    color: viewModel.canResend && !viewModel.isLoading
                                        ? Colors.blue
                                        : Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ],
                    ),

                    const Spacer(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(
    BuildContext context,
    VerifyOtpForgotPassViewModel viewModel,
    int index,
  ) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              viewModel.focusedIndex == index
                  ? Colors.blue
                  : (viewModel.otpControllers[index].text.isNotEmpty
                      ? Colors.green
                      : Colors.grey[300]!),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: viewModel.otpControllers[index],
        focusNode: viewModel.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => viewModel.onOtpChanged(value, index),
        onTap: () => viewModel.onFieldTapped(index),
      ),
    );
  }
}
