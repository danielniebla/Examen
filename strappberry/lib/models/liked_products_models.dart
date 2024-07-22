class Likedproduct {
  final int id;
  final int userId;
  final int productId;

  Likedproduct({
    required this.id,
    required this.userId,
    required this.productId,
  });
}

class NewLikedProduct {
  final int? id;
  final int userId;
  final int productId;

  NewLikedProduct({
    required this.id,
    required this.userId,
    required this.productId,
  });
}
class Likeds{
  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final int categoryId;
  final int sellerId;


  Likeds({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.sellerId,

  });
}