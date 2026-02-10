import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:proyecto_u3/presentation/global_manager/user_provider.dart';
import './libraries/dio_controller.dart';
import './libraries/route_controller.dart';
import './libraries/backup_controller.dart';
import 'package:provider/provider.dart';
Future<void> main() async {
  await   dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tu App',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}