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
          id: 1,
          name: 'Smartphone',
          imageUrl: 'assets/logo.png',
          price: 699.99,
          description: 'A high-quality smartphone.',
          categoryId: 1,
          sellerId:1
        ),
        Product(
          id: 2,
          name: 'T-shirt',
          imageUrl: 'assets/logo.png',
          price: 19.99,
          description: 'Comfortable cotton t-shirt.',
          categoryId: 2,
          sellerId:1
        ),
        Product(
          id: 3,
          name: 'Coffee Maker',
          imageUrl: 'assets/logo.png',
          price: 89.99,
          description: 'A coffee maker with multiple functions.',
          categoryId: 3,
          sellerId:1
        ),
      ];
    }
    return productsString.map((productString) {
      final data = productString.split(',');
      return Product(
        id: int.parse(data[0]) ,
        name: data[1],
        imageUrl: data[2],
        price: double.parse(data[3]),
        description: data[4],
        categoryId: int.parse(data[5]),
        sellerId: int.parse(data[6])
      );
    }).toList();
  }

  Future<void> _saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final productsString = products.map((product) {
      return '${product.id},${product.name},${product.imageUrl},${product.price},${product.description},${product.categoryId},${product.sellerId}';
    }).toList();
    prefs.setStringList(productsKey, productsString);
  }

  Future<void> addProduct(NewProduct product) async {
    final currentProducts = await _loadProducts();
    currentProducts.add(Product(
        id: currentProducts.length +1, // Unique ID for the new product
        name: product.name,
        imageUrl: product.imageUrl, 
        price:  product.price,
        description:  product.description,
        categoryId:  product.categoryId,
        sellerId: product.sellerId
      ));
    await _saveProducts(currentProducts);
  }

  Future<void> removeProduct(int id) async {
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
  
 Future<List<Product>> getProductById(int id) async {
    final products = await _loadProducts();
    return products.where((product) => product.sellerId == id).toList();
  }

  Future<List<Product>> getProductByCategory(int id) async {
    final products = await _loadProducts();
    return products.where((product) => product.categoryId == id).toList();
  }


  Future<List<Category>> getCategories() async {
    return _categoryController.getCategories();
  }
}
