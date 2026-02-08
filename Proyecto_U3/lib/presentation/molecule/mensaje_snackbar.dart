import 'package:flutter/material.dart';

void mostrarMensaje({required String mensaje, required String tipo, required BuildContext context})
{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(mensaje),
    duration: Duration(seconds: 3),
    backgroundColor: (tipo == "error") ? Colors.red : (tipo == "info") ? Colors.blue : Colors.green
  ));
}