import 'package:dio/dio.dart';
import '../../../../domain/entities/ingreso.dart';
import '../local/ingreso_local_datasource.dart';

class IngresoRemoteDataSource {
  final Dio dio;
  final String baseUrl;
  final IngresoLocalDatasource _ingresoLocal = IngresoLocalDatasource();



  IngresoRemoteDataSource({required this.dio, required this.baseUrl});

  Future<List<Ingreso>> getAllIngresos(int idUsuario) async {
    try {
      late String url = baseUrl + '/ingresos/user/$idUsuario';
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final ingresoResponse = IngresoResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        return ingresoResponse.ingresos;
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Respuesta servidor: ${e.response?.statusCode} - ${e.response?.data}');
      }
      return await _ingresoLocal.getAllIngresos(idUsuario);
    } catch (e) {
      print('Error inesperado: $e');
      rethrow;
    }
  }

  Future<List<Ingreso>> getIngresosForBackup(int idUsuario) async {
    try {
      late String url = baseUrl + '/ingresos/user/$idUsuario?limite=100';
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final ingresoResponse = IngresoResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        return ingresoResponse.ingresos;
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

  Future<Map<String, dynamic>> getIngresosPorMes(int idUsuario, int mes, int anio) async {
    try {
      late String url = baseUrl + '/ingresos/user/$idUsuario/mes';
      final response = await dio.get(
        url,
          data: {
            'mes': mes,
            'anio': anio,
          });
      if (response.statusCode == 200) {
        final ingresosMensuales = response.data as Map<String, dynamic>;
        return ingresosMensuales;
      } else {
        throw Exception('Error al obtener: ${response.statusCode}');
      }
    }
    on DioException catch(e)
    {
      throw Exception('Error de red: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getIngresosMensuales(int idUsuario) async {
    try {
      late String url = baseUrl + '/ingresos/user/$idUsuario/mensual';
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final ingresosMensuales = response.data as Map<String, dynamic>;
        return ingresosMensuales;
      } else {
        throw Exception('Error al obtener: ${response.statusCode}');
      }
    }
    on DioException catch(e)
    {
      throw Exception('Error de red: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getIngresosSemanales(int idUsuario) async {
    try {
      late String url = baseUrl + '/ingresos/user/$idUsuario/semanal';
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final ingresosSemanales = response.data as Map<String, dynamic>;
        return ingresosSemanales;
      } else {
        throw Exception('Error al obtener: ${response.statusCode}');
      }
    }
    on DioException catch(e)
    {
      throw Exception('Error de red: ${e.message}');
    }
  }


  Future<Ingreso> getIngresoById(int idIngreso) async {
    try {
      late String url = baseUrl + '/ingresos/$idIngreso';
      final response = await dio.get(
        url,
      );

      if (response.statusCode == 200) {
        final ingresoResponse =
        IngresoResponse.fromJson(response.data as Map<String, dynamic>);
        if (ingresoResponse.ingresos.isEmpty) {
          throw Exception('Ingreso no encontrado');
        }
        return ingresoResponse.ingresos.first;
      } else {
        throw Exception('Error al obtener ingreso: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  Future<void> addIngreso(Ingreso ingreso) async {
    try {
      late String url = baseUrl + '/ingresos';
      final response = await dio.post(
        url,
        data: ingreso.toJson(),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Error al crear ingreso');
      }
    } on DioException catch (e) {
      await _ingresoLocal.addIngreso(ingreso);
    }
  }

  Future<void> updateIngreso(Ingreso ingreso) async {
    try {
      late String url = baseUrl + '/ingresos/${ingreso.idingreso}';
      final response = await dio.put(
        url,
        data: ingreso.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar ingreso');
      }
    } on DioException catch (e) {
      await _ingresoLocal.updateIngreso(ingreso);
    }
  }

  Future<void> deleteIngreso(int idIngreso) async {
    try {
      late String url = baseUrl + '/ingresos/$idIngreso';
      final response = await dio.delete(
        url
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar ingreso');
      }
    } on DioException catch (e) {
      await _ingresoLocal.deleteIngreso(idIngreso);
    }
  }
}