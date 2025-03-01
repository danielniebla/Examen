import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../controllers/users_controller.dart';
import '../models/users_model.dart';

class RegisterPage extends StatefulWidget {
  final UsersController usersController;

  const RegisterPage({
    Key? key,
    required this.usersController,
  }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool isAdmin = false;

  @override
  void dispose() {
    _confirmController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _registerUser() {
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmController.text.isNotEmpty &&
        _passwordController.text == _confirmController.text) {
      final newUser = NewUsers(
        id: null, 
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        isAdmin: isAdmin,
      );

      widget.usersController.register(newUser);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.19,
              width: double.infinity,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.21), 
                  child: const Image(
                    image: AssetImage('assets/logo.png'),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: screenHeight * 0.81,
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, 
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person, color: AppColors.iconsColor),
                          filled: true,
                          fillColor: AppColors.shadowColor,
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email, color: AppColors.iconsColor),
                          filled: true,
                          fillColor: AppColors.shadowColor,
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock, color: AppColors.iconsColor),
                          filled: true,
                          fillColor: AppColors.shadowColor,
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      TextField(
                        controller: _confirmController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Contraseña',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock, color: AppColors.iconsColor),
                          filled: true,
                          fillColor: AppColors.shadowColor,
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      CheckboxListTile(
                        title: const Text('Administrador'),
                        value: isAdmin,
                        onChanged: (bool? value) {
                          setState(() {
                            isAdmin = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),

                      ElevatedButton(
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primaryColor,
                          onPrimary: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Registrar'),
                      ),
                      const SizedBox(height: 16.0),
                      const Spacer(),
                      const Text(
                        '¿Ya tienes cuenta?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: const Text(
                          'Inicia sesión',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
