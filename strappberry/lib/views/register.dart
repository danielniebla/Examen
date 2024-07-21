import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isAdmin = false; // Estado inicial del checkbox

  void handleRegister() {
    print('bang bang bang');
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
            // Bloque superior de 19% de la altura
            Container(
              height: screenHeight * 0.19,
              width: double.infinity,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.21), // 21% de padding en el eje x, responsive por porcentajes
                  child: const Image(
                    image: AssetImage('assets/logo.png'),
                  ),
                ),
              ),
            ),
            // Bloque inferior de 81% de la altura
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
                  padding: EdgeInsets.only(top: screenHeight * 0.05), // Ajustar el padding superior
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // Asegura que los elementos se estiren horizontalmente
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Confirmar Contraseña',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock, color: AppColors.iconsColor),
                          filled: true,
                          fillColor: AppColors.shadowColor,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16.0), // Espacio entre los campos de texto
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email, color: AppColors.iconsColor),
                          filled: true,
                          fillColor: AppColors.shadowColor,
                        ),
                      ),
                      const SizedBox(height: 16.0), // Espacio entre los campos de texto
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock, color: AppColors.iconsColor),
                          filled: true,
                          fillColor: AppColors.shadowColor,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16.0), // Espacio entre el campo de contraseña y el botón
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person, color: AppColors.iconsColor),
                          filled: true,
                          fillColor: AppColors.shadowColor,
                        ),
                      ),
                      const SizedBox(height: 16.0), // Espacio entre el campo de contraseña y el botón
                      CheckboxListTile(
                        title: const Text('Administrador'),
                        value: isAdmin,
                        onChanged: (bool? value) {
                          setState(() {
                            isAdmin = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0), // Espacio entre el checkbox y el botón
                      ElevatedButton(
                        onPressed: handleRegister,
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primaryColor, // Fondo del botón
                          onPrimary: Colors.white, // Color del texto
                          minimumSize: Size(double.infinity, 50), // Botón de ancho completo
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Registrar'),
                      ),
                      const SizedBox(height: 16.0), // Espacio entre el botón y el texto de inicio de sesión
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
                      const SizedBox(height: 10.0), // Espacio entre el texto de inicio de sesión y el borde inferior
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
