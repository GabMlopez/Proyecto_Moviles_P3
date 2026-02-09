import '../../domain/repository/auth_repository.dart';
import '/data/datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> loginWithGoogle(String idToken, String contrasenia) {
    return remoteDataSource.loginWithGoogle(idToken,contrasenia);
  }

  @override
  Future<Map<String, dynamic>> loginNormal(String correo, String contrasenia) {
    return remoteDataSource.loginNormal(correo, contrasenia);
  }

  @override
  Future<Map<String, dynamic>?> buscarUsuarioPorCorreo(String correo){
    return remoteDataSource.buscarUsuarioPorCorreo(correo);
  }
}