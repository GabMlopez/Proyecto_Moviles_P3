import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../presentation/molecule/gasto_data_row.dart';
import '../../domain/entities/gasto.dart';
import '../../domain/repository/gasto_repository.dart';
import '../global_manager/user_provider.dart';
import '../molecule/mensaje_snackbar.dart';
class GastosLayout extends StatefulWidget {
  const GastosLayout({super.key});

  @override
  State<GastosLayout> createState() => _GastosLayoutState();
}

class _GastosLayoutState extends State<GastosLayout> {
  int idUsuario=1;//Placeholder esto se debe quitar luego
  /* Como parámetros están los gastos, las columnas y el repositorio
  * */
  List<Gasto> gastos = [];
  final columnas = ["Fecha", "Motivo", "Destinatario", "Método de Pago", "Valor", "Estado", " "];
  final _repository = GetIt.I<GastoRepository>();


  Future<void> _eliminarGasto(int idI)async {
    try{
      await _repository.deleteGasto(idI);
      setState(() {

      });
      mostrarMensaje(
          mensaje: 'Gasto eliminado correctamente',
          tipo: 'info',
          context: context
      );
    }
    catch(e){
      mostrarMensaje(
          mensaje: 'Error al eliminar el gasto',
          tipo: 'error',
          context: context
      );
    }
  }
  /* Esta función muestra un mensaje de confirmación primero
  * Si acepta, elimina el gasto y muestra un mensaje de éxito
   */
  Future<void> _confirmarEliminacion(int idI) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('¿Eliminar?'),
            content: Text('¿Realmente quieres eliminar este gasto?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')),
              TextButton(onPressed: () {
                  _eliminarGasto(idI);
                  Navigator.of(context).pop();
                },
                  child: const Text(
                      'Eliminar', style: TextStyle(color: Colors.red))),
            ],
          ),
    );
  }

  /*Esta función construye la tabla con los gastos
  * Recibe una lista de gastos y convierte cada gasto en una fila
  * Devuelve un widget de tipo DataTable
  * */
  Widget GastosDataTable(List<Gasto> data){

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
  List<DataRow> crearFilas(List<Gasto> data)
  {
    return data.map((Gasto gasto)=>GastoDataRow(gasto,
        () => context.go('/movimientos/gastos/edit', extra: gasto),
        () {
          _confirmarEliminacion(gasto.idGasto);
        }
    )).toList();
  }




  @override
  Widget build(BuildContext context) {
    final int idUsuario = Provider.of<UserProvider>(context).idUsuario ?? 1;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                  onPressed: (){
                context.go('/movimientos/gastos/add', extra: idUsuario);
              }, child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add),
                  Text("Agregar Gasto")
                ],
              )),
              SizedBox(
                height: 20,
              ),
              FutureBuilder(future: _repository.getAllGastos(idUsuario),
              builder: (context, snapshot){
                if (snapshot.hasError) {
                  return Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: ${snapshot.error}'),
                      ElevatedButton(onPressed: () {
                        setState(() {});
                      }, child: Text('Reintentar'))
                    ],
                  ));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('Aún no ha registrado ningún gasto'));
                }
                if(snapshot.hasData) {
                  gastos = snapshot.data!;
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    margin: EdgeInsets.all(10),
                    child: GastosDataTable(gastos),
                  );
                }
                else{
                  return Center(child: Text('Aún no ha registrado ningún gasto'));
                }
              }
        
                ),
            ],
          ),
      ),
    );
}}


