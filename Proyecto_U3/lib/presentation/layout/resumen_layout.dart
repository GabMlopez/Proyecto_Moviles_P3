import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/gasto.dart';
import '../../domain/entities/ingreso.dart';
import '../../domain/repository/gasto_repository.dart';
import '../../domain/repository/ingreso_repository.dart';

import '../global_manager/user_provider.dart';
import '../organism/header_resumen.dart';
import '../organism/balance_card.dart';
import '../organism/trend_card.dart';
import '../organism/spending_card.dart';
import '../organism/last_movements_card.dart';

class ResumenLayout extends StatefulWidget {
  const ResumenLayout({super.key});

  @override
  State<ResumenLayout> createState() => _ResumenLayoutState();
}

class _ResumenLayoutState extends State<ResumenLayout> {
  int? idUsuario;
  final _ingresoRepository = GetIt.I<IngresoRepository>();
  final _gastoRepository = GetIt.I<GastoRepository>();
  Map<String, dynamic> ingresos_semanales={};
  Map<String, dynamic> gastos_semanales={};

  List<Ingreso> ingresos = [];
  List<Gasto> gastos = [];
  double ingresosTotales = 0.0;
  double gastosTotales = 0.0;
  int mes_actual=2;
  int anio_actual=2026;
  bool _isLoading = false;


  void getDatos() async
  {
    setState(() {
      _isLoading = true;
    });
    final resultados = await Future.wait([
      _ingresoRepository.getIngresosMensuales(idUsuario!),
      _gastoRepository.getGastosMensuales(idUsuario!),
      _ingresoRepository.getIngresosSemanales(idUsuario!),
      _gastoRepository.getGastosSemanales(idUsuario!),
    ]);

    //Guarda los resultados semanales
    ingresos_semanales = resultados[2];
    gastos_semanales = resultados[3];

    //Recibe las listas y los totales
    Map<String, dynamic> data_ingresos= resultados[0];
    Map<String, dynamic> data_gastos= resultados[1];
    //Extrae gastos e ingresos y los pasa a objetos de dart
    List map_ingresos = data_ingresos["ingresos"];
    List map_gastos = data_gastos["gastos"];
    for(int i=0; i<map_ingresos.length; i++){
      ingresos.add(Ingreso.fromJson(map_ingresos[i]));
    }
    for(int i=0; i<map_gastos.length; i++){
      gastos.add(Gasto.fromJson(map_gastos[i]));
    }


    //Recibe los totales
    gastosTotales=(data_gastos["total"] as num).toDouble();
    ingresosTotales=(data_ingresos["total"] as num).toDouble();


    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    idUsuario=Provider.of<UserProvider>(context, listen: false).idUsuario ?? 1;
    getDatos();
  }


  @override
  Widget build(BuildContext context) {
    final int idUsuario = Provider.of<UserProvider>(context).idUsuario ?? 1;
    const bg = Color(0xFFF6F7FB);
    return RefreshIndicator(
      onRefresh: () async {
        getDatos();
      },
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: (_isLoading) ? Center(child: CircularProgressIndicator()) :
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: HeaderResumen()),
              SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverToBoxAdapter(child: BalanceCard(
                ingresosTotales: ingresosTotales,
                gastosTotales: gastosTotales,
              )),
              SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverToBoxAdapter(child: TrendCard(
                data_gastos: gastos_semanales,
                data_ingresos: ingresos_semanales,
              )),
              SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverToBoxAdapter(child: LastMovementsCard()),
              SliverToBoxAdapter(child: SizedBox(height: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
