import 'package:flutter/material.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/users_controller.dart';
import '../../utils/app_colors.dart';
import '../../models/product_model.dart';
import '../../models/users_model.dart';

class ProductListPage extends StatefulWidget {
  final ProductController productController;
  final CategoryController categoryController;
  final UsersController usersController;

  const ProductListPage({
    Key? key,
    required this.productController,
    required this.categoryController,
    required this.usersController,
  }) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<Users?> _currentUserFuture;

  @override
  void initState() {
    super.initState();
    _currentUserFuture = widget.usersController.getCurrentUser();
  }

  void addProduct() {
    Navigator.pushNamed(context, '/add_product');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Listado de Productos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Users?>(
        future: _currentUserFuture,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          } else if (userSnapshot.hasData) {
            final user = userSnapshot.data;
            if (user == null) {
              return Center(child: Text('No user found.'));
            }

            return FutureBuilder<List<Product>>(
              future: widget.productController.getProductBySellerId(user.id),
              builder: (context, productSnapshot) {
                if (productSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (productSnapshot.hasError) {
                  return Center(child: Text('Error: ${productSnapshot.error}'));
                } else if (productSnapshot.hasData) {
                  final products = productSnapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        color: AppColors.shadowColor,
                        child: Padding(
                          padding:EdgeInsets.all(8.0) ,
                          child: Column(
                          children: [
                            Image.asset(product.imageUrl),
                            Spacer(),
                            Text(
                              product.name,
                              style: const TextStyle(color: AppColors.primaryColor),
                            ),
                            Text(
                              product.price.toString(),
                              style: const TextStyle(color: AppColors.primaryColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppColors.iconsColor),
                                  onPressed: () {
                                    // Lógica para editar
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppColors.iconsColor),
                                  onPressed: () {
                                    widget.productController.removeProduct(product.id);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                          ],
                        ),
                        )
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No products found.'));
                }
              },
            );
          } else {
            return Center(child: Text('No user found.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addProduct,
        backgroundColor: AppColors.primaryColor,
        shape: CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
