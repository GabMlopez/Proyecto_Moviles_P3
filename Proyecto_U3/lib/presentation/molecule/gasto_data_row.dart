import 'package:flutter/material.dart';

import '../../domain/entities/gasto.dart';

DataRow GastoDataRow(Gasto gasto, VoidCallback editAction, VoidCallback deleteAction){
  return DataRow(cells: [
    DataCell(Container(child: Text(gasto.fecha.toIso8601String().substring(0,10)))),
    DataCell(Container(width: 100, padding: EdgeInsets.fromLTRB(0, 3, 0, 3), child: SingleChildScrollView(child: Text(gasto.descripcion)),)),
    DataCell(Container(width: 100, padding: EdgeInsets.fromLTRB(0, 3, 0, 3), child: SingleChildScrollView(child: Text(gasto.acreedorCobrador)),)),
    DataCell(Container(width: 100, padding: EdgeInsets.fromLTRB(0, 3, 0, 3), child: SingleChildScrollView(child: Text(gasto.medioDePago)),)),
    DataCell(Text(gasto.valor)),
    DataCell(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: (gasto.estado == "confirmado") ? Colors.green : (gasto.estado == "pendiente") ? Colors.yellow : Colors.red,
        ),
        margin: EdgeInsets.all(1.5),
        padding: EdgeInsets.all(3),
        child: Text(gasto.estado,
            style: TextStyle(color: (gasto.estado == "pendiente") ? Colors.black : Colors.white)),
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
