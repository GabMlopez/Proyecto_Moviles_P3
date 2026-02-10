import 'package:google_sign_in/google_sign_in.dart';

import '../data/datasources/remote/auth_remote_datasource.dart';

class AuthService {
  final AuthRemoteDataSource authRemoteDataSource;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  AuthService(this.authRemoteDataSource);

  Future<void> signInWithGoogle(String contrasenia) async {
    try {
      // Iniciar el flujo de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // El usuario canceló

      //  Obtener los detalles de autenticación
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        await authRemoteDataSource.loginWithGoogle(idToken,contrasenia);
      }
    } catch (e) {
      print("Error en el proceso de login: $e");
    }
  }
}