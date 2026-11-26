import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_sizes.dart';
import '../models/product.dart';

class _CartItem {
  final Product product;
  int quantity;
  _CartItem({required this.product, required this.quantity});
}

class Gd08Cart extends StatefulWidget {
  const Gd08Cart({super.key});

  @override
  State<Gd08Cart> createState() => _Gd08CartState();
}

class _Gd08CartState extends State<Gd08Cart> {
  // Dữ liệu mẫu tạm thời theo đúng cấu trúc Product mới (giá USD dạng double)
  final List<_CartItem> _items = [
    _CartItem(
      product: Product(
        id: 1,
        title: 'Essence Mascara Lash Princess',
        description: 'Mascara làm dài và dày mi',
        category: 'beauty',
        thumbnail:
            'https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png',
        images: [],
        price: 9.99,
        discountPercentage: 10.48,
        rating: 2.56,
      ),
      quantity: 1,
    ),
    _CartItem(
      product: Product(
        id: 2,
        title: 'Eyeshadow Palette with Mirror',
        description: 'Bảng phấn mắt kèm gương tiện lợi',
        category: 'beauty',
        thumbnail:
            'https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png',
        images: [],
        price: 19.99,
        discountPercentage: 18.19,
        rating: 2.86,
      ),
      quantity: 2,
    ),
  ];

  double get _subtotal => _items.fold(
    0.0,
    (sum, item) => sum + item.product.finalPrice * item.quantity,
  );

  double get _shippingFee => _items.isEmpty ? 0.0 : 5.0;

  double get _total => _subtotal + _shippingFee;

  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQty = _items[index].quantity + delta;
      if (newQty <= 0) {
        _removeItemWithUndo(index);
      } else {
        _items[index].quantity = newQty;
      }
    });
  }

  void _removeItemWithUndo(int index) {
    final removedItem = _items[index];
    setState(() {
      _items.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${removedItem.product.title}"'),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {
            setState(() {
              _items.insert(index, removedItem);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Giỏ hàng (${_items.length})'),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: _items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: AppSizes.p12),
                  Text(
                    'Giỏ hàng của bạn đang trống',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSizes.p12),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Container(
                        padding: const EdgeInsets.all(AppSizes.p12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppSizes.p12),
                          border: Border.all(
                            color: AppColors.border,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppSizes.p8),
                              child: Container(
                                width: 72,
                                height: 72,
                                color: AppColors.background,
                                child: Image.network(
                                  item.product.thumbnail,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSizes.p12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.p4),
                                  Text(
                                    '\$${item.product.finalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: AppColors.textSecondary,
                                  onPressed: () => _updateQuantity(index, -1),
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: AppColors.primary,
                                  onPressed: () => _updateQuantity(index, 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Khung tính tiền & Thanh toán
                Container(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSummaryRow(
                          'Tạm tính',
                          '\$${_subtotal.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: AppSizes.p8),
                        _buildSummaryRow(
                          'Phí vận chuyển',
                          '\$${_shippingFee.toStringAsFixed(2)}',
                        ),
                        const Divider(height: 24),
                        _buildSummaryRow(
                          'Tổng cộng',
                          '\$${_total.toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                        const SizedBox(height: AppSizes.p16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đặt hàng thành công!'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.p8,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Thanh toán',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.deepOrange : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
