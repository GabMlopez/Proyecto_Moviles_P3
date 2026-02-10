import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../presentation/molecule/ingreso_data_row.dart';
import '../../domain/entities/ingreso.dart';
import '../../domain/repository/ingreso_repository.dart';
import '../global_manager/user_provider.dart';
import '../molecule/mensaje_snackbar.dart';
class IngresosLayout extends StatefulWidget {
  const IngresosLayout({super.key});

  @override
  State<IngresosLayout> createState() => _IngresosLayoutState();
}

class _IngresosLayoutState extends State<IngresosLayout> {
  int idUsuario=1;//Placeholder esto se debe quitar luego
  /* Como parámetros están los ingresos, las columnas y el repositorio
  * */
  List<Ingreso> ingresos = [];
  final columnas = ["Fecha", "Motivo", "Origen", "Método de Pago", "Valor", "Estado", "Acciones"];
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
            content: Text('¿Realmente quieres eliminar el ingreso ID $idI?'),
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
                      context.go('/movimientos/ingresos/add', extra: idUsuario);
                    }, child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    Text("Agregar Ingreso")
                  ],
                )),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(future: _repository.getAllIngresos(idUsuario),
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
                            child: Text('Aún no ha registrado ningún ingreso'));
                      }
                      if(snapshot.hasData) {
                        ingresos = snapshot.data!;
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          margin: EdgeInsets.all(10),
                          child: IngresosDataTable(ingresos),
                        );
                      }
                      else{
                        return Center(child: Text('Aún no ha registrado ningún ingreso'));
                      }
                    }
        
                ),
              ],
            ),
      ),
    );
  }}