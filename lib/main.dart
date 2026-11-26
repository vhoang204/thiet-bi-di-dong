import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'core/app_sizes.dart';
import 'screens/dangnhap.dart';
import 'screens/dangky.dart';
import 'screens/quenmatkhau.dart';
import 'screens/caidat.dart';
import 'screens/danhsach.dart';
import 'screens/chitietsanpham.dart';
import 'screens/giohang.dart';

void main() => runApp(const ShopEasyApp());

class ShopEasyApp extends StatelessWidget {
  const ShopEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEasy UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeMenu(),
    );
  }
}

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = [
      {
        'code': 'GD 1',
        'title': 'Màn hình Đăng nhập',
        'minutes': 30,
        'screen': const Gd01Login(),
      },
      {
        'code': 'GD 2',
        'title': 'Màn hình Đăng ký',
        'minutes': 30,
        'screen': const Gd02Register(),
      },
      {
        'code': 'GD 3',
        'title': 'Màn hình Quên mật khẩu',
        'minutes': 20,
        'screen': const GdForgotPassword(),
      },
      {
        'code': 'GD 4',
        'title': 'Màn hình Cài đặt',
        'minutes': 25,
        'screen': const Gd04Settings(),
      },
      {
        'code': 'GD 6',
        'title': 'Danh sách sản phẩm',
        'minutes': 40,
        'screen': const Gd06ProductList(),
      },
      {
        'code': 'GD 7',
        'title': 'Chi tiết sản phẩm',
        'minutes': 45,
        'screen': const Gd07ProductDetail(),
      },
      {
        'code': 'GD 8',
        'title': 'Màn hình Giỏ hàng',
        'minutes': 45,
        'screen': const Gd08Cart(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thực hành Giao diện Flutter'),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.p16),
        itemCount: lessons.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = lessons[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                (item['code'] as String).replaceAll('GD ', ''),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text('${item['code']} · ${item['title']}'),
            subtitle: Text('${item['minutes']} phút'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => item['screen'] as Widget),
            ),
          );
        },
      ),
    );
  }
}
