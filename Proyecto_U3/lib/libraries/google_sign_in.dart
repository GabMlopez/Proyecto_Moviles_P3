import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../data/datasources/remote/auth_remote_datasource.dart';

class AuthService {
  final AuthRemoteDataSource authRemoteDataSource;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // En Android esto no es estrictamente necesario si usas Firebase,
    // pero en iOS sí.
    scopes: ['email', 'profile'],
  );

  AuthService(this.authRemoteDataSource);

  Future<void> signInWithGoogle(String contrasenia) async {
    try {
      // 1. Iniciar el flujo de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // El usuario canceló

      // 2. Obtener los detalles de autenticación
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        final response = await authRemoteDataSource.loginWithGoogle(idToken,contrasenia);

        print("Servidor respondió con éxito: ${response}");
        // Aquí guardarías el token de TU servidor (JWT) usando Flutter Secure Storage
      }
    } catch (e) {
      print("Error en el proceso de login: $e");
    }
  }

  Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      // 1. Iniciar flujo nativo de Facebook (usa los permisos configurados en Meta)
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.success) {
        // 2. Obtener el Token
        final String token = result.accessToken!.token;

        // 3. Enviar a tu API Node.js
        final response = await authRemoteDataSource.loginWithFacebook(token);
        return response;
      }
    } catch (e) {
      print("Error en Facebook Auth: $e");
    }
    return null;
  }
}
