import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_u3/presentation/layout/add_ingreso_layout.dart';
import 'package:proyecto_u3/presentation/layout/test_layout.dart';
import 'package:proyecto_u3/presentation/organism/bottom_nav.dart';

import '../domain/entities/ingreso.dart';
import '../presentation/layout/editar_ingreso_layout.dart';
import '../presentation/layout/movimientos_layout.dart';
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
              builder: (context, state) => const ResumenLayout(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tests',
              name: 'tests',
              builder: (context, state) => MovimientosLayout(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: 'add',
                  builder: (context, state) {
                    int idUsuario = state.extra as int;
                    return AddIngresoLayout(idUsuario: idUsuario);
                  },
                ),
                GoRoute(
                  path: 'edit',
                  name: 'edit',
                  builder: (context, state) {
                    Ingreso ingreso = state.extra as Ingreso;
                    return EditarIngresoLayout(datosIngreso: ingreso);
                  },
                ),

              ]
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
              builder: (context, state) => const TestLayout(),
            ),
          ],
        ),

      ],
    ),

  ],
);