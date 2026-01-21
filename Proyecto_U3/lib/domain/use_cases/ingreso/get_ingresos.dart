import '../../entities/ingreso.dart';
import '../../repository/ingreso_repository.dart';

class GetIngreso{
  final IngresoRepository repo;

  GetIngreso(this.repo);

  Future<List<Ingreso>> call(int id) async {
    return repo.getAllIngresos(id);
  }
}