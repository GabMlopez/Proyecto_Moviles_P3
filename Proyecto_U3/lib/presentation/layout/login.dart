import 'dart:async';
import 'package:dio/dio.dart';
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

  Future<String?> _showPasswordDialog() async {
    String? password;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Crea una contraseña"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Para completar tu registro, asigna una contraseña a tu cuenta."),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña"),
              onChanged: (value) => password = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, password),
            child: const Text("Registrar"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final String? idToken = googleAuth.idToken;
        if (idToken != null) {
          final authRepo = getIt<AuthRepository>();
          final response = await authRepo.loginWithGoogle(idToken,_passwordController.text);

          if (response['success'] == true) {
            _showSnackBar("Bienvenido: ${response['user']['nombre_apellido']}");
            // navegar a home
          }
        } else {
          throw Exception("No se pudo obtener el ID Token de Google");
        }

    } catch (error) {
      debugPrint("Error de inicio de sesión: $error");
      _showSnackBar("Error: $error");
    }
  }


  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void _showSnackBar(String msg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
                onPressed: () { /* Tu lógica de login normal */ },
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
                icon: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_Color_Icon.svg/1200px-Google_Color_Icon.svg.png',
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