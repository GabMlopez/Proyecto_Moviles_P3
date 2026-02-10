import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import '../../../libraries/sqlite_database.dart';
import '../../../../domain/entities/gasto.dart';

class GastoLocalDatasource {
  final SqliteDatabase _dbHelper = SqliteDatabase();
  static const table = "gasto";

  Future<List<Gasto>> getAllGastos(int idUsuario) async {
    try {
      final db = await _dbHelper.dbConnect();
      final data = await db.query(table,
          where: "idusuario = ?", whereArgs: [idUsuario]);
      await db.close();
      return data.map((e) => Gasto.fromJson(e)).toList();
    }
    catch (e) {
      rethrow;
    }
  }

  /*
  Future<Map<String, dynamic>> getGastosPorMes(int idUsuario, int mes, int anio) async {

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
  }*/


  Future<Gasto> getGastoById(int idGasto) async {
    try {
      final db = await _dbHelper.dbConnect();
      final data = await db.query(table,
          where: "idgasto = ?", whereArgs: [idGasto]);
      await db.close();
      return Gasto.fromJson(data.first);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addGasto(Gasto gasto) async {
    try {
      final db = await _dbHelper.dbConnect();
      await db.insert(table,
          {
            "idusuario": gasto.idUsuario,
            "fecha": gasto.fecha.toIso8601String().substring(0, 10),
            "descripcion": gasto.descripcion,
            "estado": gasto.estado,
            "valor": gasto.valor,
            "medio_de_pago": gasto.medioDePago,
            "fuente_beneficiario": gasto.acreedorCobrador,
          },
          conflictAlgorithm: ConflictAlgorithm.replace
      );
      print("Gasto agregado");
      await db.close();
    } catch (e) {
      throw Exception('Error al agregar gasto');
    }
  }

  Future<void> updateGasto(Gasto gasto) async {
    try {
      final db = await _dbHelper.dbConnect();
      await db.update(table,
          {
            "idusuario": gasto.idUsuario,
            "fecha": gasto.fecha.toIso8601String().substring(0, 10),
            "descripcion": gasto.descripcion,
            "estado": gasto.estado,
            "valor": gasto.valor,
            "medio_de_pago": gasto.medioDePago,
            "fuente_beneficiario": gasto.acreedorCobrador
          }, where: "idgasto = ?", whereArgs: [gasto.idGasto]
      );
      print("Gasto actualizado");
      await db.close();
    } catch (e) {
      throw Exception('Error al actualizar gasto');
    }
  }

  Future<void> deleteGasto(int idGasto) async {
    try {
      final db = await _dbHelper.dbConnect();
      await db.delete(table, where: "idgasto = ?", whereArgs: [idGasto]);
      print("Gasto eliminado");
      await db.close();
    } catch (e) {
      throw Exception('Error al eliminar gasto');
    }
  }
  Future<void> wipeData() async {
    try {
      final db = await _dbHelper.dbConnect();
      await db.delete(table);
      print("Gastos vaciados");
      await db.close();
    } catch (e) {
      throw Exception('Error al vaciar gastos');
    }
  }
}