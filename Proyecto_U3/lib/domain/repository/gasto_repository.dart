import '../entities/gasto.dart';

abstract class GastoRepository {
  Future<List<Gasto>> getAllGastos(int id);
  Future<Gasto> getGastoById(int id);
  Future<void> addGasto(Gasto gasto);
  Future<void> updateGasto(Gasto gasto);
  Future<void> deleteGasto(int idG);
}