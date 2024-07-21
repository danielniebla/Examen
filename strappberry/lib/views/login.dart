import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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

  void handleLogin() {
    Navigator.pushNamed(context, '/product_list');
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
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.21), // 21% de padding en el eje x
                child: const Image(
                  image: AssetImage('assets/logo.png'),
                ),
              ),
            ),
          ),
          // Bloque inferior de 71% de la altura, rellenando el resto de la pantalla
          Container(
              width: double.infinity, // Ancho completo
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
                  padding: EdgeInsets.only(top: screenHeight * 0.05), // Ajustar el padding superior
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // Asegura que los elementos se estiren horizontalmente
                    children: [
                      // Campo de Email
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
                      const SizedBox(height: 16.0), // Espacio entre los campos de texto

                      // Campo de Contraseña
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock, color: AppColors.iconsColor),
                          filled: true,
                          fillColor: AppColors.shadowColor,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16.0), // Espacio entre los campos de texto

                      // Botón de Iniciar Sesión
                      ElevatedButton(
                        onPressed: handleLogin,
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primaryColor, // Fondo del botón
                          onPrimary: Colors.white, // Color del texto
                          minimumSize: Size(double.infinity, 50), // Botón de ancho completo
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Iniciar Sesión'),
                      ),
                      const SizedBox(height: 16.0), // Espacio entre el botón y el texto de registro
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
      )
    );
  }
}
