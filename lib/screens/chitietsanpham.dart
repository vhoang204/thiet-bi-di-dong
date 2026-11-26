import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_sizes.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class Gd07ProductDetail extends StatefulWidget {
  final int productId;
  const Gd07ProductDetail({super.key, required this.productId});

  @override
  State<Gd07ProductDetail> createState() => _Gd07ProductDetailState();
}

class _Gd07ProductDetailState extends State<Gd07ProductDetail> {
  Product? product;
  bool isLoading = true;
  String? error;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final p = await ApiService.getProduct(widget.productId);
      if (!mounted) return;
      setState(() {
        product = p;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = errorMessage(e);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.p16),
              FilledButton(
                onPressed: _loadProduct,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final item = product!;
    final displayImages = item.images.isNotEmpty
        ? item.images
        : [item.thumbnail];

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh lớn
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSizes.p12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.p12),
                    child: Image.network(
                      displayImages[_selectedImageIndex],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),
                // Dải ảnh thu nhỏ nếu có nhiều ảnh
                if (displayImages.length > 1) ...[
                  const SizedBox(height: AppSizes.p12),
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: displayImages.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSizes.p8),
                      itemBuilder: (context, idx) {
                        final isSelected = idx == _selectedImageIndex;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedImageIndex = idx),
                          child: Container(
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSizes.p8),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Image.network(
                              displayImages[idx],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.p16),
                // Danh mục & Đánh giá
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text(item.category.toUpperCase()),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      labelStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          item.rating.toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.p8),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.p12),
                // Giá sau giảm & Giá gốc
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${item.finalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(width: AppSizes.p12),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: AppSizes.p8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${item.discountPercentage.round()}%',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                const Text(
                  'Mô tả sản phẩm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.p8),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Thanh nút dưới cùng
        Container(
          padding: const EdgeInsets.all(AppSizes.p16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã thêm "${item.title}" vào giỏ hàng'),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text(
                'Thêm vào giỏ hàng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.p8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
