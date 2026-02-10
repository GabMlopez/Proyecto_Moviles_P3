abstract class AuthRepository {
  Future<Map<String, dynamic>> loginWithGoogle(String idToken, String contrasenia);
  Future<Map<String, dynamic>> loginWithFacebook(String accessToken);
  Future<Map<String, dynamic>> loginNormal(String correo, String contrasenia);
  Future<Map<String, dynamic>?> buscarUsuarioPorCorreo(String correo);
}
