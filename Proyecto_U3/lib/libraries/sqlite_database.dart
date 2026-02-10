import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class SqliteDatabase {
  late var path;
  Future<Database> dbConnect() async{
    //Obtiene la direccion de la BD
    final databasePath = await getDatabasesPath();
    //Establece una direccion para guardar la BD
    path = join(databasePath,"gradesDb");
    return openDatabase(
        path,
        onCreate: (db,version) async{
          //Crear tablas
          //Tabla usuario
          await db.execute("CREATE TABLE usuario(idusuario INTEGER PRIMARY KEY, nombre_apellido TEXT NOT NULL,correo TEXT NOT NULL, contrasenia TEXT NULL, token TEXT NULL)");
          //Tabla gasto
          await db.execute("CREATE TABLE gasto(idgasto INTEGER PRIMARY KEY, idusuario INTEGER NOT NULL,fecha TEXT NOT NULL, descripcion TEXT NOT NULL, acreedor_cobrador TEXT NOT NULL, medio_de_pago TEXT NOT NULL, valor DECIMAL(9,2) null, estado TEXT NOT NULL) ");
          //Tabla ingreso
          await db.execute("CREATE TABLE ingreso(idingreso INTEGER PRIMARY KEY, idusuario INTEGER NOT NULL,fecha TEXT NOT NULL, descripcion TEXT NOT NULL, fuente_beneficiario TEXT NOT NULL, medio_de_pago TEXT NOT NULL, estado TEXT NOT NULL, valor DECIMAL(9,2) null) ");
          //Tabla cuenta
          await db.execute("CREATE TABLE cuenta(idcuenta INTEGER PRIMARY KEY, idusuario INTEGER NOT NULL,intentos_fallidos INTEGER NOT NULL, limite_gastos_mes DECIMAL(9,2) null, limite_gastos_semana DECIMAL(9,2) null) ");
          //Tabla notificacion
          await db.execute("CREATE TABLE notificacion(idnotificacion INTEGER PRIMARY KEY, idusuario INTEGER NOT NULL, tipo_notificacion TEXT NOT NULL, titulo_notificacion TEXT NOT NULL, cuerpo_notificacion TEXT NOT NULL, tiempo_notificacion TEXT NOT NULL, notificacion_leida INTEGER NOT NULL, idgasto INTEGER NULL) ");
          //Tabla recordatorio
          await db.execute("CREATE TABLE recordatorio(idrecordatorio INTEGER PRIMARY KEY, idusuario INTEGER NOT NULL, fecha_recordatorio TEXT NOT NULL, estado_recordatorio TEXT NOT NULL, idgasto INTEGER NULL)");
        },
        version: 1
    );
  }
}