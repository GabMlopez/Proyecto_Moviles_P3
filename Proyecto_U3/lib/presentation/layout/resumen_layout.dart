import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/ingreso.dart';
import '../../domain/repository/ingreso_repository.dart';
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
  final _ingresoRepository = GetIt.I<IngresoRepository>();
  List<Ingreso> ingresos = [];
  double ingresosTotales = 0.0;
  double gastosTotales = 0.0;
  double saldoTotal = 0.0;
  bool _isLoading = false;


  void getIngresos() async
  {
    setState(() {
      _isLoading = true;
    });
    ingresos = await _ingresoRepository.getAllIngresos(1);
    calcularTotales();
    setState(() {
      _isLoading = false;
    });
  }

  void calcularTotales()
  {
    for(Ingreso ingreso in ingresos)
    {
      ingresosTotales += double.parse(ingreso.valor);
    }
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIngresos();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F7FB);

    return Scaffold(
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
            SliverToBoxAdapter(child: TrendCard()),
            SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverToBoxAdapter(child: SpendingCard()),
            SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverToBoxAdapter(child: LastMovementsCard()),
            SliverToBoxAdapter(child: SizedBox(height: 18)),
          ],
        ),
      ),
    );
  }
}
