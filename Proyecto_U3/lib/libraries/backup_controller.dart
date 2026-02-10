import 'package:get_it/get_it.dart';

import '../data/datasources/remote/ingreso_remote_datasource.dart';
import '../data/datasources/remote/gasto_remote_datasource.dart';
import '../data/datasources/local/ingreso_local_datasource.dart';
import '../data/datasources/local/gasto_local_datasource.dart';
import '../domain/entities/gasto.dart';
import '../domain/entities/ingreso.dart';
import 'sqlite_database.dart';

class BackupController {


    Future<bool> backupIngresos(int idUsuario) async
    {
      final _ingresoRemoto = GetIt.I<IngresoRemoteDataSource>();
      final _ingresoLocal = IngresoLocalDatasource();
      //Limpia la base de datos local
      try{
        await _ingresoLocal.wipeData();
        //Obtiene los últimos 100 registros de la base de datos
        List<Ingreso> ingresos = await _ingresoRemoto.getIngresosForBackup(idUsuario);
        for(Ingreso ingreso in ingresos)
        {
          await _ingresoLocal.addIngreso(ingreso);
        }
        print("Respaldo de Ingresos");
        return true;
      }
      catch(e)
      {
        print("Respaldo fallido");
        return false;
      }
    }

    Future<bool> backupGastos(int idUsuario) async
    {
      final _gastoRemoto = GetIt.I<GastoRemoteDatasource>();
      final _gastoLocal = GastoLocalDatasource();
      //Limpia la base de datos local
      try{
        await _gastoLocal.wipeData();
        //Obtiene los últimos 100 registros de la base de
        List<Gasto> gastos = await _gastoRemoto.getGastosForBackup(idUsuario);
        for(Gasto gasto in gastos)
        {
          await _gastoLocal.addGasto(gasto);
        }
        print("Respaldo de Gastos");
        return true;
      }
      catch(e)
      {
        print("Respaldo fallido");
        return false;
      }
    }
}