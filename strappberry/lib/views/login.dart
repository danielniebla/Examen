import 'package:flutter/material.dart';
import 'package:strappberry/models/users_model.dart';
import '../utils/app_colors.dart';
import '../controllers/users_controller.dart';


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

    final List<Users> users = await widget.usersController.getUsers();

    // Cambia el tipo a Users? para permitir valores nulos
    final Users? user = users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => Users(
        id: '',
        name: '',
        email: '',
        password: '',
        isAdmin: false,
      ),
    );

    if (user != null && user.id.isNotEmpty) {
      if(user.isAdmin) {
        Navigator.pushNamed(context, '/product_list');
      }else{
        Navigator.pushNamed(context, '/main_products',arguments: user);
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ahorita no joven')),
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
            // Bloque superior de 29% de la altura
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
            // Bloque inferior de 71% de la altura
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
                      // Campo de Email
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

                      // Campo de Contraseña
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

                      // Botón de Login
                      ElevatedButton(
                        onPressed: handleLogin,
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primaryColor,
                          onPrimary: Colors.white,
                        ),
                        child: const Text('Iniciar Sesión'),
                      ),
                       const Spacer(),
                      // Texto de registro
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿No tienes cuenta?',
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register'); // Navegar a la página de registro
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
                      const SizedBox(height: 20.0), // Espacio adicional al final
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
