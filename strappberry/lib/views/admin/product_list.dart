import 'package:flutter/material.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../utils/app_colors.dart';
import '../../models/product_model.dart';
import '../../controllers/users_controller.dart';
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
    late Users user;

  void addProduct() {
    Navigator.pushNamed(context, '/add_product',arguments: user );
  }

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Users) {
      user = args;
    } else {
      // Manejar el caso en el que los argumentos no son válidos
      // Por ejemplo, redirigir a la página de login
      Navigator.pushReplacementNamed(context, '/login');
    }
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
      body: FutureBuilder(
        future: widget.productController.getProductById(user.id),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                        product.price.toString(),
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
