
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> loginWithGoogle(String idToken, String contrasenia);
  Future<Map<String, dynamic>> loginNormal(String correo, String password);
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
}