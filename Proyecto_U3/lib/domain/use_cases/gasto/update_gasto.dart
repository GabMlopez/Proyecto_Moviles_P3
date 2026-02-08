import '../../entities/gasto.dart';
import '../../repository/gasto_repository.dart';

class UpdateGasto{
  final GastoRepository repo;

  UpdateGasto(this.repo);

  Future<void> call(Gasto gasto_actualizado) async {
    return repo.updateGasto(gasto_actualizado);
  }
}