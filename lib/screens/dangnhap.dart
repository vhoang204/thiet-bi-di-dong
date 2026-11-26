import 'dangky.dart';
import 'quenmatkhau.dart';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_sizes.dart';

class Gd01Login extends StatefulWidget {
  const Gd01Login({super.key});

  @override
  State<Gd01Login> createState() => _Gd01LoginState();
}

class _Gd01LoginState extends State<Gd01Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đăng nhập thành công!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p24,
              vertical: AppSizes.p8,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppSizes.p32),
                  _buildEmailField(),
                  const SizedBox(height: AppSizes.p16),
                  _buildPasswordField(),
                  _buildForgotPasswordButton(),
                  const SizedBox(height: AppSizes.p8),
                  _buildLoginButton(),
                  const SizedBox(height: AppSizes.p24),
                  _buildDividerWithText(),
                  const SizedBox(height: AppSizes.p24),
                  _buildGoogleButton(),
                  const SizedBox(height: AppSizes.p24),
                  _buildRegisterPrompt(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_bag_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppSizes.p16),
        const Text(
          'ShopEasy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.p4),
        const Text(
          'Mua sắm tiện lợi, ưu đãi mỗi ngày',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Email',
        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.grey),
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

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _handleLogin(),
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
        filled: true,
        fillColor: AppColors.background,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textSecondary,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
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

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GdForgotPassword()),
        ),
        child: const Text(
          'Quên mật khẩu?',
          style: TextStyle(fontSize: 13, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.p8),
          ),
        ),
        child: const Text(
          'Đăng nhập',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildDividerWithText() {
    return const Row(
      children: [
        Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.p12),
          child: Text('hoặc', style: TextStyle(color: AppColors.textSecondary)),
        ),
        Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(
          Icons.g_mobiledata_rounded,
          size: 28,
          color: AppColors.primary,
        ),
        label: const Text(
          'Tiếp tục với Google',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.p8),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Chưa có tài khoản?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Gd02Register()),
          ),
          child: const Text(
            'Đăng ký ngay',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
