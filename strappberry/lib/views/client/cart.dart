import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../controllers/users_controller.dart';
import '../../models/users_model.dart';


class CartPage extends StatefulWidget {
  final UsersController usersController;

  const CartPage({Key? key,
    required this.usersController,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Users user;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi carrito'),
        backgroundColor: AppColors.primaryColor,
      ),
      backgroundColor: AppColors.secondaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Card(
                    color: AppColors.secondaryColor,
                    child: ListTile(
                      leading: Image.asset('assets/product_image.png'),
                      title: Text(
                        'Macbook M1',
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                      subtitle: Text(
                        '\$140',
                        style: TextStyle(color: AppColors.shadowColor),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: AppColors.iconsColor),
                            onPressed: () {},
                          ),
                          Text('1', style: TextStyle(color: AppColors.primaryColor)),
                          IconButton(
                            icon: Icon(Icons.add, color: AppColors.iconsColor),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Repite el Card para más productos
                ],
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
                    '\$420',
                    style: TextStyle(color: AppColors.primaryColor, fontSize: 20),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColor, // Fondo del botón
                onPrimary: Colors.white, // Color del texto
              ),
              child: Text('Comprar ahora'),
            ),
          ],
        ),
      ),
    );
  }
}
