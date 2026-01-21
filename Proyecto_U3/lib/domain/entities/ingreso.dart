import 'dart:convert';

IngresoResponse ingresoResponseFromJson(String str) =>
    IngresoResponse.fromJson(json.decode(str));

String ingresoResponseToJson(IngresoResponse data) =>
    json.encode(data.toJson());

class IngresoResponse {
  final List<Ingreso> ingresos;

  IngresoResponse({
    required this.ingresos,
  });
  factory IngresoResponse.fromJson(Map<String, dynamic> json) {
    List<Ingreso> listaIngresos = [];

    final ingresosDynamic = json['ingresos'];

    if (ingresosDynamic != null && ingresosDynamic is List) {
      listaIngresos = ingresosDynamic.map((x) {
        return Ingreso.fromJson(x as Map<String, dynamic>);
      }).toList();
    }
     else if (json['ingreso'] != null && json['ingreso'] is Map) {
       listaIngresos = [Ingreso.fromJson(json['ingreso'] as Map<String, dynamic>)];
     }

    return IngresoResponse(ingresos: listaIngresos);
  }

  Map<String, dynamic> toJson() {
    return {
      "ingresos": ingresos.map((x) => x.toJson()).toList(),
    };
  }
}

class Ingreso {
  final int idingreso;
  final int idusuario;
  final DateTime fecha;
  final String valor;
  final String medioDePago;
  final String fuenteBeneficiario;
  final String descripcion;
  final String estado;

  Ingreso({
    required this.idingreso,
    required this.idusuario,
    required this.fecha,
    required this.valor,
    required this.medioDePago,
    required this.fuenteBeneficiario,
    required this.descripcion,
    required this.estado,
  });

  factory Ingreso.fromJson(Map<String, dynamic> json) {
    return Ingreso(
      idingreso: json["idingreso"] as int,
      idusuario: json["idusuario"] as int,
      fecha: DateTime.parse(json["fecha"] as String),
      valor: json["valor"] as String,
      medioDePago: json["medio_de_pago"] as String,
      fuenteBeneficiario: json["fuente_beneficiario"] as String,
      descripcion: json["descripcion"] as String,
      estado: json["estado"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idingreso": idingreso,
      "idusuario": idusuario,
      "fecha":
      "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
      "valor": valor,
      "medio_de_pago": medioDePago,
      "fuente_beneficiario": fuenteBeneficiario,
      "descripcion": descripcion,
      "estado": estado,
    };
  }
}