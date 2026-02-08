
import '../../domain/repository/ingreso_repository.dart';
import '../../domain/entities/ingreso.dart';
import '../datasources/remote/ingreso_remote_datasource.dart';

class IngresoRepositoryImpl implements IngresoRepository {
  final IngresoRemoteDataSource remoteDataSource;

  IngresoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Ingreso>> getAllIngresos(int id) async {
    try {
      return await remoteDataSource.getAllIngresos(id);
    } catch (e) {
      rethrow; 
    }
  }

  Future<Ingreso> getIngresoById(int idIngreso) async {
    try {
      return await remoteDataSource.getIngresoById(idIngreso);
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<void> addIngreso(Ingreso ingreso) async {
    try{
      return await remoteDataSource.addIngreso(ingreso);
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<void> updateIngreso(Ingreso ingreso) async {
    try{
      await remoteDataSource.updateIngreso(ingreso);
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<void> deleteIngreso(int iding) async {
    try{
      await remoteDataSource.deleteIngreso(iding);
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getIngresosMensuales(int id) async{
    try{
      return await remoteDataSource.getIngresosMensuales(id);
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getIngresosPorMes(int id) async{
    try{
      return await remoteDataSource.getIngresosPorMes(id, 1, 2026);
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getIngresosSemanales(int id) async{
    try{
      return await remoteDataSource.getIngresosSemanales(id);
    }catch(e){
      rethrow;
    }
    throw UnimplementedError();
  }

}
