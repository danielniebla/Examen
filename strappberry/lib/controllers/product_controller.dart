import '../models/product_model.dart';
import '../models/category_model.dart';
import 'category_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController {
  static const productsKey = 'products_key';

  final CategoryController _categoryController;

  ProductController(this._categoryController);

  Future<List<Product>> _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsString = prefs.getStringList(productsKey);
    if (productsString == null || productsString.isEmpty) {
      return [
        Product(
          id: '1',
          name: 'Smartphone',
          imageUrl: 'assets/logo.png',
          price: 699.99,
          description: 'A high-quality smartphone.',
          category: 'Electronics',
        ),
        Product(
          id: '2',
          name: 'T-shirt',
          imageUrl: 'assets/logo.png',
          price: 19.99,
          description: 'Comfortable cotton t-shirt.',
          category: 'Clothing',
        ),
        Product(
          id: '3',
          name: 'Coffee Maker',
          imageUrl: 'assets/logo.png',
          price: 89.99,
          description: 'A coffee maker with multiple functions.',
          category: 'Home',
        ),
      ];
    }
    return productsString.map((productString) {
      final data = productString.split(',');
      return Product(
        id: data[0],
        name: data[1],
        imageUrl: data[2],
        price: double.tryParse(data[3]) ?? 0.0,
        description: data[4],
        category: data[5],
      );
    }).toList();
  }

  Future<void> _saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final productsString = products.map((product) {
      return '${product.id},${product.name},${product.imageUrl},${product.price},${product.description},${product.category}';
    }).toList();
    prefs.setStringList(productsKey, productsString);
  }

  Future<void> addProduct(Product product) async {
    final currentProducts = await _loadProducts();
    currentProducts.add(product);
    await _saveProducts(currentProducts);
  }

  Future<void> removeProduct(String id) async {
    final currentProducts = await _loadProducts();
    currentProducts.removeWhere((product) => product.id == id);
    await _saveProducts(currentProducts);
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final currentProducts = await _loadProducts();
    for (int i = 0; i < currentProducts.length; i++) {
      if (currentProducts[i].id == updatedProduct.id) {
        currentProducts[i] = updatedProduct;
        break;
      }
    }
    await _saveProducts(currentProducts);
  }

  Future<List<Product>> getProducts() async {
    return _loadProducts();
  }

  Future<List<Category>> getCategories() async {
    return _categoryController.getCategories();
  }
}
