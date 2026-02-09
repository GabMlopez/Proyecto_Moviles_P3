abstract class AuthRepository {
  Future<Map<String, dynamic>> loginWithGoogle(String idToken, String contrasenia);
  Future<Map<String, dynamic>> loginNormal(String correo, String contrasenia);
}