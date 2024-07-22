import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'app.module.dart';
import 'app.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/users_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/category_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Limpiar datos al iniciar
  await _clearDataOnStartup();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      ModularApp(
        module: AppModule(),
        child: const AppWidget(),
      ),
    ),
  );
}

Future<void> _clearDataOnStartup() async {
  final prefs = await SharedPreferences.getInstance();

  // Limpiar datos de productos
  prefs.remove(ProductController.productsKey);

  // Limpiar datos de categorías
  prefs.remove(CategoryController.categoriesKey);

  // Limpiar datos de usuarios
  prefs.remove(UsersController.usersKey);

  // deje estos comentarios por aqui por si quiero limpiar los datos en algun momento
}

errorHandler() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // log('ERROR', error: error, stackTrace: stack);
    return true;
  };
}
