import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_sizes.dart';
import '../models/product.dart';

class Gd07ProductDetail extends StatefulWidget {
  final Product? product;

  const Gd07ProductDetail({super.key, this.product});

  @override
  State<Gd07ProductDetail> createState() => _Gd07ProductDetailState();
}

class _Gd07ProductDetailState extends State<Gd07ProductDetail> {
  late final Product _product;
  int _currentPage = 0;
  bool _isFavorite = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _product = widget.product ?? MockData.products.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.p8),
                  _buildRatingRow(),
                  const SizedBox(height: AppSizes.p16),
                  _buildPriceRow(),
                  const Divider(height: AppSizes.p32, color: AppColors.border),
                  const Text(
                    'Mô tả',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.p8),
                  Text(
                    _product.description,
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(
                      _isExpanded ? 'Thu gọn' : 'Xem thêm',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.navy,
      leading: Padding(
        padding: const EdgeInsets.all(AppSizes.p8),
        child: CircleAvatar(
          backgroundColor: Colors.white.withValues(alpha: 0.85),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(AppSizes.p8),
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.85),
            child: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? AppColors.error : AppColors.textPrimary,
                size: 20,
              ),
              onPressed: () => setState(() => _isFavorite = !_isFavorite),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              itemCount: _product.imageUrls.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (_, index) => Image.network(
                _product.imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFE2E8F0),
                  child: const Icon(
                    Icons.image,
                    size: 64,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: AppSizes.p12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _product.imageUrls.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 10 : 8,
                    height: _currentPage == index ? 10 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(
          5,
          (_) => const Icon(Icons.star, size: 18, color: AppColors.star),
        ),
        const SizedBox(width: AppSizes.p8),
        Text(
          '${_product.rating} · ${_product.reviewCount} đánh giá',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Row(
      children: [
        Text(
          MockData.formatCurrency(_product.price),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: AppSizes.p12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accentOrange,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '-${_product.discountPercent}%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã thêm sản phẩm vào giỏ hàng'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.p8),
                    ),
                  ),
                  child: const Text(
                    'Thêm vào giỏ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.p12),
            Expanded(
              child: SizedBox(
                height: 46,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.p8),
                    ),
                  ),
                  child: const Text(
                    'Mua ngay',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
