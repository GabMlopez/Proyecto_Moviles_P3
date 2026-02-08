import '../../domain/repository/auth_repository.dart';
import '/data/datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> loginWithGoogle(String idToken) {
    return remoteDataSource.loginWithGoogle(idToken);
  }
}