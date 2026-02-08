import 'dart:convert';

GastoResponse gastoResponseFromJson(String str) =>
    GastoResponse.fromJson(json.decode(str));

String gastoResponseToJson(GastoResponse data) =>
    json.encode(data.toJson());

class GastoResponse {
  final List<Gasto> gastos;

  GastoResponse({
    required this.gastos,
  });
  factory GastoResponse.fromJson(Map<String, dynamic> json) {
    List<Gasto> listaGastos = [];

    final gastosDynamic = json['gastos'];


    if (gastosDynamic != null && gastosDynamic is List) {
      listaGastos = gastosDynamic.map((x) {
        return Gasto.fromJson(x as Map<String, dynamic>);
      }).toList();
    }
     else if (json['gasto'] != null && json['gasto'] is Map) {
       listaGastos = [Gasto.fromJson(json['gasto'] as Map<String, dynamic>)];
     }

    return GastoResponse(gastos: listaGastos);
  }

  Map<String, dynamic> toJson() {
    return {
      "gastos": gastos.map((x) => x.toJson()).toList(),
    };
  }
}

class Gasto {
  final int idGasto;
  final int idUsuario;
  final DateTime fecha;
  final String valor;
  final String medioDePago;
  final String acreedorCobrador;
  final String descripcion;
  final String estado;

  Gasto({
    required this.idGasto,
    required this.idUsuario,
    required this.fecha,
    required this.valor,
    required this.medioDePago,
    required this.acreedorCobrador,
    required this.descripcion,
    required this.estado,
  });

  factory Gasto.fromJson(Map<String, dynamic> json) {
    return Gasto(
      idGasto: json["idgasto"] as int,
      idUsuario: json["idusuario"] as int,
      fecha: DateTime.parse(json["fecha"] as String),
      valor: json["valor"] as String,
      medioDePago: json["medio_de_pago"] as String,
      acreedorCobrador: json["acreedor_cobrador"] as String,
      descripcion: json["descripcion"] as String,
      estado: json["estado"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idgasto": idGasto,
      "idusuario": idUsuario,
      "fecha":
      "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
      "valor": valor,
      "medio_de_pago": medioDePago,
      "acreedor_cobrador": acreedorCobrador,
      "descripcion": descripcion,
      "estado": estado,
    };
  }
}