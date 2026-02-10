import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'ingresos_layout.dart';
import 'gastos_layout.dart';
class MovimientosLayout extends StatefulWidget {
  final int? tab;
  const MovimientosLayout({super.key, this.tab});

  @override
  State<MovimientosLayout> createState() => _MovimientosLayoutState();
}

class _MovimientosLayoutState extends State<MovimientosLayout> {
  final _tabs = ["Ingresos", "Gastos"];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.tab ?? 0,
      length: _tabs.length,
      child: SafeArea(child: Scaffold(
        appBar: AppBar(
          title: const Text("Movimientos", style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),),
          backgroundColor: const Color(0xFFE3F2FD),
          centerTitle: true,

          bottom: TabBar(tabs: [
            Tab(child:  Row(mainAxisSize: MainAxisSize.min, children: [
              Text(_tabs[0], style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
              Icon(Icons.attach_money),
              Icon(Icons.keyboard_double_arrow_up_rounded)
            ],),),
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children:[
              Text(_tabs[1],style: TextStyle(
                fontWeight: FontWeight.bold
            ),),
              Icon(Icons.attach_money),
              Icon(Icons.keyboard_double_arrow_down_rounded)
            ]),),
          ]),
        ),
        body: TabBarView(children: [
          IngresosLayout(),
          GastosLayout(),
        ]))),
    );
}}


