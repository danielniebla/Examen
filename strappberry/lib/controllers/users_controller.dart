import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/users_model.dart';

class UsersController {
  static const String usersKey = 'users_key';
  static const String sessionKey = 'loggedInUser';

  late final encrypt.Encrypter _encrypter;
  late final encrypt.Key _key;

  UsersController() {
    _key = encrypt.Key.fromLength(32); 
    _encrypter = encrypt.Encrypter(encrypt.AES(_key));
  }

  String _encryptPassword(String password) {
    final iv = encrypt.IV.fromLength(16); 
    final encrypted = _encrypter.encrypt(password, iv: iv);
    return '${iv.base64}:${encrypted.base64}'; 
  }

  String _decryptPassword(String encryptedPassword) {
    final parts = encryptedPassword.split(':');
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encrypted = parts[1];
    return _encrypter.decrypt64(encrypted, iv: iv);
  }

  Future<List<Users>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getStringList(usersKey);
    if (usersString == null || usersString.isEmpty) {
      return [
        Users(id: 1, name: 'admin', email: 'admin@example.com', password: _encryptPassword('123'), isAdmin: true),
        Users(id: 2, name: 'olaph', email: 'hola@hola.com', password: _encryptPassword('123'), isAdmin: false),
      ];
    }
    return usersString.map((userString) {
      final data = jsonDecode(userString);
      return Users.fromJson(data);
    }).toList();
  }

  Future<void> _saveUsers(List<Users> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = users.map((user) {
      return jsonEncode(user.toJson());
    }).toList();
    prefs.setStringList(usersKey, usersString);
  }

  Future<bool> login(String email, String password) async {
    final List<Users> users = await _loadUsers();
    final Users? user = users.firstWhere(
      (user) => user.email == email && _decryptPassword(user.password) == password,
    );

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(sessionKey, jsonEncode(user.toJson()));
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(sessionKey);
  }

  Future<Users?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(sessionKey);
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return Users.fromJson(userMap);
    }
    return null;
  }

  Future<void> register(NewUsers user) async {
    final encryptedPassword = _encryptPassword(user.password);
    final newUser = Users(
      id: await _getNextUserId(),
      name: user.name,
      email: user.email,
      password: encryptedPassword,
      isAdmin: user.isAdmin,
    );
    final currentUsers = await _loadUsers();
    currentUsers.add(newUser);
    await _saveUsers(currentUsers);
  }

  Future<int> _getNextUserId() async {
    final users = await _loadUsers();
    if (users.isNotEmpty) {
      return users.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;
    }
    return 1;
  }

  Future<void> removeUser(int id) async {
    final currentUsers = await _loadUsers();
    currentUsers.removeWhere((user) => user.id == id);
    await _saveUsers(currentUsers);
  }

  Future<void> clearUsers() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(usersKey);
  }
}
