import 'package:flutter/material.dart';
import '../../models/liked_products_models.dart';
import '../../utils/app_colors.dart';
import '../../controllers/users_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/likeds_controller.dart';
import '../../models/users_model.dart';

class LikedProductsPage extends StatefulWidget {
  final UsersController usersController;
  final ProductController productController;
  final LikedProductsController likedProductsController;

  const LikedProductsPage({
    Key? key,
    required this.usersController,
    required this.productController,
    required this.likedProductsController,
  }) : super(key: key);

  @override
  _LikedProductsPageState createState() => _LikedProductsPageState();
}

class _LikedProductsPageState extends State<LikedProductsPage> {
  Future<List<Likeds>>? _likedProductsFuture;

  @override
  void initState() {
    super.initState();
    _initializeLikedProducts();
  }

  Future<void> _initializeLikedProducts() async {
    final user = await widget.usersController.getCurrentUser();
    if (user != null) {
      setState(() {
        _likedProductsFuture = widget.likedProductsController.getLikedProductsByUserId(user.id);
      });
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Productos favoritos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white, 
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Likeds>>(
                future: _likedProductsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final likedProducts = snapshot.data!;
                    if (likedProducts.isEmpty) {
                      return Center(child: Text('No products found in favorites.'));
                    }
                    return ListView.builder(
                      itemCount: likedProducts.length,
                      itemBuilder: (context, index) {
                        final product = likedProducts[index];
                        return Card(
                          color: AppColors.secondaryColor,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Image.asset(
                                  product.imageUrl,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                                      ElevatedButton(
                                        onPressed: () async {
                                          final user = await widget.usersController.getCurrentUser();
                                          if (user != null) {
                                            // Eliminar el producto de favoritos
                                            await widget.likedProductsController.removeFromLikedProducts(product.id);
                                            
                                            // Actualizar la lista de favoritos
                                            setState(() {
                                              _likedProductsFuture = widget.likedProductsController.getLikedProductsByUserId(user.id);
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: AppColors.primaryColor,
                                          onPrimary: Colors.white,
                                        ),
                                        child: Text('Eliminar de favoritos'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No products found in favorites.'));
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
