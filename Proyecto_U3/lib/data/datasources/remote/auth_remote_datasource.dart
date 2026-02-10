
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> loginWithGoogle(String idToken, String contrasenia);
  Future<Map<String, dynamic>> loginNormal(String correo, String password);
  Future<Map<String, dynamic>?> buscarUsuarioPorCorreo(String correo);
  Future<Map<String, dynamic>> loginWithFacebook(String accessToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> loginWithGoogle(String idToken,String contrasenia) async {
    try {
      final response = await dio.post(
        '/google/login',
        data: {'idToken': idToken,
        'contrasenia':contrasenia},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      }

      throw Exception(
        response.data['error'] ?? 'Error inesperado en login con Google',
      );
    } on DioException catch (e) {
      final errorMsg = e.response?.data['error'] ?? e.message ?? 'Error de conexión';
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception('Error desconocido: $e');
    }
  }


  @override
  Future<Map<String, dynamic>> loginNormal(String correo, String contrasenia) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'correo': correo,
          'contrasenia': contrasenia,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Error de credenciales');
    }
  }

  Future<Map<String, dynamic>?> buscarUsuarioPorCorreo(String correo) async {
    try {
      final response = await dio.get('/user/$correo');
      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  @override
  Future<Map<String, dynamic>> loginWithFacebook(String accessToken) async {
    try {
      final response = await dio.post(
        '/auth/facebook',
        data: {'accessToken': accessToken},
      );
      return response.data;
    } on DioException catch (e) {
      // ESTA LÍNEA ES CLAVE: Imprime el error real del backend en tu consola
      print("DETALLE DEL FALLO EN BACKEND: ${e.response?.data}");
      throw Exception(e.response?.data['error'] ?? 'Error en login social');
    }
  }
}