import 'package:flutter/material.dart';
import '../atom/app_card.dart';
import 'package:fl_chart/fl_chart.dart';


class TrendCard extends StatelessWidget {
  final Map<String, dynamic>? data_gastos;
  final Map<String, dynamic>? data_ingresos;
  TrendCard({super.key,
  required this.data_gastos,
  required this.data_ingresos});


  List<FlSpot> _crearPuntos()
  {
    List ingresos = data_ingresos!["ingresos"];
    List gastos = data_gastos!["gastos"];
    List<FlSpot> balance_dias= [];
    double balance = 0.0;
    for(int i=0; i<7; i++)
      {
        balance_dias.add(
          new FlSpot(i.toDouble(), (balance+ingresos[i]["total"]-gastos[i]["total"]))
        );
        balance += ingresos[i]["total"]-gastos[i]["total"];
      }
    return balance_dias;
  }

  List<String> _crearEtiquetas()
  {
    List ingresos = data_ingresos!["ingresos"];
    List<String> etiquetas = [];
    for(int i=0; i<7; i++)
      {
        etiquetas.add("${ingresos[i]["dia"].substring(8, 10)}-${ingresos[i]["dia"].substring(5, 7)}");
      }
    return etiquetas;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Tendencia (Últimos 7 días)',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ),
         SizedBox(height: 10),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text(
                'Neto diario',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2B2F3A),
                ),
              ),
              SizedBox(height: 12),
              Container(height: 150, alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (data) => Color(0xFF2B2F3A),
                    )),
                    gridData: FlGridData(show: false), // Limpia el fondo
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false,
                        ),

                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            List<String> days = _crearEtiquetas();
                            return Container(width: 30, margin: EdgeInsets.only(top: 5), child: Text(days[value.toInt()], style: TextStyle(fontSize: 10,
                            fontWeight: FontWeight.bold),));
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                        show: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeColor: const Color(0xFF2B2F3A),
                              strokeWidth: 2,
                            );}
                        ),
                        spots: _crearPuntos(), // Los puntos procesados
                        isCurved: true,
                        color: const Color(0xFF3613AB),
                        barWidth: 4,
                        belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                      ),
                    ],
                  ))),
              SizedBox(height: 10),
              Text(
                'positivo = ahorras, negativo = gastas más de lo que ingresas.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8B93A3),
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
