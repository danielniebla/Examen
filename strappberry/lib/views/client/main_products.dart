import 'package:flutter/material.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../utils/app_colors.dart';
import '../../models/product_model.dart';
import '../../controllers/users_controller.dart';
import '../../models/users_model.dart';

class MainProductsPage extends StatefulWidget {
  final ProductController productController;
  final CategoryController categoryController;
  final UsersController usersController;

  const MainProductsPage({
    Key? key,
    required this.productController,
    required this.categoryController,
    required this.usersController,
  }) : super(key: key);

  @override
  _MainProductsPageState createState() => _MainProductsPageState();
}

class _MainProductsPageState extends State<MainProductsPage> {
  late Users user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context)!.settings.arguments as Users;
  }

  void addProduct() {
    Navigator.pushNamed(context, '/add_product');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hola ${user.name}',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        backgroundColor: AppColors.secondaryColor,
        foregroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Lógica para navegar a la página del carrito
              Navigator.pushNamed(context, '/cart');
            },
            color: AppColors.primaryColor,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: widget.productController.getProducts(),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final products = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 8.0, // Espacio horizontal entre los elementos
                mainAxisSpacing: 8.0, // Espacio vertical entre los elementos
              ),
              itemCount: products.length, // Número de elementos a mostrar
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: AppColors.shadowColor,
                  child: Column(
                    children: [
                      Image.asset(product.imageUrl),
                      Text(
                        product.name,
                        style: const TextStyle(color: AppColors.primaryColor),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: AppColors.shadowColor),
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
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No products found.'));
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
