import '../models/category_model.dart';

class CategoryController {
  final List<Category> _categories = [
    Category(id: '1', name: 'Electronics'),
    Category(id: '2', name: 'Clothing'),
    Category(id: '3', name: 'Home'),
  ];

  List<Category> getCategories() {
    return List.unmodifiable(_categories);
  }

  void addCategory(Category category) {
    _categories.add(category);
  }

  void removeCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
  }
}
