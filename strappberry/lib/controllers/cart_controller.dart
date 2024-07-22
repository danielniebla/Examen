import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';

class CartController {
  static const cartKey = 'cart_key';

  Future<List<CartItem>> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getStringList(cartKey);
    if (cartString == null || cartString.isEmpty) {
      return [];
    }
    return cartString.map((cartString) {
      final data = cartString.split(',');
      return CartItem(
        id: int.parse(data[0]),
        userId: int.parse(data[1]),
        productId: int.parse(data[2]) ,
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

  Future<void> addToCart(CartItem cartItem) async {
    final currentCartItems = await _loadCartItems();
    currentCartItems.add(cartItem);
    await _saveCartItems(currentCartItems);
  }

  Future<void> removeFromCart(String cartItemId) async {
    final currentCartItems = await _loadCartItems();
    currentCartItems.removeWhere((item) => item.id == int.parse(cartItemId));
    await _saveCartItems(currentCartItems);
  }

  Future<List<CartItem>> getCartItemsByUserId(String userId) async {
    final currentCartItems = await _loadCartItems();
    return currentCartItems.where((item) => item.userId == int.parse(userId)).toList();
  }
}
