import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';

class AddProductPage extends StatefulWidget {
  final ProductController productController;
  final CategoryController categoryController;

  const AddProductPage({
    Key? key,
    required this.productController,
    required this.categoryController,
  }) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}
class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();
  String? _selectedCategory;
  bool _isNewCategory = false;
  final List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await widget.categoryController.getCategories();
    setState(() {
      _categories.addAll(categories.map((category) => category.name));
    });
  }

  @override
  void dispose() {
    _newCategoryController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addProduct() {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        (_selectedCategory != null || _isNewCategory) &&
        _descriptionController.text.isNotEmpty) {

      String category;
      if (_isNewCategory) {
        category = _newCategoryController.text;
        if (category.isNotEmpty) {
          final newCategory = Category(
            id: DateTime.now().toString(),
            name: category,
          );
          widget.categoryController.addCategory(newCategory);
          setState(() {
            _categories.add(category);
            _isNewCategory = false;
            _selectedCategory = category;
            _newCategoryController.clear();
          });
        }
      } else {
        category = _selectedCategory ?? '';
      }

      final newProduct = Product(
        id: DateTime.now().toString(), // Unique ID for the new product
        name: _nameController.text,
        imageUrl: 'assets/logo.png', 
        price: double.tryParse(_priceController.text) ?? 0.0,
        description: _descriptionController.text,
        category: category,
      );

      widget.productController.addProduct(newProduct);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select a category')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Producto',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.secondaryColor,
      body: FutureBuilder(
        future: widget.categoryController.getCategories(),
        builder: (context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final categories = snapshot.data!;
            _categories.clear();
            _categories.addAll(categories.map((category) => category.name));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Logic to pick an image
                    },
                    child: Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.grey,
                            ),
                            Text('Tap to add image', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: AppColors.shadowColor,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: AppColors.shadowColor,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    hint: const Text('Selecciona una categoría'),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList()
                      ..add(
                        const DropdownMenuItem(
                          value: 'other',
                          child: Text('Otra'),
                        ),
                      ),
                    onChanged: (value) {
                      if (value == 'other') {
                        setState(() {
                          _isNewCategory = true;
                          _selectedCategory = null;
                        });
                      } else {
                        setState(() {
                          _isNewCategory = false;
                          _selectedCategory = value;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: AppColors.shadowColor,
                    ),
                  ),
                  if (_isNewCategory)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: TextField(
                        controller: _newCategoryController,
                        decoration: const InputDecoration(
                          labelText: 'Nueva Categoría',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: AppColors.shadowColor,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: AppColors.shadowColor,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addProduct,
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.primaryColor,
                        onPrimary: Colors.white,
                      ),
                      child: const Text('Añadir Producto'),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No categories found.'));
          }
        },
      ),
    );
  }
}
