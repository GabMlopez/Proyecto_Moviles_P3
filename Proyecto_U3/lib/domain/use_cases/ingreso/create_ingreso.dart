import '../../entities/ingreso.dart';
import '../../repository/ingreso_repository.dart';

class CreateIngreso{
  final IngresoRepository repo;

  CreateIngreso(this.repo);

  Future<void> call(Ingreso ingreso_actualizado) async {
    return repo.addIngreso(ingreso_actualizado);
  }
}