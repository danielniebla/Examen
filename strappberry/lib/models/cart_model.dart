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
