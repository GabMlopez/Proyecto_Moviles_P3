import '../../entities/ingreso.dart';
import '../../repository/ingreso_repository.dart';

class UpdateIngreso{
  final IngresoRepository repo;

  UpdateIngreso(this.repo);

  Future<void> call(Ingreso ingreso_actualizado) async {
    return repo.updateIngreso(ingreso_actualizado);
  }
}