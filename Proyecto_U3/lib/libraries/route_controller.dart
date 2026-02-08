import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_u3/presentation/layout/test_layout.dart';
import 'package:proyecto_u3/presentation/organism/bottom_nav.dart';
import '../presentation/layout/login.dart';
import '../presentation/layout/resumen_layout.dart';//

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  debugLogDiagnostics: true,

  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNav(
              navigationShell: navigationShell),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => ResumenLayout(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tests',
              name: 'tests',
              builder: (context, state) => const TestLayout(),
            ),
          ],
        ),
        //Cambiar cuando las paginas esten listas
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tests1',
              name: 'tests1',
              builder: (context, state) => const TestLayout(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tests2',
              name: 'tests2',
              builder: (context, state) => const SimpleLoginScreen(),
            ),
          ],
        ),

      ],
    ),

  ],
);