import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'ingresos_layout.dart';
import '../molecule/ingreso_data_row.dart';
import '../../domain/entities/ingreso.dart';
import '../../domain/repository/ingreso_repository.dart';
import '../molecule/mensaje_snackbar.dart';
import 'gastos_layout.dart';
class MovimientosLayout extends StatefulWidget {
  final int? tab;
  const MovimientosLayout({super.key, this.tab});

  @override
  State<MovimientosLayout> createState() => _MovimientosLayoutState();
}

class _MovimientosLayoutState extends State<MovimientosLayout> {
  int idUsuario=1;//Placeholder esto se debe quitar luego
  /* Como parámetros están los ingresos, las columnas y el repositorio
  * */
  List<Ingreso> ingresos = [];
  final columnas = ["Fecha", "Motivo", "Origen", "Método de Pago", "Valor", "Estado", "Acciones"];
  final _tabs = ["Ingresos", "Gastos"];
  final _repository = GetIt.I<IngresoRepository>();


  /* Esta función muestra un mensaje de confirmación primero
  * Si acepta, elimina el ingreso y muestra un mensaje de éxito
   */
  Future<void> _eliminarIngreso(int idI) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('¿Eliminar?'),
            content: Text('¿Realmente quieres eliminar este ingreso?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar')),
              TextButton(onPressed: () {
                  Navigator.pop(context, true);
                  _repository.deleteIngreso(idI);
                  mostrarMensaje(
                      mensaje: 'Ingreso eliminado correctamente',
                      tipo: 'info',
                      context: context
                  );
                },
                  child: const Text(
                      'Eliminar', style: TextStyle(color: Colors.red))),
            ],
          ),
    );
  }

  /*Esta función construye la tabla con los ingresos
  * Recibe una lista de ingresos y convierte cada ingreso en una fila
  * Devuelve un widget de tipo DataTable
  * */
  Widget IngresosDataTable(List<Ingreso> data){

    return SingleChildScrollView(
      //El widget es Scrolleable tanto vertical como horizontalmente
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: DataTable(
          columnSpacing: 30,
            dataRowMaxHeight: 70,
            sortAscending: true,
            sortColumnIndex: 0,
            columns: crearColumnas(columnas),
            rows: crearFilas(data)
        ),
      ),
    );
  }

  //Esta función crea las columnas de la tabla
  //Lo hace en base a las columnas definidas al inicio
  List<DataColumn> crearColumnas(List<String> columnas)
  {
    List<DataColumn> columnasTabla = columnas.map((String columna)=>DataColumn(label: Text(columna))).toList();
    return columnasTabla;
  }

  //Esta función crea las filas de la tabla
  //Devuleve widgets DataRow
  List<DataRow> crearFilas(List<Ingreso> data)
  {
    return data.map((Ingreso ingreso)=>ingresoDataRow(ingreso,
        () => context.go('/movimientos/ingresos/edit', extra: ingreso),
        () {
          _eliminarIngreso(ingreso.idingreso);
        }
    )).toList();
  }




  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.tab ?? 0,
      length: _tabs.length,
      child: SafeArea(child: Scaffold(
        appBar: AppBar(
          title: const Text("Movimientos"),
          centerTitle: true,
          bottom: TabBar(tabs: [
            Tab(text: _tabs[0], icon: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.attach_money),
              Icon(Icons.keyboard_double_arrow_up_rounded)
            ],),),
            Tab(text: _tabs[1], icon: Row(mainAxisSize: MainAxisSize.min, children:[
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


