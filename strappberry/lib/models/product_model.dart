class Product {
  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final int categoryId;
  final int sellerId;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.sellerId,
  });
}

class NewProduct {
  final int? id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final int categoryId;
  final int sellerId;

  NewProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.sellerId,
  });
}