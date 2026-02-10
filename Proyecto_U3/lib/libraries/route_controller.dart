import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/organism/bottom_nav.dart';
import '../domain/entities/gasto.dart';
import '../domain/entities/ingreso.dart';
import '../presentation/layout/add_gasto_layout.dart';
import '../presentation/layout/add_ingreso_layout.dart';
import '../presentation/layout/editar_gasto_layout.dart';
import '../presentation/layout/editar_ingreso_layout.dart';
import '../presentation/layout/login.dart';
import '../presentation/layout/movimientos_layout.dart';
import '../presentation/layout/resumen_layout.dart';//

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  debugLogDiagnostics: true,


  routes: [
    GoRoute(path: "/",
      redirect: (_, __) => "/home",),
    GoRoute(
      path: '/login',
      builder: (context, state) => const SimpleLoginScreen(),
    ),
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
              path: '/movimientos',
              name: 'movimientos',
              builder: (context, state) => MovimientosLayout(),
              routes: [
                GoRoute(
                  path: 'ingresos',
                  name: 'ver ingresos',
                  builder: (context, state) {
                    return MovimientosLayout(tab: 0);
                  },
                  routes: [
                    GoRoute(
                      path: 'add',
                      name: 'agregar ingresos',
                      builder: (context, state) {
                        return AddIngresoLayout();
                      },
                    ),
                    GoRoute(
                      path: 'edit',
                      name: 'Editar ingresos',
                      builder: (context, state) {
                        Ingreso ingreso = state.extra as Ingreso;
                        return EditarIngresoLayout(datosIngreso: ingreso);
                      },
                    )
                  ]
                ),
                GoRoute(
                  path: 'gastos',
                  name: 'Agregar Gastos',
                  builder: (context, state) {
                  return MovimientosLayout(tab: 1);
                  },
                  routes: [
                    GoRoute(
                      path: 'add',
                      name: 'agregar Gastos',
                      builder: (context, state) {
                        return AddGastoLayout();
                      },
                    ),
                    GoRoute(
                      path: 'edit',
                      name: 'Editar Gastos',
                      builder: (context, state) {
                        Gasto gasto = state.extra as Gasto;
                        return EditarGastoLayout(datosGasto: gasto);
                      },
                    )
                  ]
                ),
              ]
        )]),
        //Cambiar cuando las paginas esten listas
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