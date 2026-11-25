class Product {
  final String id;
  final String name;
  final String category;
  final int price;
  final int originalPrice;
  final int discountPercent;
  final double rating;
  final String reviewCount;
  final String description;
  final List<String> imageUrls;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageUrls,
  });
}

class MockData {
  static const List<Product> products = [
    Product(
      id: 'p1',
      name: 'iPhone 16 Pro Max 256GB Chính Hãng VN/A',
      category: 'Điện thoại',
      price: 21990000,
      originalPrice: 28990000,
      discountPercent: 25,
      rating: 4.8,
      reviewCount: '1.2k',
      description:
          'Thiết kế khung viền Titan siêu bền nhẹ, chip A18 Pro hiệu năng vượt trội, hệ thống camera chuyên nghiệp 48MP quay video 4K 120fps Dolby Vision. Thời lượng pin ấn tượng sử dụng suốt cả ngày dài.',
      imageUrls: [
        'https://picsum.photos/seed/iphone1/400/400',
        'https://picsum.photos/seed/iphone2/400/400',
        'https://picsum.photos/seed/iphone3/400/400',
      ],
    ),
    Product(
      id: 'p2',
      name: 'MacBook Air M3 13 inch 16GB/512GB',
      category: 'Laptop',
      price: 26490000,
      originalPrice: 31990000,
      discountPercent: 17,
      rating: 4.9,
      reviewCount: '850',
      description:
          'Siêu mỏng nhẹ chỉ 1.24kg với chip Apple M3 mạnh mẽ, màn hình Liquid Retina sắc nét, thời lượng pin lên đến 18 giờ đáp ứng hoàn hảo nhu cầu học tập và làm việc.',
      imageUrls: [
        'https://picsum.photos/seed/mac1/400/400',
        'https://picsum.photos/seed/mac2/400/400',
      ],
    ),
    Product(
      id: 'p3',
      name: 'Samsung Galaxy S24 Ultra 5G 12GB/256GB',
      category: 'Điện thoại',
      price: 22990000,
      originalPrice: 29990000,
      discountPercent: 23,
      rating: 4.7,
      reviewCount: '940',
      description:
          'Tích hợp quyền năng Galaxy AI, bút S-Pen tiện lợi, camera mắt thần bóng đêm 200MP zoom quang học ấn tượng và màn hình chống chói Corning Gorilla Armor.',
      imageUrls: [
        'https://picsum.photos/seed/s24_1/400/400',
        'https://picsum.photos/seed/s24_2/400/400',
      ],
    ),
    Product(
      id: 'p4',
      name: 'Tai nghe chống ồn Sony WH-1000XM5',
      category: 'Phụ kiện',
      price: 6490000,
      originalPrice: 8490000,
      discountPercent: 24,
      rating: 4.8,
      reviewCount: '2.1k',
      description:
          'Công nghệ chống ồn hàng đầu với 8 micro và bộ xử lý kép, âm thanh Hi-Res Audio sống động, đệm tai da mềm mại đeo êm ái cả ngày.',
      imageUrls: ['https://picsum.photos/seed/sony1/400/400'],
    ),
  ];

  static String formatCurrency(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return '${buffer.toString()} ₫';
  }
}
