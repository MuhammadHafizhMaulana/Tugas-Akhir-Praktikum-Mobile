class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int ratingCount;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? 'No description',
      category: json['category'] ?? 'Unknown',
      imageUrl: json['image'] ?? '',
      rating: (json['rating'] != null && json['rating']['rate'] != null)
          ? (json['rating']['rate'] as num).toDouble()
          : 0.0,
      ratingCount: (json['rating'] != null && json['rating']['count'] != null)
          ? json['rating']['count']
          : 0,
    );
  }
}
