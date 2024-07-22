class CartItem {
  final int id;
  final int userId;
  final int productId;
  final int quantity;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
  });
}
class CartProduct{
  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final int categoryId;
  final int sellerId;
  final int quantity;


  CartProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.sellerId,
    required this.quantity,

  });
}

class NewCartItem {
  final int? id;
  final int userId;
  final int productId;
  final int quantity;

  NewCartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
  });
}
