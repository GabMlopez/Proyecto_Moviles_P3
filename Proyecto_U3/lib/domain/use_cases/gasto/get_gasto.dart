import '../../entities/gasto.dart';
import '../../repository/gasto_repository.dart';

class GetGasto{
final GastoRepository repo;

GetGasto(this.repo);

Future<Gasto> call(int id) async {
  return repo.getGastoById(id);
}
}