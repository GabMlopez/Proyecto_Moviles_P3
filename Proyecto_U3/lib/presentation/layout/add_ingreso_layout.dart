import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../presentation/molecule/mensaje_snackbar.dart';

import '../../domain/entities/ingreso.dart';
import '../../domain/repository/ingreso_repository.dart';
import '../global_manager/user_provider.dart';
class AddIngresoLayout extends StatefulWidget {
  AddIngresoLayout({super.key});

  @override
  State<AddIngresoLayout> createState() => _AddIngresoLayoutState();
}

class _AddIngresoLayoutState extends State<AddIngresoLayout> {
  //Repositorio
  final _repository = GetIt.I<IngresoRepository>();



  //Controladores de texto
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _valorController = TextEditingController();
  TextEditingController _medioDePagoController = TextEditingController();
  TextEditingController _fuenteBeneficiarioController = TextEditingController();
  TextEditingController _fechaController = TextEditingController();
  TextEditingController _estadoController = TextEditingController();



  //Parámetros y variables
  DateTime? selectedDate;
  List<String> medioDePagoOptions = ['Efectivo', 'Tarjeta de crédito', 'Tarjeta de débito'];
  List<String> estadoOptions = ['pendiente', 'confirmado'];
  String _errorMsg = "";

  // Valida que no se dejen campos vacíos
  bool validarCamposVacios()
  {
    if(_descripcionController.text == ""
        || _valorController.text == ""
        || selectedDate == null
        || _fuenteBeneficiarioController.text == ""
        || _estadoController.text == ""
        || _medioDePagoController.text == ""){
      setState(() {
        _errorMsg = "No puede dejar campos vacíos";
      });
      return false;
    }
    else
      _errorMsg = "";
      return true;
  }

  // Valida que el valor sea un número
  bool validarIngresoNumerico()
  {
    if(double.tryParse(_valorController.text) == null) {
      setState(() {
        _errorMsg = "El valor debe ser un número";
      });
      return false;
    }
    else return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fechaController.text = "dd/mm/aaaa";
    _estadoController.text = "";
    _medioDePagoController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        context.go("/movimientos/ingresos");
      },
      child: SafeArea(child: Scaffold(
        appBar: AppBar(
          title: const Text("Agregar Ingreso"),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 10,
                ),
                SizedBox(width: 250,
                    height: 50,
                    child: TextField(
                        controller: _descripcionController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Descripción del Ingreso",
                            hintText: "Ej: Salario Mes de Noviembre"
                        ))),
                SizedBox(height: 20),
                SizedBox(width: 150,
                    height: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                        controller: _valorController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Valor",
                        ))),
                SizedBox(height: 20),
                SizedBox(
                    width: 250,
                    height: 50,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: TextField(
                              readOnly: true,
                              controller: _fechaController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Fecha del ingreso")
                          ),
                        ),
                        IconButton(icon: Icon(Icons.calendar_month), onPressed: (){
                          _selectDate();
                        },)
                      ],
                    )
                ),
                SizedBox(height: 20),
              SizedBox(width: 250,
                  height: 50,
                  child: TextField(
                      controller: _fuenteBeneficiarioController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Fuente del ingreso",
                          hintText: "Ej: Empresa de Seguros"
                      ))),
                SizedBox(height: 20),
                SizedBox(height: 20, child: Text("Medio de Pago:", style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),)),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    child: DropdownButton(
                        underline: Container(
                          height: 0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        hint: Text("Seleccione un medio de pago"),
                        items: [
                          DropdownMenuItem(value: "", child: Text("-")),
                          DropdownMenuItem(value: "Efectivo", child: Text("Efectivo")),
                          DropdownMenuItem(value: "Tarjeta de crédito", child: Text("Tarjeta de crédito")),
                          DropdownMenuItem(value: "Tarjeta de débito", child: Text("Tarjeta de débito")),
                          DropdownMenuItem(value: "Cheque", child: Text("Cheque")),
                          DropdownMenuItem(value: "Transferencia Bancaria", child: Text("Transferencia")),
                          DropdownMenuItem(value: "Otro", child: Text("Otro")),
                        ],
                        value: _medioDePagoController.text,
                        onChanged: (valor)
                    {
                      setState(() {
                        _medioDePagoController.text = valor!;
                      });
                    })),
                SizedBox(height: 20),
                SizedBox(height: 20, child: Text("Estado:", style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),)),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    child: DropdownButton(
                        underline: Container(
                          height: 0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        hint: Text("Estado: "),
                        items: [
                          DropdownMenuItem(value: "", child: Text("-")),
                          DropdownMenuItem(value: "pendiente", child: Text("pendiente")),
                          DropdownMenuItem(value: "confirmado", child: Text("confirmado")),
                        ],
                        value: _estadoController.text,
                        onChanged: (valor)
                        {
                          setState(() {
                            _estadoController.text = valor!;
                          });
                        })),
                SizedBox(
                  height: 10,
                ),
                Text(_errorMsg,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 20),
                SizedBox(
                    width: 250,
                    height: 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: 15,
                      children: [
                        OutlinedButton(onPressed: (){
                          context.pop();
                        }, child: Text("Cancelar")),
                        OutlinedButton(onPressed: (){
                          crearIngreso();
                        }, child: Text("Crear")),
                      ],
                    )
                )
              ],
            ),
          ),
        )
        ),
      ),
    );
  }

  // Función para desplegar un calendario y seleccionar la fecha
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().day, DateTime.now().month, DateTime.now().year),
      initialDate: selectedDate ?? DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    setState(() {
      selectedDate = pickedDate;
      _fechaController.text = selectedDate.toString().substring(0, 10);
    });
  }

  Future<void> crearIngreso() async{
    if(!validarCamposVacios())
    {
      return;
    }
    if(!validarIngresoNumerico())
    {
      return;
    }

    try{
      final int idUsuario = Provider.of<UserProvider>(context, listen: false).idUsuario!;
      await _repository.addIngreso(Ingreso(
          idingreso: 0,
          idusuario: idUsuario,
          fecha: selectedDate!,
          valor: _valorController.text,
          medioDePago: _medioDePagoController.text,
          fuenteBeneficiario: _fuenteBeneficiarioController.text,
          descripcion: _descripcionController.text,
          estado: _estadoController.text
      ));
      mostrarMensaje(mensaje: "Ingreso creado correctamente", tipo: "success", context: context);
      context.pop(true);
    }catch(e)
    {
      mostrarMensaje(mensaje: "Error al crear el ingreso", tipo: "error", context: context);
      print(e);
    }
  }

}
