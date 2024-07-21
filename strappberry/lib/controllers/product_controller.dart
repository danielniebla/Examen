import '../models/product_model.dart';
import '../models/category_model.dart'; // Asegúrate de importar este archivo
import 'category_controller.dart';

class ProductController {
  final List<Product> _products = [];
  final CategoryController _categoryController;

  ProductController(this._categoryController);

  List<Product> getProducts() {
    return List.unmodifiable(_products);
  }

  void addProduct(Product product) {
    _products.add(product);
  }

  void removeProduct(String id) {
    _products.removeWhere((product) => product.id == id);
  }

  List<Category> getCategories() {
    return _categoryController.getCategories();
  }
  void updateProduct(Product updatedProduct) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == updatedProduct.id) {
        _products[i] = updatedProduct;
        break;
      }
    }
  }
}
