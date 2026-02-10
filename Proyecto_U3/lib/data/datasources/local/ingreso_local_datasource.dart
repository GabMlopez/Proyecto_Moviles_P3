import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import '../../../libraries/sqlite_database.dart';
import '../../../../domain/entities/ingreso.dart';

class IngresoLocalDatasource {
  final SqliteDatabase _dbHelper = SqliteDatabase();
  static const table = "ingreso";

  Future<List<Ingreso>> getAllIngresos(int idUsuario) async {
    try {
      final db = await _dbHelper.dbConnect();
      final data = await db.query(table,
          where: "idusuario = ?", whereArgs: [idUsuario]);
      await db.close();
      print(data);
      return data.map((e) => Ingreso.fromJson(e)).toList();
    }
    catch (e) {
      rethrow;
    }
  }

  /*
  Future<Map<String, dynamic>> getIngresosPorMes(int idUsuario, int mes, int anio) async {

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
  }*/


  Future<Ingreso> getIngresoById(int idIngreso) async {
    try {
      final db = await _dbHelper.dbConnect();
      final data = await db.query(table,
          where: "idingreso = ?", whereArgs: [idIngreso]);
      await db.close();
      return Ingreso.fromJson(data.first);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addIngreso(Ingreso ingreso) async {
    try {
      final db = await _dbHelper.dbConnect();
      await db.insert(table,
          {
            "idusuario": ingreso.idusuario,
            "fecha": ingreso.fecha.toIso8601String().substring(0, 10),
            "descripcion": ingreso.descripcion,
            "estado": ingreso.estado,
            "valor": ingreso.valor,
            "medio_de_pago": ingreso.medioDePago,
            "fuente_beneficiario": ingreso.fuenteBeneficiario,
          },
          conflictAlgorithm: ConflictAlgorithm.replace
      );
      print("Ingreso agregado");
      await db.close();
    } catch (e) {
      throw Exception('Error al agregar ingreso');
    }
  }

  Future<void> updateIngreso(Ingreso ingreso) async {
    try {
      final db = await _dbHelper.dbConnect();
      await db.update(table,
          {
            "idusuario": ingreso.idusuario,
            "fecha": ingreso.fecha.toIso8601String().substring(0, 10),
            "descripcion": ingreso.descripcion,
            "estado": ingreso.estado,
            "valor": ingreso.valor,
            "medio_de_pago": ingreso.medioDePago,
            "fuente_beneficiario": ingreso.fuenteBeneficiario
          }, where: "idingreso = ?", whereArgs: [ingreso.idingreso]
      );
      print("Ingreso actualizado");
      await db.close();
    } catch (e) {
      throw Exception('Error al actualizar ingreso');
    }
  }

  Future<void> deleteIngreso(int idIngreso) async {
    try {
      final db = await _dbHelper.dbConnect();
      await db.delete(table, where: "idingreso = ?", whereArgs: [idIngreso]);
      print("Ingreso eliminado");
      await db.close();
    } catch (e) {
      throw Exception('Error al eliminar ingreso');
    }
  }

  Future<void> wipeData() async {
    try {
      final db = await _dbHelper.dbConnect();
      await db.delete(table);
      print("Ingreso eliminado");
      await db.close();
    } catch (e) {
      throw Exception('Error al vaciar ingresos');
    }
  }
}