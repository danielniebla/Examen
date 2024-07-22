import 'package:flutter_modular/flutter_modular.dart';
import '/controllers/product_controller.dart';
import '/controllers/category_controller.dart';
import '/controllers/users_controller.dart';
import '/controllers/cart_controller.dart';
import '/views/login.dart';
import '/views/register.dart';
import 'views/admin/product_list.dart';
import 'views/admin/add_product.dart';
import 'views/client/main_products.dart';
import 'views/client/cart.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => CategoryController()),
    Bind.singleton((i) => ProductController(i.get<CategoryController>())),
    Bind.singleton((i) => UsersController()),
    // Pasar el ProductController al CartController
    Bind.singleton((i) => CartController(i.get<ProductController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => LoginPage(
      usersController: Modular.get<UsersController>(),
    )),
    ChildRoute('/register', child: (_, __) => RegisterPage(
      usersController: Modular.get<UsersController>(),
    )),
    ChildRoute('/product_list', child: (_, __) => ProductListPage(
      productController: Modular.get<ProductController>(),
      categoryController: Modular.get<CategoryController>(),
      usersController: Modular.get<UsersController>(),
    )),
    ChildRoute('/main_products', child: (_, __) => MainProductsPage(
      productController: Modular.get<ProductController>(),
      categoryController: Modular.get<CategoryController>(),
      usersController: Modular.get<UsersController>(),
    )),
    ChildRoute('/add_product', child: (_, __) => AddProductPage(
      productController: Modular.get<ProductController>(),
      categoryController: Modular.get<CategoryController>(),
      usersController: Modular.get<UsersController>(),
    )),
    ChildRoute('/cart', child: (_, __) => CartPage(
      usersController: Modular.get<UsersController>(),
      productController: Modular.get<ProductController>(),
      cartController: Modular.get<CartController>(),
    )),
  ];
}
