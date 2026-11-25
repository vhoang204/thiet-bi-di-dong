import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_sizes.dart';
import '../models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.p12),
        side: const BorderSide(color: AppColors.border, width: 0.6),
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageHeader(),
            Padding(
              padding: const EdgeInsets.all(AppSizes.p8 + 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.3,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.p4),
                  _buildRatingRow(),
                  const SizedBox(height: AppSizes.p8),
                  _buildPriceRow(),
                  const SizedBox(height: AppSizes.p8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: widget.onAddToCart ?? () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.p8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.p8),
                        ),
                      ),
                      child: const Text(
                        'Thêm vào giỏ',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1.35,
          child: Image.network(
            widget.product.imageUrls.first,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFE2E8F0),
              child: const Icon(Icons.image, size: 36, color: AppColors.grey),
            ),
          ),
        ),
        Positioned(
          top: AppSizes.p8,
          left: AppSizes.p8,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p8,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.accentOrange,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '-${widget.product.discountPercent}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          top: AppSizes.p8,
          right: AppSizes.p8,
          child: InkWell(
            onTap: () => setState(() => _isFavorite = !_isFavorite),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white.withValues(alpha: 0.9),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 16,
                color: _isFavorite ? AppColors.error : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(
          5,
          (_) => const Icon(Icons.star, size: 13, color: AppColors.star),
        ),
        const SizedBox(width: AppSizes.p4),
        Expanded(
          child: Text(
            '${widget.product.rating} (${widget.product.reviewCount})',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSizes.p4,
      children: [
        Text(
          MockData.formatCurrency(widget.product.price),
          style: const TextStyle(
            color: AppColors.accentOrange,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Text(
          MockData.formatCurrency(widget.product.originalPrice),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }
}
