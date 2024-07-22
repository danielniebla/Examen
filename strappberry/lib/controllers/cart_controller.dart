import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';
import 'product_controller.dart';
import '../models/product_model.dart';

class CartController {
  final ProductController _productController;
  static const cartKey = 'cart_key';
  CartController(this._productController);

  Future<List<CartItem>> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getStringList(cartKey);
    if (cartString == null || cartString.isEmpty) {
      // Devuelve datos iniciales si no hay datos en SharedPreferences
      return [
        CartItem(id: 1, userId: 2, productId: 1, quantity: 4),
        CartItem(id: 2, userId: 2, productId: 2, quantity: 2),
      ];
    }
    return cartString.map((cartString) {
      final data = cartString.split(',');
      return CartItem(
        id: int.parse(data[0]),
        userId: int.parse(data[1]),
        productId: int.parse(data[2]),
        quantity: int.parse(data[3]),
      );
    }).toList();
  }

  Future<void> _saveCartItems(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = cartItems.map((cartItem) {
      return '${cartItem.id},${cartItem.userId},${cartItem.productId},${cartItem.quantity}';
    }).toList();
    prefs.setStringList(cartKey, cartString);
  }

 Future<void> addToCart(NewCartItem newCartItem) async {
    final currentCartItems = await _loadCartItems();
    // Generar un nuevo ID para el nuevo cartItem
    final newId = (currentCartItems.isNotEmpty) ? currentCartItems.last.id + 1 : 1;
    
    final cartItem = CartItem(
      id: newId,
      userId: newCartItem.userId,
      productId: newCartItem.productId,
      quantity: newCartItem.quantity,
    );
    
    currentCartItems.add(cartItem);
    await _saveCartItems(currentCartItems);
  }


  Future<void> removeFromCart(String cartItemId) async {
    final currentCartItems = await _loadCartItems();
    currentCartItems.removeWhere((item) => item.id == int.parse(cartItemId));
    await _saveCartItems(currentCartItems);
  }

  Future<List<CartProduct>> getCartItemsByUserId(String userId, ProductController productController) async {
    final currentCartItems = await _loadCartItems();
    final productsUsers = currentCartItems.where((item) => item.userId == int.parse(userId)).toList();

    List<CartProduct> cartProducts = [];
    
    for (var cartItem in productsUsers) {
      // Obtener detalles del producto
      final product = await productController.getProductById(cartItem.productId);
      
      if (product.isNotEmpty) {
        final productDetails = product.first; // Asumiendo que getProductById devuelve una lista
        
        // Crear un objeto CartProduct
        final cartProduct = CartProduct(
          id: productDetails.id,
          name: productDetails.name,
          imageUrl: productDetails.imageUrl,
          price: productDetails.price,
          description: productDetails.description,
          categoryId: productDetails.categoryId,
          sellerId: productDetails.sellerId,
          quantity: cartItem.quantity, // Usar la cantidad del cartItem
        );
        
        cartProducts.add(cartProduct);
      }
    }
    
    return cartProducts;
  }
  Future<void> updateQuantity(int productId, int delta) async {
    final currentCartItems = await _loadCartItems();
    final index = currentCartItems.indexWhere((item) => item.productId == productId);

    if (index != -1) {
      // Actualizar cantidad del producto en el carrito
      final cartItem = currentCartItems[index];
      final newQuantity = cartItem.quantity + delta;
      if (newQuantity > 0) {
        currentCartItems[index] = CartItem(
          id: cartItem.id,
          userId: cartItem.userId,
          productId: cartItem.productId,
          quantity: newQuantity,
        );
      } else {
        // Eliminar el ítem si la cantidad es 0 o menor
        currentCartItems.removeAt(index);
      }
      await _saveCartItems(currentCartItems);
    }
  }
}
