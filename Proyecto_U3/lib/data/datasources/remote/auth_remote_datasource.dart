import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> loginWithGoogle(String idToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    try {
      final response = await dio.post(
        '/auth/google',
        data: {'idToken': idToken},
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
}