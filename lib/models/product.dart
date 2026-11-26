class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final String thumbnail;
  final List<String> images;
  final double price;
  final double discountPercentage;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.images,
    required this.price,
    required this.discountPercentage,
    required this.rating,
  });

  // Giá thực tế sau khi trừ khuyến mãi
  double get finalPrice => price * (1 - discountPercentage / 100);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
