import 'package:flutter/material.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/users_controller.dart';
import '../../utils/app_colors.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../../models/users_model.dart';

class MainProductsPage extends StatefulWidget {
  final ProductController productController;
  final CategoryController categoryController;
  final UsersController usersController;

  const MainProductsPage({
    Key? key,
    required this.productController,
    required this.categoryController,
    required this.usersController,
  }) : super(key: key);

  @override
  _MainProductsPageState createState() => _MainProductsPageState();
}

class _MainProductsPageState extends State<MainProductsPage> {
  late Future<Users?> _currentUserFuture;
  late Future<List<Category>> _categoriesFuture;
  late Future<List<Product>> _productsFuture; 
  Category? _selectedCategory; 
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentUserFuture = widget.usersController.getCurrentUser();
    _categoriesFuture = widget.categoryController.getCategories();
    _productsFuture = widget.productController.getProducts();
  }

  void onCategorySelected(Category category) {
    setState(() {
      _selectedCategory = category;
      _productsFuture = widget.productController.getProductByCategory(category.id);
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        _selectedCategory = null;
        _productsFuture = widget.productController.getProducts();
      }else if (index == 1) {
        Navigator.pushNamed(context, '/likes');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Users?>(
          future: _currentUserFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Hola...');
            } else if (snapshot.hasError) {
              return Text('Error');
            } else if (snapshot.hasData) {
              final user = snapshot.data;
              return Text(
                'Hola ${user?.name ?? 'User'}',
                style: TextStyle(color: AppColors.primaryColor),
              );
            } else {
              return Text('Hola');
            }
          },
        ),
        backgroundColor: AppColors.secondaryColor,
        foregroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            color: AppColors.primaryColor,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, categorySnapshot) {
          if (categorySnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (categorySnapshot.hasError) {
            return Center(child: Text('Error: ${categorySnapshot.error}'));
          } else if (categorySnapshot.hasData) {
            final categories = categorySnapshot.data!;
            return Column(
              children: [
                Container(
                  height: 60,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: ElevatedButton(
                            onPressed: () => onCategorySelected(category),
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            ),
                            child: Text(
                              category.name,
                              style: const TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Product>>(
                    future: _productsFuture,
                    builder: (context, productSnapshot) {
                      if (productSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (productSnapshot.hasError) {
                        return Center(child: Text('Error: ${productSnapshot.error}'));
                      } else if (productSnapshot.hasData) {
                        final products = productSnapshot.data!;
                        return GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return GestureDetector(
                              onTap: () {
                                widget.productController.setInstance(product);
                                print('aqui si llego');
                                Navigator.pushNamed(context, '/details');
                              },
                              child: Card(
                                color: AppColors.shadowColor,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Image.asset(product.imageUrl),
                                    ),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(4.0),
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            product.name,
                                            style: const TextStyle(color: AppColors.primaryColor),
                                          ),
                                          Text(
                                            product.price.toString(),
                                            style: const TextStyle(color: AppColors.primaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: Text('No products found.'));
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No categories found.'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
      ),
    );
  }
}
