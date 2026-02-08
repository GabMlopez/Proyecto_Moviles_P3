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
  // 1. Instancia configurada (v6.x usa este constructor)
  late final GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _user;
  String _contactInfo = "Sin datos";

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

    // Escuchar cambios de usuario (equivalente a los eventos en v7)
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _user = account;
      });
      if (account != null) {
        _fetchContacts();
      }
    });

    // Intento de login silencioso al abrir la app
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      // 1. Login con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // 2. Obtener la autenticación para sacar el ID Token
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final String? idToken = googleAuth.idToken;

        if (idToken != null) {
          _showSnackBar("Conectando con el servidor...");

          // 3. LLAMADA A TU BACKEND usando el Repositorio de GetIt
          final authRepo = getIt<AuthRepository>();
          final response = await authRepo.loginWithGoogle(idToken);

          // 4. Manejar la respuesta de tu servidor Express
          debugPrint("Respuesta Servidor: ${response['token']}");
          _showSnackBar("¡Bienvenido! Token recibido.");

          // Aquí podrías navegar a la pantalla de Inicio
        } else {
          throw Exception("No se pudo obtener el ID Token de Google");
        }
      }
    } catch (error) {
      debugPrint("Error de inicio de sesión: $error");
      _showSnackBar("Error: $error");
    }
  }

  Future<void> _fetchContacts() async {
    if (_user == null) return;

    try {
      // En v6.x obtenemos los headers directamente de la cuenta
      final Map<String, String> authHeaders = await _user!.authHeaders;

      final response = await Dio().get(
        'https://people.googleapis.com/v1/people/me/connections?personFields=names',
        options: Options(headers: authHeaders),
      );

      final int total = response.data['totalItems'] ?? 0;
      setState(() {
        _contactInfo = "Contactos: $total";
      });
    } catch (e) {
      debugPrint("Error fetching contacts: $e");
      // Si faltan permisos, solicitamos acceso adicional
      bool hasScope = await _googleSignIn.canAccessScopes([
        'https://www.googleapis.com/auth/contacts.readonly'
      ]);
      if (!hasScope) {
        await _googleSignIn.requestScopes([
          'https://www.googleapis.com/auth/contacts.readonly'
        ]);
      }
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void _showSnackBar(String msg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign In 6.2.1')),
      body: Center(
        child: _user == null
            ? ElevatedButton(
          onPressed: _handleSignIn,
          child: const Text("LOGIN"),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: _user!.photoUrl != null
                  ? NetworkImage(_user!.photoUrl!)
                  : null,
            ),
            const SizedBox(height: 10),
            Text("Hola, ${_user!.displayName}"),
            Text(_user!.email),
            const SizedBox(height: 20),
            Text(_contactInfo, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSignOut,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text("SALIR", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}