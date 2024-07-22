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
  Users? user;
  Product? product;

  
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
      final Users? user = await widget.usersController.getCurrentUser();
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } 
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || product == null) {
      // Puedes retornar un widget vacío mientras se redirige
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
        actions: [],
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
                product!.imageUrl,
                height: 200, // Ajusta según necesites
                width: 200, // Ajusta según necesites
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            // Nombre del producto
            Text(
              product!.name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 8.0),
            // Precio del producto
            Text(
              '\$${product!.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20.0,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 16.0),
            // Descripción del producto
            Text(
              product!.description,
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
}
