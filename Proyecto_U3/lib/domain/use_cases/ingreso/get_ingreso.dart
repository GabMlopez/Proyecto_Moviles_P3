import '../../entities/ingreso.dart';
import '../../repository/ingreso_repository.dart';

class GetIngreso{
final IngresoRepository repo;

GetIngreso(this.repo);

Future<Ingreso> call(int id) async {
  return repo.getIngresoById(id);
}
}