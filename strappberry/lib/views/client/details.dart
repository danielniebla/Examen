import 'package:flutter/material.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/users_controller.dart';
import '../../models/product_model.dart';
import '../../models/users_model.dart';
import '../../utils/app_colors.dart';

class DetailsPage extends StatefulWidget {
  final ProductController productController;
  final UsersController usersController;

  const DetailsPage({
    Key? key,
    required this.productController,
    required this.usersController,
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
                        // Información del producto
                        Center(
                          child: Image.asset(
                            product.imageUrl,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
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
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
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
                        // Imagen del producto
                        Center(
                          child: Image.asset(
                            product.imageUrl,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        // Nombre del producto
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        // Precio del producto
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        // Descripción del producto
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
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
}
