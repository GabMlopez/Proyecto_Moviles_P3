import '../entities/ingreso.dart';

abstract class IngresoRepository {
  Future<List<Ingreso>> getAllIngresos(int id);
  Future<Ingreso> getIngresoById(int id);
  Future<void> addIngreso(Ingreso ingreso);
  Future<void> updateIngreso(Ingreso ingreso);
  Future<void> deleteIngreso(int idI);
}