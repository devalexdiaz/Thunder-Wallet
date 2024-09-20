import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/data/repositories/movimiento_repository.dart';
import 'components/gasto_tile.dart';
import 'components/ingreso_tile.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart'; // Asegúrate de tener esta importación

class MovimientosList extends StatelessWidget {
  const MovimientosList({super.key});

  @override
  Widget build(BuildContext context) {
    final movimientoRepository = Provider.of<MovimientoRepository>(context);

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: combineGastosIngresosStreams(movimientoRepository),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final movimientos = snapshot.data ?? [];

        if (movimientos.isEmpty) {
          return const Center(child: Text('No hay movimientos disponibles.'));
        }

        return ListView.builder(
          physics:
              const BouncingScrollPhysics(), // Otras opciones son ClampingScrollPhysics()
          itemCount: movimientos.length,
          itemBuilder: (context, index) {
            final movimiento = movimientos[index];
            final isGasto = movimiento['source'] == 'gastos';

            return isGasto
                ? GastoTile(
                    id: movimiento['id']?.toString() ?? 'Sin ID',
                    titulo: movimiento['titulo']?.toString() ?? 'Sin título',
                    tipo: movimiento['tipo']?.toString() ?? 'Sin tipo',
                    cantidad: movimiento['cantidad'],
                    fecha: DateTime.tryParse(movimiento['fecha'].toString()) ??
                        DateTime.now(),
                    onDismissed: (id) async {
                      try {
                        await movimientoRepository.deleteMovimiento(
                            'gastos', id);
                      } catch (e) {
                        //print('Error eliminando el movimiento: $e');
                      }
                    },
                    confirmDismiss: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('¿ Eliminar gasto ?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancelar',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Sí, eliminar',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)),
                              ),
                            ],
                          );
                        },
                      );
                      return result ?? false;
                    },
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        '/edit-gasto',
                        arguments: {
                          'titulo': movimiento[
                              'titulo'], // Cambiado de 'title' a 'titulo'
                          'tipo':
                              movimiento['tipo'], // Cambiado de 'type' a 'tipo'
                          'cantidad': movimiento['cantidad'],
                          'fecha': movimiento['fecha'],
                          'id': movimiento['id'],
                        },
                      );
                    },
                  )
                : IngresoTile(
                    id: movimiento['id']?.toString() ?? 'Sin ID',
                    titulo: movimiento['titulo']?.toString() ?? 'Sin título',
                    tipo: movimiento['tipo']?.toString() ?? 'Sin tipo',
                    cantidad: movimiento['cantidad'],
                    fecha: DateTime.tryParse(movimiento['fecha'].toString()) ??
                        DateTime.now(),
                    onDismissed: (id) async {
                      await movimientoRepository.deleteMovimiento(
                          'ingresos', id);
                    },
                    confirmDismiss: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('¿ Eliminar ingreso ?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancelar',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Sí, eliminar',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)),
                              ),
                            ],
                          );
                        },
                      );
                      return result ?? false;
                    },
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        '/edit-ingreso',
                        arguments: {
                          'titulo': movimiento[
                              'titulo'], // Cambiado de 'title' a 'titulo'
                          'tipo':
                              movimiento['tipo'], // Cambiado de 'type' a 'tipo'
                          'cantidad': movimiento['cantidad'],
                          'fecha': movimiento['fecha'],
                          'id': movimiento['id'],
                        },
                      );
                    },
                  );
          },
        );
      },
    );
  }
}

Stream<List<Map<String, dynamic>>> combineGastosIngresosStreams(
    MovimientoRepository repository) {
  return Rx.combineLatest2(
    repository.getMovimientosStream('gastos'),
    repository.getMovimientosStream('ingresos'),
    (List<Map<String, dynamic>> gastos, List<Map<String, dynamic>> ingresos) {
      final allMovimientos = [
        ...gastos.map((gasto) => {...gasto, 'source': 'gastos'}),
        ...ingresos.map((ingreso) => {...ingreso, 'source': 'ingresos'}),
      ];

      // Ordenamos por fecha y hora en orden descendente
      allMovimientos.sort((a, b) {
        final fechaA = a['fecha'] as DateTime;
        final fechaB = b['fecha'] as DateTime;
        return fechaB.compareTo(fechaA); // Ordena de más reciente a más antiguo
      });

      return allMovimientos;
    },
  );
}

DateTime parseDate(Timestamp timestamp) {
  // Convierte Timestamp a DateTime
  return timestamp.toDate();
}

String formatDate(Timestamp timestamp) {
  // Formatea Timestamp a una cadena en formato 'dd/MM/yyyy'
  return DateFormat('dd/MM/yyyy').format(parseDate(timestamp));
}
