import 'package:shared_preferences/shared_preferences.dart';
import '../models/liked_products_models.dart';
import 'product_controller.dart';
import '../models/product_model.dart';

class LikedProductsController {
  final ProductController _productController;
  static const likedProductsKey = 'liked_products_key';
  
  LikedProductsController(this._productController);

  Future<List<Likedproduct>> _loadLikedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final likedProductsString = prefs.getStringList(likedProductsKey);

    if (likedProductsString == null || likedProductsString.isEmpty) {
            return [
              Likedproduct(id: 1, userId: 2, productId: 1),
              Likedproduct(id: 2, userId: 2, productId: 2),
            ];
    }

    return likedProductsString.map((idString) {
      final data = idString.split(',');
      return Likedproduct(
        id: int.parse(data[0]),
        userId: int.parse(data[1]),
        productId: int.parse(data[2]),
      );
    }).toList();
  }

  Future<void> _saveLikedProducts(List<Likedproduct> likedProducts) async {
    final prefs = await SharedPreferences.getInstance();
    final likedProductsString = likedProducts.map((likedProduct) {
      return '${likedProduct.id},${likedProduct.userId},${likedProduct.productId}';
    }).toList();
    prefs.setStringList(likedProductsKey, likedProductsString);
  }

  Future<void> addToLikedProducts(NewLikedProduct newLikedProduct) async {
    final currentLikedProducts = await _loadLikedProducts();
    final likedProduct = Likedproduct(
      id: newLikedProduct.id ?? (currentLikedProducts.isNotEmpty ? currentLikedProducts.last.id + 1 : 1),
      userId: newLikedProduct.userId,
      productId: newLikedProduct.productId,
    );

    if (!currentLikedProducts.any((p) => p.productId == likedProduct.productId)) {
      currentLikedProducts.add(likedProduct);
      await _saveLikedProducts(currentLikedProducts);
    }
  }

  Future<void> removeFromLikedProducts(int productId) async {
    final currentLikedProducts = await _loadLikedProducts();
    currentLikedProducts.removeWhere((likedProduct) => likedProduct.productId == productId);
    await _saveLikedProducts(currentLikedProducts);
  }

  Future<List<Likeds>> getLikedProductsByUserId(int userId) async {
    final currentLikedProducts = await _loadLikedProducts();
    final productsUsers = currentLikedProducts.where((item) => item.userId == userId).toList();

    
    List<Likeds> likedProducts = [];
    
    for (var likedProduct in productsUsers) {
      final product = await _productController.getProductById(likedProduct.productId);
      
      final likedProductDetail = Likeds(
        id: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        price: product.price,
        description: product.description,
        categoryId: product.categoryId,
        sellerId: product.sellerId,
      );
      
      likedProducts.add(likedProductDetail);
    }
    
    return likedProducts;
  }
}
