class Product {
  final int id;
  final String title;
  final double price;
  final double discountPercentage;
  final String thumbnail;
  final int quantity;
  final String brand;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.discountPercentage,
    required this.thumbnail,
    required this.brand,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      discountPercentage: json['discountPercentage'].toDouble(),
      thumbnail: json['thumbnail'],
      brand: json['brand'] ?? 'Unknown',
    );
  }

  double get finalPrice => price - (price * discountPercentage / 100);
}