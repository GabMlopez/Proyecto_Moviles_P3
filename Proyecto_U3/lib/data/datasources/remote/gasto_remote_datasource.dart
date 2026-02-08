import 'package:dio/dio.dart';
import '../../../../domain/entities/gasto.dart';

class GastoRemoteDatasource {
  final Dio dio;
  final String baseUrl;

  GastoRemoteDatasource({required this.dio, required this.baseUrl});

  Future<List<Gasto>> getAllGastos(int idUsuario) async {
    try {
      late String url = baseUrl + '/gastos/user/$idUsuario';
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final gastoResponse = GastoResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        return gastoResponse.gastos;
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Respuesta servidor: ${e.response?.statusCode} - ${e.response?.data}');
      }
      throw Exception('Error de red: ${e.message}');
    } catch (e) {
      print('Error inesperado: $e');
      rethrow;
    }
  }

  Future<Gasto> getGastoById(int idGasto) async {
    try {
      late String url = baseUrl + '/gastos/$idGasto';
      final response = await dio.get(
        url,
      );

      if (response.statusCode == 200) {
        final gastoResponse =
        GastoResponse.fromJson(response.data as Map<String, dynamic>);
        if (gastoResponse.gastos.isEmpty) {
          throw Exception('Gasto no encontrado');
        }
        return gastoResponse.gastos.first;
      } else {
        throw Exception('Error al obtener gasto: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  Future<void> addGasto(Gasto gasto) async {
    try {
      late String url = baseUrl + '/gastos';
      final response = await dio.post(
        url,
        data: gasto.toJson(),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Error al crear gasto');
      }
    } on DioException catch (e) {
      throw Exception('Error al crear: ${e.response?.data ?? e.message}');
    }
  }

  Future<void> updateGasto(Gasto gasto) async {
    try {
      late String url = baseUrl + '/gastos/${gasto.idGasto}';
      final response = await dio.put(
        url,
        data: gasto.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar gasto');
      }
    } on DioException catch (e) {
      throw Exception('Error al actualizar: ${e.response?.data ?? e.message}');
    }
  }

  Future<void> deleteGasto(int idGasto) async {
    try {
      late String url = baseUrl + '/gastos/$idGasto';
      final response = await dio.delete(
        url
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar gasto');
      }
    } on DioException catch (e) {
      throw Exception('Error al eliminar: ${e.response?.data ?? e.message}');
    }
  }
}