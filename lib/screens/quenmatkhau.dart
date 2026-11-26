import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_sizes.dart';

class GdForgotPassword extends StatefulWidget {
  const GdForgotPassword({super.key});

  @override
  State<GdForgotPassword> createState() => _GdForgotPasswordState();
}

class _GdForgotPasswordState extends State<GdForgotPassword> {
  final _emailController = TextEditingController();
  bool _isSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ Email của bạn')),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _isSent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.p16),
              Center(
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    size: 44,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p24),
              const Text(
                'Khôi phục mật khẩu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.p8),
              const Text(
                'Nhập địa chỉ email đã đăng ký, chúng tôi sẽ gửi hướng dẫn đặt lại mật khẩu cho bạn.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.p32),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Nhập email của bạn',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.grey,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.p8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.p8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _sendResetLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.p8),
                    ),
                  ),
                  child: const Text(
                    'Gửi yêu cầu đặt lại mật khẩu',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (_isSent) ...[
                const SizedBox(height: AppSizes.p24),
                Container(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(AppSizes.p8),
                    border: Border.all(color: const Color(0xFF10B981)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF059669)),
                      const SizedBox(width: AppSizes.p12),
                      Expanded(
                        child: Text(
                          'Đã gửi liên kết khôi phục đến ${_emailController.text}. Vui lòng kiểm tra hộp thư!',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF065F46),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
