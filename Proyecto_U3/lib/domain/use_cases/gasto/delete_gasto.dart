import '../../repository/gasto_repository.dart';

class DeleteGasto{
  final GastoRepository repo;

  DeleteGasto(this.repo);

  Future<void> call(int idI) async {
    return repo.deleteGasto(idI);
  }
}