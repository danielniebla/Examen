import 'package:flutter/material.dart';
import 'package:strappberry/models/users_model.dart';
import '../utils/app_colors.dart';
import '../controllers/users_controller.dart';
import '../models/users_model.dart';

class LoginPage extends StatefulWidget {
  final UsersController usersController;

  const LoginPage({Key? key, required this.usersController}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

 void handleLogin() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final bool login = await widget.usersController.login(email, password);

    if (login) {
      final Users? user = await widget.usersController.getCurrentUser();
      if (user != null) {
        if(user.isAdmin) {
          Navigator.pushNamed(context, '/product_list');
        }else{
          Navigator.pushNamed(context, '/main_products');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bienvenido ')),
        );
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al iniciar sesión')),
        );
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
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
              height: screenHeight * 0.29,
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
              height: screenHeight * 0.71,
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
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: AppColors.shadowColor,
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: AppColors.shadowColor,
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      ElevatedButton(
                        onPressed: handleLogin,
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primaryColor,
                          onPrimary: Colors.white,
                        ),
                        child: const Text('Iniciar Sesión'),
                      ),
                       const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿No tienes cuenta?',
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register'); 
                            },
                            child: const Text(
                              'Regístrate',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                          const Text(
                            'Brayhan Niebla | nieblabrayhan@gmail.com',
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0), 
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
