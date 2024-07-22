class Users {
  final int id;
  final String name;
  final String email;
  final String password;
  final bool isAdmin;

  Users({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.password,
    required this.isAdmin,
  });
}
class NewUsers {
  final int? id;
  final String name;
  final String email;
  final String password;
  final bool isAdmin;

  NewUsers({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.password,
    required this.isAdmin,
  });
}
