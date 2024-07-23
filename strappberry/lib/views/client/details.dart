import 'package:flutter/material.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/users_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../models/product_model.dart';
import '../../models/users_model.dart';
import '../../models/cart_model.dart'; 
import '../../utils/app_colors.dart';

class DetailsPage extends StatefulWidget {
  final ProductController productController;
  final UsersController usersController;
  final CartController cartController;

  const DetailsPage({
    Key? key,
    required this.productController,
    required this.usersController,
    required this.cartController,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<Users?> _userFuture;
  late Future<Product?> _productFuture;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _userFuture = widget.usersController.getCurrentUser();
    _productFuture = widget.productController.getProductDetails();

    _userFuture.catchError((error) {
      setState(() {
        _errorMessage = 'Error al obtener el usuario: ${error.toString()}';
      });
    });

    _productFuture.catchError((error) {
      setState(() {
        _errorMessage = 'Error al obtener el producto: ${error.toString()}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: _productFuture,
      builder: (context, productSnapshot) {
        if (productSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (productSnapshot.hasError || !productSnapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/main_products'));
                },
              ),
              title: Text(
                'Detalles del producto',
                style: TextStyle(color: AppColors.primaryColor),
              ),
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: AppColors.primaryColor,
            ),
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                _errorMessage ?? 'Error: Producto no disponible',
                style: TextStyle(color: Colors.red, fontSize: 18.0),
              ),
            ),
          );
        } else {
          final product = productSnapshot.data;

          if (product == null) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/main_products'));
                  },
                ),
                title: Text(
                  'Detalles del producto',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
                backgroundColor: AppColors.secondaryColor,
                foregroundColor: AppColors.primaryColor,
              ),
              backgroundColor: Colors.white,
              body: Center(
                child: Text(
                  'No hay información del producto disponible.',
                  style: TextStyle(color: Colors.red, fontSize: 18.0),
                ),
              ),
            );
          }

          return FutureBuilder<Users?>(
            future: _userFuture,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (userSnapshot.hasError || !userSnapshot.hasData) {
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/main_products'));
                      },
                    ),
                    title: Text(
                      'Detalles del producto',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: AppColors.primaryColor,
                  ),
                  backgroundColor: Colors.white,
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Error al obtener el usuario: ${userSnapshot.error ?? 'No se pudo obtener información del usuario'}',
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        ),
                        SizedBox(height: 16.0),
                        _buildProductInfo(product!),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (userSnapshot.data != null) {
                                  final newCartItem = NewCartItem(
                                    id: null, 
                                    userId: userSnapshot.data!.id,
                                    productId: product.id,
                                    quantity: 1, 
                                  );

                                  try {
                                    await widget.cartController.addToCart(newCartItem);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Producto agregado al carrito')),
                                    );
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error al agregar el producto al carrito')),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.primaryColor, 
                                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                              ),
                              child: Text(
                                'Agregar al carrito',
                                style: TextStyle(fontSize: 18.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                final user = userSnapshot.data;

                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/main_products'));
                      },
                    ),
                    title: Text(
                      'Detalles del producto',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: AppColors.primaryColor,
                  ),
                  backgroundColor: Colors.white,
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductInfo(product!),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (user != null) {
                                  final newCartItem = NewCartItem(
                                    id: null, 
                                    userId: user.id!,
                                    productId: product.id!,
                                    quantity: 1,
                                  );

                                  try {
                                    await widget.cartController.addToCart(newCartItem);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Producto agregado al carrito')),
                                    );
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error al agregar el producto al carrito')),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.primaryColor, 
                                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                              ),
                              child: Text(
                                'Agregar al carrito',
                                style: TextStyle(fontSize: 18.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  Widget _buildProductInfo(Product product) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            color: AppColors.shadowColor, 
            child: Image.asset(
              product.imageUrl,
              height: screenHeight * .4,
              width: double.infinity,
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          product.name,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          product.description,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
