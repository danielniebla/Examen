import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../controllers/users_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../models/users_model.dart';
import '../../models/cart_model.dart';

class CartPage extends StatefulWidget {
  final UsersController usersController;
  final ProductController productController;
  final CartController cartController;

  const CartPage({
    Key? key,
    required this.usersController,
    required this.productController,
    required this.cartController,
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<List<CartProduct>>? _cartProductsFuture;
  Map<int, int> productQuantities = {};

  @override
  void initState() {
    super.initState();
    _initializeCart();
  }

  Future<void> _initializeCart() async {
    final user = await widget.usersController.getCurrentUser();
    if (user != null) {
      setState(() {
        _cartProductsFuture = widget.cartController.getCartItemsByUserId(user.id.toString(), widget.productController);
      });
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _updateQuantity(CartProduct product, int delta) async {
    if (delta == 0) return;

    // Actualizar la cantidad en el controlador
    await widget.cartController.updateQuantity(product.id, delta);

    // Recargar los datos del carrito
    final user = await widget.usersController.getCurrentUser();
    if (user != null) {
      setState(() {
        _cartProductsFuture = widget.cartController.getCartItemsByUserId(user.id.toString(), widget.productController);
      });
    }

    // Actualizar el estado local
    setState(() {
      productQuantities[product.id] = (productQuantities[product.id] ?? product.quantity) + delta;
      if (productQuantities[product.id]! <= 0) {
        productQuantities.remove(product.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi carrito',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<CartProduct>>(
                future: _cartProductsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final cartProducts = snapshot.data!;
                    double total = cartProducts.fold(0, (sum, product) {
                      final quantity = productQuantities[product.id] ?? product.quantity;
                      return sum + (product.price * quantity);
                    });
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartProducts.length,
                            itemBuilder: (context, index) {
                              final product = cartProducts[index];
                              final quantity = productQuantities[product.id] ?? product.quantity;
                              return Card(
                                color: AppColors.secondaryColor,
                                child: Row(
                                  children: [
                                    // Product Image
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        product.imageUrl,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Product Details
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '\$${product.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            SizedBox(height: 8.0),
                                            // Quantity Control
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.remove, color: AppColors.iconsColor),
                                                  onPressed: () {
                                                    _updateQuantity(product, -1);
                                                  },
                                                ),
                                                Text(
                                                  quantity.toString(),
                                                  style: TextStyle(color: AppColors.primaryColor),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.add, color: AppColors.iconsColor),
                                                  onPressed: () {
                                                    _updateQuantity(product, 1);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(color: AppColors.shadowColor),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: TextStyle(color: AppColors.primaryColor, fontSize: 20),
                              ),
                              Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: TextStyle(color: AppColors.primaryColor, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle checkout logic
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.primaryColor,
                            onPrimary: Colors.white,
                          ),
                          child: Text('Comprar ahora'),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text('No products found in cart.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
