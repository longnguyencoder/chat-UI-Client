import 'package:flutter/material.dart';
import 'package:mobilev2/viewmodels/auth/verify_otp_viewmodel.dart';
import 'package:provider/provider.dart';

class VerifyOtpView extends StatefulWidget {
  const VerifyOtpView({super.key});

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView>{
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  // Tạo ViewModel instance duy nhất
  late final VerifyOtpViewModel viewModel;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Tạo ViewModel trong initState
    viewModel = VerifyOtpViewModel();
    // print('🏗️ ViewModel created: ${viewModel.hashCode}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      // Lấy email từ arguments
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final email = arguments?['email'] as String?;

      // print('🔍 Arguments nhận được: $arguments');
      // print('📧 Email từ arguments: $email');
      // print('🏗️ Using ViewModel: ${viewModel.hashCode}');

      if (email != null && email.isNotEmpty) {
        viewModel.setEmail(email);
        // print('✅ Đã set email vào ViewModel: $email');
      } else {
        // print('❌ Không nhận được email từ arguments');
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    viewModel.dispose(); // Dispose ViewModel
    super.dispose();
  }

  void _onChanged(int index, String value) {
    // print('🔢 OTP input changed - Index: $index, Value: $value');

    if (value.isNotEmpty && RegExp(r'^\d$').hasMatch(value)) {
      controllers[index].text = value;

      // Chuyển focus sang ô tiếp theo
      if (index < 5) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      // Quay lại ô trước khi xóa
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }

    // Cập nhật OTP trong ViewModel - sử dụng instance duy nhất
    _updateOtpCode();
  }

  void _updateOtpCode() {
    final otpCode = controllers.map((controller) => controller.text).join();
    //print('🔐 _updateOtpCode called');
    //print('🔐 OTP Code từ controllers: "$otpCode" (length: ${otpCode.length})');
    //print('🏗️ Calling updateOtpCode on ViewModel: ${viewModel.hashCode}');

    // Sử dụng viewModel instance duy nhất
    viewModel.updateOtpCode(otpCode);

    print('🔐 _updateOtpCode completed');
  }

  @override
  Widget build(BuildContext context) {
    // print('🏗️ Build called with ViewModel: ${viewModel.hashCode}');
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<VerifyOtpViewModel>(
        builder: (context, vm, child) {
          // print('🏗️ Consumer builder called with ViewModel: ${vm.hashCode}');
          // print('📊 Consumer - Email: "${vm.email}", OTP: "${vm.otpCode}", CanVerify: ${vm.canVerify}');
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'Xác minh tài khoản',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle với email
                    Text(
                      'Mã xác minh đã được gửi đến',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      vm.email.isNotEmpty ? vm.email : 'email@example.com',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 50,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: controllers[index].text.isNotEmpty
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            color: controllers[index].text.isNotEmpty
                                ? Colors.blue.shade50
                                : Colors.grey.shade50,
                          ),
                          child: TextField(
                            controller: controllers[index],
                            focusNode: focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) => _onChanged(index, value),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 10),

                    // Error Message
                    if (vm.errorMessage.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red.shade600, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                vm.errorMessage,
                                style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: vm.canVerify && !vm.isLoading
                            ? () async {
                          print('🚀 Bắt đầu verify OTP...');
                          print('📧 Email: ${vm.email}');
                          print('🔢 OTP: ${vm.otpCode}');

                          final success = await vm.verifyOtp();
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đăng ký thành công!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vm.canVerify && !vm.isLoading
                              ? Colors.blue
                              : Colors.grey.shade300,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: vm.isLoading
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
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Resend OTP
                    TextButton(
                      onPressed: vm.canResend ? () {
                        vm.resendOtp();
                      } : null,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                              text: 'Không nhận được mã? ',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            TextSpan(
                              text: vm.canResend
                                  ? 'Gửi lại'
                                  : 'Gửi lại sau ${vm.resendCountdown}s',
                              style: TextStyle(
                                color: vm.canResend ? Colors.blue : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
