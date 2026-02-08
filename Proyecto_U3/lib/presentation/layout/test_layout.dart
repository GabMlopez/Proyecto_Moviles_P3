import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/repository/ingreso_repository.dart';
import '../../domain/entities/ingreso.dart';

class TestLayout extends StatefulWidget {
  const TestLayout({super.key});

  @override
  State<TestLayout> createState() => _TestLayoutState();
}

class _TestLayoutState extends State<TestLayout> {
  List<Ingreso> ingresosCargados = [];
  String mensaje = ''; // Para mostrar éxito o error

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botones de acciones
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Cargar todos los ingresos (user 1)'),
              onPressed: _cargarIngresos,
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.visibility),
              label: const Text('Obtener ingreso por ID (ej: 2)'),
              onPressed: () => _obtenerPorId(2), // Cambia el ID según tu BD
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Crear ingreso nuevo'),
              onPressed: _crearIngreso,
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Actualizar ingreso (ID 4)'),
              onPressed: () =>
                  _actualizarIngreso(3),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: const Text('Eliminar ingreso (ID 4)'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
              onPressed: () => _eliminarIngreso(5,1),
            ),

            const SizedBox(height: 24),

            // Mensaje de estado
            if (mensaje.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  mensaje,
                  style: TextStyle(
                    color: mensaje.contains('Error') ? Colors.red : Colors
                        .green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            const Divider(height: 32),

            // Lista de ingresos cargados
            if (ingresosCargados.isNotEmpty)
              Text(
                'Ingresos cargados (${ingresosCargados.length}):',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),

            if (ingresosCargados.isNotEmpty)
              SizedBox(
                height: 300, // Ajusta según necesites
                child: ListView.builder(
                  itemCount: ingresosCargados.length,
                  itemBuilder: (context, index) {
                    final ingreso = ingresosCargados[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(ingreso.descripcion),
                        subtitle: Text(
                          '${ingreso.valor} • ${ingreso.fecha
                              .toString()
                              .substring(0, 10)} • ${ingreso.estado}',
                        ),
                        trailing: Text('ID: ${ingreso.idingreso}'),
                      ),
                    );
                  },
                ),
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                      'Presiona "Cargar todos los ingresos" para ver la lista'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _cargarIngresos() async {
    _limpiarMensaje();
    try {
      final repo = GetIt.I<IngresoRepository>();
      final ingresos = await repo.getAllIngresos(1);
      setState(() {
        ingresosCargados = ingresos;
        mensaje = 'Éxito: ${ingresos.length} ingresos cargados';
      });
    } catch (e) {
      _mostrarError('Cargar lista', e);
    }
  }

  Future<void> _obtenerPorId(int id) async {
    _limpiarMensaje();
    try {
      final repo = GetIt.I<IngresoRepository>();
      final ingreso = await repo.getIngresoById(
          id); // Necesitas implementar esto en el repo
      setState(() {
        mensaje =
        'Éxito: Ingreso encontrado\n${ingreso.descripcion} - ${ingreso.valor}';
      });
    } catch (e) {
      _mostrarError('Obtener por ID $id', e);
    }
  }

  Future<void> _crearIngreso() async {
    _limpiarMensaje();
    try {
      final repo = GetIt.I<IngresoRepository>();

      final nuevoIngreso = Ingreso(
        idingreso: 0,
        idusuario: 1,
        fecha: DateTime.now(),
        valor: "500.00",
        medioDePago: "Efectivo",
        fuenteBeneficiario: "Venta de productos",
        descripcion: "Ingreso de prueba creado desde Flutter - ${DateTime
            .now()}",
        estado: "pendiente",
      );

      await repo.addIngreso(nuevoIngreso);
      setState(() {
        mensaje = 'Éxito: Ingreso creado correctamente';
      });
      // Opcional: recargar lista después de crear
      await _cargarIngresos();
    } catch (e) {
      _mostrarError('Crear ingreso', e);
    }
  }

  Future<void> _actualizarIngreso(int id) async {
    _limpiarMensaje();
    try {
      final repo = GetIt.I<IngresoRepository>();

      // Primero obtener el ingreso actual (opcional, pero recomendado)
      final ingresoActual = await repo.getIngresoById(id);

      final ingresoActualizado = Ingreso(
        idingreso: id,
        idusuario: ingresoActual.idusuario,
        fecha: ingresoActual.fecha,
        valor: "999.99",
        // Cambia el valor como prueba
        medioDePago: ingresoActual.medioDePago,
        fuenteBeneficiario: ingresoActual.fuenteBeneficiario,
        descripcion: "ACTUALIZADO desde Flutter - ${DateTime.now()}",
        estado: "confirmado",
      );

      await repo.updateIngreso(ingresoActualizado);
      setState(() {
        mensaje = 'Éxito: Ingreso ID $id actualizado';
      });
      await _cargarIngresos(); // Refrescar lista
    } catch (e) {
      _mostrarError('Actualizar ingreso $id', e);
    }
  }

  Future<void> _eliminarIngreso(int idI, int idU) async {
    _limpiarMensaje();
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('¿Eliminar?'),
            content: Text('¿Realmente quieres eliminar el ingreso ID $idI?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar')),
              TextButton(onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                      'Eliminar', style: TextStyle(color: Colors.red))),
            ],
          ),
    );

    if (confirmar != true) return;

    try {
      final repo = GetIt.I<IngresoRepository>();
      await repo.deleteIngreso(idI);
      setState(() {
        mensaje = 'Éxito: Ingreso ID $idI eliminado';
      });
      await _cargarIngresos(); // Refrescar lista
    } catch (e) {
      _mostrarError('Eliminar ingreso $idI', e);
    }
  }

  void _limpiarMensaje() {
    setState(() => mensaje = '');
  }

  void _mostrarError(String accion, dynamic e) {
    setState(() {
      mensaje = 'Error en $accion:\n$e';
    });
    print('Error en $accion: $e');
  }
}