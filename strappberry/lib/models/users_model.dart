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

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      isAdmin: json['isAdmin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'isAdmin': isAdmin,
    };
  }
}

class NewUsers {
  final int? id;
  final String name;
  final String email;
        String password;
  final bool isAdmin;

  NewUsers({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.password,
    required this.isAdmin,
  });
}
