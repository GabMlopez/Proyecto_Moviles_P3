import '../../repository/ingreso_repository.dart';

class DeleteIngreso{
  final IngresoRepository repo;

  DeleteIngreso(this.repo);

  Future<void> call(int idI) async {
    return repo.deleteIngreso(idI);
  }
}