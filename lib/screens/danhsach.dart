import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/app_sizes.dart';
import '../providers/product_notifier.dart';
import '../widgets/product_card.dart';
import 'chitietsanpham.dart';
import 'giohang.dart';

class Gd06ProductList extends StatefulWidget {
  const Gd06ProductList({super.key});

  @override
  State<Gd06ProductList> createState() => _Gd06ProductListState();
}

class _Gd06ProductListState extends State<Gd06ProductList> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ProductNotifier>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Danh sách sản phẩm'),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Gd08Cart()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(
              AppSizes.p16,
              AppSizes.p12,
              AppSizes.p16,
              AppSizes.p8,
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (text) =>
                  context.read<ProductNotifier>().search(text),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm (ví dụ: phone, watch)...',
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          context.read<ProductNotifier>().loadProducts();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.p8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // Hàng chip lọc danh mục
          if (notifier.categories.isNotEmpty)
            Container(
              color: Colors.white,
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                scrollDirection: Axis.horizontal,
                itemCount: notifier.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSizes.p8),
                itemBuilder: (context, index) {
                  final cat = notifier.categories[index];
                  final isSelected = notifier.selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    onSelected: (_) =>
                        context.read<ProductNotifier>().selectCategory(cat),
                  );
                },
              ),
            ),

          // Phần thân hiển thị 3 trạng thái
          Expanded(child: _buildBody(context, notifier)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductNotifier notifier) {
    // 1. Đang tải
    if (notifier.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Có lỗi
    if (notifier.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: AppColors.grey,
              ),
              const SizedBox(height: AppSizes.p12),
              Text(
                notifier.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSizes.p16),
              FilledButton(
                onPressed: () => context.read<ProductNotifier>().initData(),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Danh sách rỗng
    if (notifier.products.isEmpty) {
      return const Center(
        child: Text(
          'Không tìm thấy sản phẩm',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
      );
    }

    // 4. Có dữ liệu -> Hiển thị lưới kèm kéo để làm mới
    return RefreshIndicator(
      onRefresh: () => context.read<ProductNotifier>().loadProducts(),
      child: GridView.builder(
        padding: const EdgeInsets.all(AppSizes.p16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: AppSizes.p12,
          mainAxisSpacing: AppSizes.p12,
        ),
        itemCount: notifier.products.length,
        itemBuilder: (context, i) {
          final product = notifier.products[i];
          return ProductCard(
            product: product,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Gd07ProductDetail(productId: product.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
