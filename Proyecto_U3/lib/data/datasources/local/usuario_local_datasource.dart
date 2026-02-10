import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import '../../../libraries/sqlite_database.dart';
import 'package:bcrypt/bcrypt.dart';
class UsuarioLocalDatasource {
  final SqliteDatabase _dbHelper = SqliteDatabase();
  static const table = "usuario";
  Future<bool> loginNormal(String correo, String contrasenia) async {
    try {
      final db = await _dbHelper.dbConnect();
      final data = await db.query(table,
          where: "correo = ?", whereArgs: [correo]);
      await db.close();
      String correo_guardado = data.first["correo"] as String;
      String contrasenia_guardada = data.first["contrasenia"] as String;
      if (correo_guardado == correo && await BCrypt.checkpw(contrasenia, contrasenia_guardada)) {
        return true;
      } else {
        print("Credenciales invalidas");
        return false;
      }
    }
    catch (e) {
      print("Error en login");
      return false;
    }
  }

  Future<Map<String, dynamic>> obtenerUsuario() async
  {
    try{
      final db = await _dbHelper.dbConnect();
      final data = await db.query(table);
      return data.first;
    }
    catch(e)
    {
      throw Exception('Error al obtener');
    }
  }

  Future<Map<String, dynamic>> buscarUsuarioPorCorreo(String correo) async{
    try{
      final db = await _dbHelper.dbConnect();
      final data = await db.query(table,
          where: "correo = ?", whereArgs: [correo]);
      await db.close();
      return data.first;
    }
    catch(e)
    {
      throw Exception('Error al buscar');
    }
  }

  Future<void> addUsuario(Map<String, dynamic> usuario) async {
    try {
      final db = await _dbHelper.dbConnect();
      await db.insert(table,
          {
            "nombre_apellido": usuario["nombre_apellido"],
            "correo": usuario["correo"],
            "contrasenia": usuario["contrasenia"],
            },
          conflictAlgorithm: ConflictAlgorithm.replace
      );
      print("Usuario agregado");
      await db.close();
    } catch (e) {
      throw Exception('Error al agregar usuario');
    }
  }
}