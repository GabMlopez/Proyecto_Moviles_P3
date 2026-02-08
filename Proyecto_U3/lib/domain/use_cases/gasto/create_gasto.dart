import '../../entities/gasto.dart';
import '../../repository/gasto_repository.dart';

class CreateGasto{
  final GastoRepository repo;

  CreateGasto(this.repo);

  Future<void> call(Gasto gasto_actualizado) async {
    return repo.addGasto(gasto_actualizado);
  }
}