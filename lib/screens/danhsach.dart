import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_sizes.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'chitietsanpham.dart';
import 'giohang.dart';

class Gd06ProductList extends StatefulWidget {
  const Gd06ProductList({super.key});

  @override
  State<Gd06ProductList> createState() => _Gd06ProductListState();
}

class _Gd06ProductListState extends State<Gd06ProductList> {
  final List<String> _categories = [
    'Tất cả',
    'Điện thoại',
    'Laptop',
    'Phụ kiện',
  ];
  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';
  int _navIndex = 0;
  int _cartCount = 3;

  List<Product> get _filteredProducts {
    return MockData.products.where((product) {
      final matchesCategory =
          _selectedCategory == 'Tất cả' ||
          product.category == _selectedCategory;
      final matchesSearch = product.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        title: const Text(
          'ShopEasy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Gd08Cart()),
            ),
            icon: Badge(
              label: Text('$_cartCount'),
              backgroundColor: AppColors.accentOrange,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          const SizedBox(width: AppSizes.p8),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryChips(),
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(child: Text('Không tìm thấy sản phẩm phù hợp'))
                : GridView.builder(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isLandscape ? 3 : 2,
                      mainAxisSpacing: AppSizes.p12,
                      crossAxisSpacing: AppSizes.p12,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Gd07ProductDetail(product: product),
                          ),
                        ),
                        onAddToCart: () {
                          setState(() => _cartCount++);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Đã thêm "${product.name}" vào giỏ',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (index) => setState(() => _navIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Yêu thích',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.p16,
        AppSizes.p16,
        AppSizes.p16,
        AppSizes.p8,
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Tìm sản phẩm...',
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: Row(
        children: _categories.map((category) {
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.p8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              showCheckmark: false,
              selectedColor: AppColors.primary,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              onSelected: (_) => setState(() => _selectedCategory = category),
            ),
          );
        }).toList(),
      ),
    );
  }
}
