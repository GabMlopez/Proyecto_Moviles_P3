import '../../entities/gasto.dart';
import '../../repository/gasto_repository.dart';

class GetGasto{
  final GastoRepository repo;

  GetGasto(this.repo);

  Future<List<Gasto>> call(int id) async {
    return repo.getAllGastos(id);
  }
}