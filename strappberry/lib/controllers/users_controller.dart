import '../models/users_model.dart';

class UsersController {
  final List<Users> _users = [
    Users(id: '1', name: 'admin',email:'admin@example.com', password:'123',isAdmin: true),
  ];

  List<Users> getCategories() {
    return List.unmodifiable(_users);
  }

  void addUsers(Users users) {
    _users.add(users);
  }

  void removeUsers(String id) {
    _users.removeWhere((users) => users.id == id);
  }
}
