import '../models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryController {
  static const categoriesKey = 'categories_key';

  Future<List<Category>> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesString = prefs.getStringList(categoriesKey);
    if (categoriesString == null || categoriesString.isEmpty) {
      return [
        Category(id: 1, name: 'Electronics'),
        Category(id: 2, name: 'Clothing'),
        Category(id: 3, name: 'Home'),
      ];
    }
    return categoriesString.map((categoryString) {
      final data = categoryString.split(',');
      return Category(
        id: int.parse(data[0]),
        name: data[1],
      );
    }).toList();
  }

  Future<void> _saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesString = categories.map((category) {
      return '${category.id},${category.name}';
    }).toList();
    prefs.setStringList(categoriesKey, categoriesString);
  }

  Future<List<Category>> getCategories() async {
    return _loadCategories();
  }

  Future<Category> addCategory(NewCategory category) async {
    final currentCategories = await _loadCategories();
    final newCategory = Category(id:(currentCategories.isNotEmpty)? currentCategories.length+1:1, name: category.name);
    currentCategories.add(newCategory);
    await _saveCategories(currentCategories);
    return (newCategory);
  }

  Future<void> removeCategory(String id) async {
    final currentCategories = await _loadCategories();
    currentCategories.removeWhere((category) => category.id == id);
    await _saveCategories(currentCategories);
  }
}
