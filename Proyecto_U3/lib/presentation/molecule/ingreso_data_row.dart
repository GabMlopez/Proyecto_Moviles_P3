import 'package:flutter/material.dart';

import '../../domain/entities/ingreso.dart';

DataRow ingresoDataRow(Ingreso ingreso, VoidCallback editAction, VoidCallback deleteAction){
  bool ingresoConfirmado = ingreso.estado == "confirmado";
  return DataRow(cells: [
    DataCell(Container(child: Text(ingreso.fecha.toIso8601String().substring(0,10)))),
    DataCell(Container(width: 100, padding: EdgeInsets.fromLTRB(0, 3, 0, 3), child: SingleChildScrollView(child: Text(ingreso.descripcion)),)),
    DataCell(Container(width: 100, padding: EdgeInsets.fromLTRB(0, 3, 0, 3), child: SingleChildScrollView(child: Text(ingreso.fuenteBeneficiario)),)),
    DataCell(Container(width: 100, padding: EdgeInsets.fromLTRB(0, 3, 0, 3), child: SingleChildScrollView(child: Text(ingreso.medioDePago)),)),
    DataCell(Text(ingreso.valor)),
    DataCell(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: (ingresoConfirmado) ? Colors.green : Colors.orangeAccent,
        ),
        margin: EdgeInsets.all(1.5),
        padding: EdgeInsets.all(3),
        child: Text(ingreso.estado,
            style: TextStyle(color: (ingresoConfirmado) ? Colors.white : Colors.black)),
      )
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 5,
      children: [
        IconButton(onPressed: editAction, icon: Icon(Icons.edit, color: Colors.blueAccent,)),
        IconButton(onPressed: deleteAction, icon: Icon(Icons.delete, color: Colors.red,))
      ],
    ))
  ]);
}
