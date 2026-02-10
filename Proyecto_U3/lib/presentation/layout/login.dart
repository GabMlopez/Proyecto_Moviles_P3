import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../presentation/global_manager/user_provider.dart';
import '../../domain/repository/auth_repository.dart';
import '../../libraries/dio_controller.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SimpleLoginScreen extends StatefulWidget {
  const SimpleLoginScreen({super.key});

  @override
  State<SimpleLoginScreen> createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<SimpleLoginScreen> {
  bool _isLoading = false;
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

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Future<void> _handleFacebookSignIn() async {
    _setLoading(true);
    try {
      // Iniciar sesión con los permisos configurados en Meta
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.success) {

        final String accessToken = result.accessToken!.tokenString;

        final authRepo = getIt<AuthRepository>();
        final response = await authRepo.loginWithFacebook(accessToken);

        if (response['success'] == true) {
          final data = response['data'];
          final String token = data['token'];
          final Map<String, dynamic> userData = data['user'];

          // Guardar en el Provider
          if (mounted) {
            context.read<UserProvider>().setAuthData(token, userData);
            _showSnackBar("¡Bienvenido via Facebook, ${userData['nombre_apellido']}!");
            context.go("/home");

          }
        }
      } else {
        _showSnackBar("Inicio de sesión cancelado");
      }
    } catch (error) {
      debugPrint("Error Facebook: $error");
      _showSnackBar("Error al conectar con Facebook");
    } finally {
      _setLoading(false);
    }
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
    _setLoading(true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return;
      };

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String email = googleUser.email;
      if (idToken != null) {
        final authRepo = getIt<AuthRepository>();
        final existingUserResponse = await authRepo.buscarUsuarioPorCorreo(email);
        final String? contra;
        if (existingUserResponse != null && existingUserResponse['idusuario'] != null) {
          contra = "USUARIO_EXISTENTE_GOOGLE";
        } else {
          _setLoading(false);
          contra = await _showPasswordDialog();
          _setLoading(true);
        }

        if (contra == null) {
          _googleSignIn.signOut();
          _setLoading(false);
          return;
        }

        final response = await authRepo.loginWithGoogle(idToken, contra);
        if (response['success'] == true) {
          final data = response['data'];
          final String token = data['token'];
          final Map<String, dynamic> userData = data['user'];

          context.read<UserProvider>().setAuthData(token, userData);
          final id = context.read<UserProvider>().idUsuario;
          _showSnackBar("Login con Google exitoso. Bienvenido ${data['user']['nombre_apellido']}");
        }

        _passwordControllerGoogle.clear();
        _googleSignIn.signOut();
        context.go("/home");
      }
    } catch (error) {
      debugPrint("Error: $error");
      _showSnackBar("Error al iniciar sesión");

    }finally{
      _setLoading(false);
      _passwordControllerGoogle.clear();
      _googleSignIn.signOut();
    }
  }

  Future<void> _handleNormalLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Por favor, completa todos los campos");
      _setLoading(false);
      return;
    }
    _setLoading(true);
    try {
      final authRepo = getIt<AuthRepository>();
      final response = await authRepo.loginNormal(email, password);

      if (response['success'] == true) {
          final String token = response['token'];
          final Map<String, dynamic> userData = response['user'];

          if (mounted) {
            context.read<UserProvider>().setAuthData(token, userData);

            final id = context.read<UserProvider>().idUsuario;
            _showSnackBar("¡Bienvenido! Tu ID es: $id");
            context.go("/home");
          }

      } else {
        _showSnackBar(response['message'] ?? "Credenciales incorrectas");
      }
    } catch (error) {
      debugPrint("Error en Login: $error");
      _showSnackBar("Usuario o contraseña incorrectos");
    }finally{
      _setLoading(false);
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
      appBar: AppBar(title: const Text('Login')),
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
                onPressed: _isLoading ? null : _handleNormalLogin,
                child: _isLoading
                    ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
                    : const Text("Iniciar Sesión"),
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
                icon: _isLoading
                    ? const SizedBox.shrink()
                    : Image.asset('assets/iconGoogle.png', height: 24),
                label: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Continuar con Google", style: TextStyle(color: Colors.black87)),
                onPressed: _isLoading ? null : _handleSignIn,
              ),
            ),
            const SizedBox(height: 15), // Espaciado entre botones
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: _isLoading
                    ? const SizedBox.shrink()
                    : const Icon(Icons.facebook, color: Colors.white),
                label: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Continuar con Facebook",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2), // Azul oficial
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _isLoading ? null : _handleFacebookSignIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}