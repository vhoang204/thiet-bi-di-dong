import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_sizes.dart';
import '../models/product.dart';

class _CartItem {
  final Product product;
  int quantity;

  _CartItem({required this.product, this.quantity = 1});
}

class Gd08Cart extends StatefulWidget {
  const Gd08Cart({super.key});

  @override
  State<Gd08Cart> createState() => _Gd08CartState();
}

class _Gd08CartState extends State<Gd08Cart> {
  late List<_CartItem> _items;

  @override
  void initState() {
    super.initState();
    _items = MockData.products
        .take(3)
        .map((p) => _CartItem(product: p, quantity: 1))
        .toList();
  }

  int get _subtotal =>
      _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  int get _shippingFee => (_subtotal == 0 || _subtotal >= 500000) ? 0 : 30000;

  int get _total => _subtotal + _shippingFee;

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
        content: Text('Đã xóa "${removedItem.product.name}"'),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        title: Text('Giỏ hàng (${_items.length})'),
      ),
      body: _items.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: AppSizes.p24,
                      color: AppColors.border,
                    ),
                    itemBuilder: (context, index) => _buildCartRow(index),
                  ),
                ),
                _buildCheckoutPanel(),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.p16),
            const Text(
              'Giỏ hàng của bạn đang trống',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.p8),
            const Text(
              'Hãy khám phá thêm các sản phẩm công nghệ hấp dẫn và thêm vào giỏ nhé!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.p24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Tiếp tục mua sắm'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartRow(int index) {
    final item = _items[index];
    return Dismissible(
      key: ValueKey(item.product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _removeItemWithUndo(index),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSizes.p8),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.p8),
            child: Image.network(
              item.product.imageUrls.first,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: const Color(0xFFE2E8F0),
                child: const Icon(Icons.image, color: AppColors.grey),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppSizes.p8),
                Row(
                  children: [
                    Text(
                      MockData.formatCurrency(item.product.price),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    _buildQuantityStepper(index, item.quantity),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityStepper(int index, int quantity) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.remove, size: 16),
            onPressed: () => _updateQuantity(index, -1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '$quantity',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.add, size: 16),
            onPressed: () => _updateQuantity(index, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutPanel() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSizes.p12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    'Tạm tính',
                    MockData.formatCurrency(_subtotal),
                  ),
                  const SizedBox(height: AppSizes.p8),
                  _buildSummaryRow(
                    'Phí vận chuyển',
                    _shippingFee == 0
                        ? 'Miễn phí'
                        : MockData.formatCurrency(_shippingFee),
                  ),
                  const Divider(height: AppSizes.p24, color: AppColors.border),
                  _buildSummaryRow(
                    'Tổng cộng',
                    MockData.formatCurrency(_total),
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.p16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đặt hàng thành công!')),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.p8),
                  ),
                ),
                child: const Text(
                  'Thanh toán',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
