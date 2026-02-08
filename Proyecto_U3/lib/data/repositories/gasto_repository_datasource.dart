
import '../../domain/repository/gasto_repository.dart';
import '../../domain/entities/gasto.dart';
import '../datasources/remote/gasto_remote_datasource.dart';

class GastoRepositoryImpl implements GastoRepository {
  final GastoRemoteDatasource remoteDataSource;

  GastoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Gasto>> getAllGastos(int id) async {
    try {
      return await remoteDataSource.getAllGastos(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<Gasto> getGastoById(int idGasto) async {
    try {
      return await remoteDataSource.getGastoById(idGasto);
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<void> addGasto(Gasto gasto) async {
    try{
      return await remoteDataSource.addGasto(gasto);
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<void> updateGasto(Gasto gasto) async {
    try{
      await remoteDataSource.updateGasto(gasto);
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<void> deleteGasto(int iding) async {
    try{
      await remoteDataSource.deleteGasto(iding);
    }catch(e){
      rethrow;
    }
  }
  @override
  Future<Map<String, dynamic>> getGastosMensuales(int id) async{
    try{
      return await remoteDataSource.getGastosMensuales(id);
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getGastosPorMes(int id) async{
    try{
      return await remoteDataSource.getGastosPorMes(id, 1, 2026);
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getGastosSemanales(int id) async{
    try{
      return await remoteDataSource.getGastosSemanales(id);
    }catch(e){
      rethrow;
    }
    throw UnimplementedError();
  }
}
