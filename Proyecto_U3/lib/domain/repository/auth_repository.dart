abstract class AuthRepository {
  Future<Map<String, dynamic>> loginWithGoogle(String idToken, String contrasenia);

}