import 'package:google_sign_in/google_sign_in.dart';

import '../data/datasources/remote/auth_remote_datasource.dart';

class AuthService {
  final AuthRemoteDataSource authRemoteDataSource;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // En Android esto no es estrictamente necesario si usas Firebase,
    // pero en iOS sí.
    scopes: ['email', 'profile'],
  );

  AuthService(this.authRemoteDataSource);

  Future<void> signInWithGoogle() async {
    try {
      // 1. Iniciar el flujo de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // El usuario canceló

      // 2. Obtener los detalles de autenticación
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        final response = await authRemoteDataSource.loginWithGoogle(idToken);

        print("Servidor respondió con éxito: ${response}");
        // Aquí guardarías el token de TU servidor (JWT) usando Flutter Secure Storage
      }
    } catch (e) {
      print("Error en el proceso de login: $e");
    }
  }
}