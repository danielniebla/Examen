import '../models/users_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersController {
  static const String usersKey = 'users_key';

  Future<List<Users>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getStringList(usersKey);
    if (usersString == null || usersString.isEmpty) {
      // Datos predeterminados si no hay datos en SharedPreferences
      return [
        Users(id: 1, name: 'admin', email: 'admin@example.com', password: '123', isAdmin: true),
      ];
    }
    return usersString.map((userString) {
      final data = userString.split(',');
      return Users(
        id: int.parse(data[0]),
        name: data[1],
        email: data[2],
        password: data[3],
        isAdmin: data[4] == 'true',
      );
    }).toList();
  }

  Future<void> _saveUsers(List<Users> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = users.map((user) {
      return '${user.id},${user.name},${user.email},${user.password},${user.isAdmin}';
    }).toList();
    prefs.setStringList(usersKey, usersString);
  }

  Future<List<Users>> getUsers() async {
    return _loadUsers();
  }

  Future<void> addUsers(NewUsers user) async {
    final currentUsers = await _loadUsers();
    currentUsers.add(Users(
      id: currentUsers.length + 1,
      name: user.name,
      email: user.email,
      password: user.password,
      isAdmin: user.isAdmin,
    ));
    await _saveUsers(currentUsers);
  }

  Future<void> removeUsers(String id) async {
    final currentUsers = await _loadUsers();
    currentUsers.removeWhere((user) => user.id == id);
    await _saveUsers(currentUsers);
  }

  Future<void> clearUsers() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(usersKey);
  }
}
