import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repository/auth_repository.dart';
import '../../libraries/dio_controller.dart';

class SimpleLoginScreen extends StatefulWidget {
  const SimpleLoginScreen({super.key});

  @override
  State<SimpleLoginScreen> createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<SimpleLoginScreen> {
  late final GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllerGoogle = TextEditingController();
  @override
  void initState() {
    super.initState();
    _setupGoogleSignIn();
  }

  void _setupGoogleSignIn() {
    _googleSignIn = GoogleSignIn(
      serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
        'openid',
      ],
    );

    // Escuchar cambios de usuario
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _user = account;
      });
    });

    // Intento de login silencioso al abrir la app
    _googleSignIn.signInSilently();
  }

  bool _isPasswordValid(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_])[A-Za-z\d@$!%*?&]{8,128}$',
    );
    return passwordRegex.hasMatch(password);
  }

  Future<String?> _showPasswordDialog() async {
    final formKey = GlobalKey<FormState>();
    _passwordControllerGoogle.clear();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Crea una contraseña"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Debe contener entre 8 y 128 caracteres, incluyendo mayúsculas, minúsculas, números y caracteres especiales.",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordControllerGoogle,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "La contraseña es obligatoria";
                    }
                    if (!_isPasswordValid(value)) {
                      return "No cumple con los requisitos de seguridad";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                // Validar el formulario antes de cerrar
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, _passwordControllerGoogle.text);
                }
              },
              child: const Text("Registrar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        final String? contra = await _showPasswordDialog();

        if (contra == null) {
          _googleSignIn.signOut();
          return;
        }

        final authRepo = getIt<AuthRepository>();
        final response = await authRepo.loginWithGoogle(idToken, contra);
        if (response['success'] == true) {
          final userData = response['data']['user'];
          bool esNuevo = response['data']['esNuevoUsuario'] ?? false;
          String nombre = userData['nombre_apellido'];
          _showSnackBar(esNuevo
              ? "¡Cuenta creada con éxito! Bienvenido $nombre"
              : "Bienvenido de nuevo, $nombre");
        }

        _passwordControllerGoogle.clear();
        _googleSignIn.signOut();
      }
    } catch (error) {
      debugPrint("Error: $error");
      _showSnackBar("Error al iniciar sesión");
      _passwordControllerGoogle.clear();
      _googleSignIn.signOut();
    }
  }

  Future<void> _handleNormalLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Por favor, completa todos los campos");
      return;
    }

    try {
      final authRepo = getIt<AuthRepository>();
      final response = await authRepo.loginNormal(email, password);

      if (response['success'] == true) {

        final data = response['data'];

        if (data != null && data['user'] != null) {
          final userData = data['user'];
          String nombre = userData['nombre_apellido'] ?? "Usuario";
          _showSnackBar("¡Bienvenido de nuevo, $nombre!");
        } else {
          _showSnackBar("Login exitoso");
        }
      } else {
        _showSnackBar(response['message'] ?? "Credenciales incorrectas");
      }
    } catch (error) {
      debugPrint("Error en Login: $error");
      _showSnackBar("Usuario o contraseña incorrectos");
    }
  }
  void _showSnackBar(String msg) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Lógin')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.account_balance_wallet, size: 80, color: Colors.blue),
            const SizedBox(height: 30),
            // LOGIN NORMAL
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Correo Electrónico", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleNormalLogin,
                child: const Text("Iniciar Sesión"),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("O")),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),
            // BOTÓN GOOGLE CON ICONO
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: Image.asset(
                  'assets/iconGoogle.png',
                  height: 24,
                ),
                label: const Text("Continuar con Google", style: TextStyle(color: Colors.black87)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _handleSignIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}