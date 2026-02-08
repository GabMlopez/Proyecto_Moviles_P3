import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/datasources/remote/ingreso_remote_datasource.dart';
import '../data/repositories/auth_repository_datasource.dart';
import '../data/repositories/ingreso_repository_datasource.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/repository/ingreso_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  //cambiar segun el ip del computador de la red
    final String baseUrl = dotenv.env['BASE_URL'] ??
        const String.fromEnvironment('BASE_URL', defaultValue: '');

    if (baseUrl.isEmpty) {
      throw Exception('Falta BASE URL');
    }
    //Config de DIO
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 12),
        contentType: Headers.jsonContentType,
      ),
    );

    //Config de ingreso
    getIt.registerSingleton<Dio>(dio);
    getIt.registerLazySingleton<IngresoRemoteDataSource>(
          () => IngresoRemoteDataSource(dio: dio, baseUrl: baseUrl),
    );

    getIt.registerLazySingleton<IngresoRepository>(
          () => IngresoRepositoryImpl(
        remoteDataSource: getIt<IngresoRemoteDataSource>(),
      ),
    );

}