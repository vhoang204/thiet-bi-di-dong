import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_sizes.dart';

class Gd04Settings extends StatefulWidget {
  const Gd04Settings({super.key});

  @override
  State<Gd04Settings> createState() => _Gd04SettingsState();
}

class _Gd04SettingsState extends State<Gd04Settings> {
  bool _pushNotification = true;
  bool _emailPromo = false;
  bool _darkMode = false;
  String _selectedLanguage = 'Tiếng Việt';

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Chọn ngôn ngữ'),
        children: ['Tiếng Việt', 'English'].map((lang) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() => _selectedLanguage = lang);
              Navigator.pop(ctx);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lang, style: const TextStyle(fontSize: 15)),
                if (_selectedLanguage == lang)
                  const Icon(Icons.check, color: AppColors.primary, size: 20),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('TÀI KHOẢN'),
          _buildCardContainer([
            ListTile(
              leading: const Icon(
                Icons.person_outline,
                color: AppColors.primary,
              ),
              title: const Text('Thông tin cá nhân'),
              subtitle: const Text('Cập nhật họ tên, số điện thoại, địa chỉ'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(height: 1, indent: 56),
            ListTile(
              leading: const Icon(Icons.lock_outline, color: AppColors.primary),
              title: const Text('Đổi mật khẩu'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ]),
          _buildSectionHeader('THÔNG BÁO & HIỂN THỊ'),
          _buildCardContainer([
            SwitchListTile(
              secondary: const Icon(
                Icons.notifications_outlined,
                color: AppColors.primary,
              ),
              title: const Text('Thông báo đẩy'),
              subtitle: const Text('Nhận cập nhật trạng thái đơn hàng'),
              value: _pushNotification,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _pushNotification = val),
            ),
            const Divider(height: 1, indent: 56),
            SwitchListTile(
              secondary: const Icon(
                Icons.local_offer_outlined,
                color: AppColors.primary,
              ),
              title: const Text('Email khuyến mãi'),
              subtitle: const Text('Nhận mã giảm giá và ưu đãi mới'),
              value: _emailPromo,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _emailPromo = val),
            ),
            const Divider(height: 1, indent: 56),
            SwitchListTile(
              secondary: const Icon(
                Icons.dark_mode_outlined,
                color: AppColors.primary,
              ),
              title: const Text('Chế độ tối (Dark Mode)'),
              value: _darkMode,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _darkMode = val),
            ),
            const Divider(height: 1, indent: 56),
            ListTile(
              leading: const Icon(
                Icons.language_outlined,
                color: AppColors.primary,
              ),
              title: const Text('Ngôn ngữ'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedLanguage,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: _showLanguageDialog,
            ),
          ]),
          _buildSectionHeader('HỖ TRỢ & THÔNG TIN'),
          _buildCardContainer([
            ListTile(
              leading: const Icon(Icons.help_outline, color: AppColors.primary),
              title: const Text('Trung tâm trợ giúp'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(height: 1, indent: 56),
            const ListTile(
              leading: Icon(Icons.info_outline, color: AppColors.primary),
              title: Text('Phiên bản ứng dụng'),
              trailing: Text(
                '1.0.0',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(AppSizes.p24),
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã đăng xuất khỏi tài khoản')),
                );
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text(
                'Đăng xuất',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.p8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.p16,
        AppSizes.p24,
        AppSizes.p16,
        AppSizes.p8,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.p12),
        border: Border.all(color: AppColors.border, width: 0.6),
      ),
      child: Column(children: children),
    );
  }
}
