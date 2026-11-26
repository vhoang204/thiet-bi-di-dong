import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_sizes.dart';

class Gd02Register extends StatefulWidget {
  const Gd02Register({super.key});

  @override
  State<Gd02Register> createState() => _Gd02RegisterState();
}

class _Gd02RegisterState extends State<Gd02Register> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đồng ý với điều khoản sử dụng')),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đăng ký tài khoản thành công!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Đăng ký tài khoản'),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tạo tài khoản mới',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.p4),
              const Text(
                'Điền đầy đủ thông tin bên dưới để bắt đầu mua sắm',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSizes.p24),
              _buildTextField(
                controller: _nameController,
                hint: 'Họ và tên',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: AppSizes.p16),
              _buildTextField(
                controller: _emailController,
                hint: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSizes.p16),
              _buildTextField(
                controller: _phoneController,
                hint: 'Số điện thoại',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSizes.p16),
              _buildPasswordField(
                controller: _passwordController,
                hint: 'Mật khẩu',
                obscure: _obscurePass,
                onToggle: () => setState(() => _obscurePass = !_obscurePass),
              ),
              const SizedBox(height: AppSizes.p16),
              _buildPasswordField(
                controller: _confirmPasswordController,
                hint: 'Xác nhận mật khẩu',
                obscure: _obscureConfirm,
                onToggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              const SizedBox(height: AppSizes.p12),
              Row(
                children: [
                  Checkbox(
                    value: _agreeTerms,
                    activeColor: AppColors.primary,
                    onChanged: (val) =>
                        setState(() => _agreeTerms = val ?? false),
                  ),
                  const Expanded(
                    child: Text(
                      'Tôi đồng ý với Điều khoản dịch vụ & Chính sách bảo mật',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.p24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.p8),
                    ),
                  ),
                  child: const Text(
                    'Đăng ký',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Đã có tài khoản?',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.grey),
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
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.textSecondary,
          ),
          onPressed: onToggle,
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
    );
  }
}
