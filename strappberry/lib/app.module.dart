import 'package:flutter_modular/flutter_modular.dart';
import '/controllers/product_controller.dart';
import '/controllers/category_controller.dart';
import '/views/login.dart';
import '/views/register.dart';
import '/views/product_list.dart';
import '/views/add_product.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => CategoryController()),
    Bind.singleton((i) => ProductController(i.get<CategoryController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => LoginPage()),
    ChildRoute('/register', child: (_, __) => RegisterPage()),
    ChildRoute('/product_list', child: (_, __) => ProductListPage(
      productController: Modular.get<ProductController>(),
      categoryController: Modular.get<CategoryController>(),
    )),
    ChildRoute('/add_product', child: (_, __) => AddProductPage(
      productController: Modular.get<ProductController>(),
      categoryController: Modular.get<CategoryController>(),
    )),
  ];
}
