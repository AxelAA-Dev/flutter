import 'package:aquateam/service/api_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
   final apiService = ApiService();

  bool isEmailValid = false;
  bool isPasswordValid = false;

  /// Verificar si el email tiene una estructura válida
  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Verificar si la contraseña tiene al menos 8 caracteres
  bool validatePassword(String password) {
    return password.length >= 8;
  }

  /// Actualiza el estado del botón de login
  void updateButtonState() {
    setState(() {
      isEmailValid = validateEmail(_emailController.text);
      isPasswordValid = validatePassword(_passwordController.text);
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(updateButtonState);
    _passwordController.addListener(updateButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Función para iniciar sesión
  void dlogin() {
    print('Iniciando sesión...');
    Navigator.pushReplacementNamed(context, '/home');
  }

void login() async {
  // Muestra un indicador de carga
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 20),
          Text('Verificando credenciales...'),
        ],
      ),
      duration: const Duration(minutes: 1),
    ),
  );

  try {
    final resultado = await apiService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    
    // Oculta el indicador de carga
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    print('Login exitoso! Usuario ID: ${resultado.id}');
    print('Nombre: ${resultado.nombre}');
    print('Existe: ${resultado.existe ?? false}');

    // Navegar a pantalla principal
    Navigator.pushReplacementNamed(context, '/home');

  } catch (e) {
    // Oculta el indicador de carga y muestra error
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  /// Función para abrir el formulario de registro
  void openRegistrationForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _nameController = TextEditingController();
        final _regEmailController = TextEditingController();
        final _regPasswordController = TextEditingController();

        bool isRegEmailValid = false;
        bool isRegPasswordValid = false;

        void updateRegistrationButtonState() {
          setState(() {
            isRegEmailValid = validateEmail(_regEmailController.text);
            isRegPasswordValid = validatePassword(_regPasswordController.text);
          });
        }

        _regEmailController.addListener(updateRegistrationButtonState);
        _regPasswordController.addListener(updateRegistrationButtonState);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Registro'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre Completo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _regEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        border: const OutlineInputBorder(),
                        errorText: !isRegEmailValid &&
                                _regEmailController.text.isNotEmpty
                            ? 'Formato de email incorrecto'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _regPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: const OutlineInputBorder(),
                        errorText: !isRegPasswordValid &&
                                _regPasswordController.text.isNotEmpty
                            ? 'Debe tener al menos 8 caracteres'
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: isRegEmailValid && isRegPasswordValid
                      ? () {
                          String name = _nameController.text.trim();
                          String email = _regEmailController.text.trim();
                          String password = _regPasswordController.text.trim();

                          if (name.isNotEmpty) {
                            print('Usuario registrado: $name, $email');
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('El nombre no puede estar vacío'),
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[300],
                  ),
                  child: const Text('Registrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                border: const OutlineInputBorder(),
                errorText: !isEmailValid && _emailController.text.isNotEmpty
                    ? 'Formato de email incorrecto'
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: const OutlineInputBorder(),
                errorText:
                    !isPasswordValid && _passwordController.text.isNotEmpty
                        ? 'Debe tener al menos 8 caracteres'
                        : null,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isEmailValid && isPasswordValid ? login : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue[300],
              ),
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: openRegistrationForm,
              child: const Text('¿No estás registrado? Regístrate aquí'),
            ),
          ],
        ),
      ),
    );
  }
}
