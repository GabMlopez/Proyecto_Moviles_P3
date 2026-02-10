import 'package:dio/dio.dart';
import '../../../../domain/entities/gasto.dart';
import '../local/gasto_local_datasource.dart';

class GastoRemoteDatasource {
  final Dio dio;
  final String baseUrl;
  final GastoLocalDatasource _gastoLocal = GastoLocalDatasource();


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
        return await _gastoLocal.getAllGastos(idUsuario);
      }
      return await _gastoLocal.getAllGastos(idUsuario);
    } catch (e) {
      print('Error inesperado: $e');
      rethrow;
    }
  }

  Future<List<Gasto>> getGastosForBackup(int idUsuario) async {
    try {
      late String url = baseUrl + '/gastos/user/$idUsuario?limite=100';
      final response = await dio.get(
        url,
        data: {
          "limite":100
        }
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
      return await _gastoLocal.getGastoById(idGasto);
    }
  }

  Future<Map<String, dynamic>> getGastosPorMes(int idUsuario, int mes, int anio) async {
    try {
      late String url = baseUrl + '/gastos/user/$idUsuario/mes';
      final response = await dio.get(
          url,
          data: {
            'mes': mes,
            'anio': anio,
          });
      if (response.statusCode == 200) {
        final gastosMensuales = response.data as Map<String, dynamic>;
        return gastosMensuales;
      } else {
        throw Exception('Error al obtener: ${response.statusCode}');
      }
    }
    on DioException catch(e)
    {
      throw Exception('Error de red: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getGastosMensuales(int idUsuario) async {
    try {
      late String url = baseUrl + '/gastos/user/$idUsuario/mensual';
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final gastosMensuales = response.data as Map<String, dynamic>;
        return gastosMensuales;
      } else {
        throw Exception('Error al obtener: ${response.statusCode}');
      }
    }
    on DioException catch(e)
    {
      throw Exception('Error de red: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getGastosSemanales(int idUsuario) async {
    try {
      late String url = baseUrl + '/gastos/user/$idUsuario/semanal';
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final gastosSemanales = response.data as Map<String, dynamic>;
        return gastosSemanales;
      } else {
        throw Exception('Error al obtener: ${response.statusCode}');
      }
    }
    on DioException catch(e)
    {
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
      await _gastoLocal.addGasto(gasto);
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
      await _gastoLocal.updateGasto(gasto);
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
      await _gastoLocal.deleteGasto(idGasto);
    }
  }
}