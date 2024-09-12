import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Cloud Firestore
import 'movimientos/gasto_tile.dart'; // Asegúrate de tener también 'ingreso_tile.dart'
import 'movimientos/ingreso_tile.dart'; // Importa tu widget IngresoTile
import 'package:rxdart/rxdart.dart'; // Importa RxDart

class MovimientosList extends StatelessWidget {
  const MovimientosList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: combineGastosIngresosStreams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final movimientos = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movimientos.length,
          itemBuilder: (context, index) {
            final movimiento = movimientos[index];
            final isGasto = movimiento['source'] == 'gastos';

            return isGasto
                ? GastoTile(
                    id: movimiento['id'],
                    titulo: movimiento['title'],
                    tipo: movimiento['type'],
                    cantidad: movimiento['cantidad'],
                    fecha: movimiento['fecha'].toDate(),
                    onDismissed: (id) async {
                      await deleteGasto(id);
                    },
                    confirmDismiss: () async {
                      bool result = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('¿ Eliminar gasto ?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Sí, eliminar'),
                              ),
                            ],
                          );
                        },
                      );
                      return result;
                    },
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        '/edit-gasto',
                        arguments: {
                          'titulo': movimiento['title'],
                          'tipo': movimiento['type'],
                          'cantidad': movimiento['cantidad'],
                          'fecha': movimiento['fecha'],
                          'id': movimiento['id'],
                        },
                      );
                    },
                  )
                : IngresoTile(
                    id: movimiento['id'],
                    titulo: movimiento['title'],
                    tipo: movimiento['type'],
                    cantidad: movimiento['cantidad'],
                    fecha: movimiento['fecha'].toDate(),
                    onDismissed: (id) async {
                      await deleteIngreso(id);
                    },
                    confirmDismiss: () async {
                      bool result = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('¿ Eliminar ingreso ?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Sí, eliminar'),
                              ),
                            ],
                          );
                        },
                      );
                      return result;
                    },
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        '/edit-ingreso',
                        arguments: {
                          'titulo': movimiento['title'],
                          'tipo': movimiento['type'],
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

// Función para combinar y ordenar los streams
Stream<List<Map<String, dynamic>>> combineGastosIngresosStreams() {
  return Rx.combineLatest2(
    getGastosStream(),
    getIngresosStream(),
    (List<Map<String, dynamic>> gastos, List<Map<String, dynamic>> ingresos) {
      final allMovimientos = [
        ...gastos.map((gasto) => {...gasto, 'source': 'gastos'}),
        ...ingresos.map((ingreso) => {...ingreso, 'source': 'ingresos'}),
      ];

      // Ordenamos por fecha y hora en orden descendente
      allMovimientos.sort((a, b) {
        final fechaA = parseDate(a['fecha']);
        final fechaB = parseDate(b['fecha']);
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

Stream<List<Map<String, dynamic>>> getGastosStream() {
  return db.collection('gastos').snapshots().map((querySnapshot) {
    return querySnapshot.docs.map((documento) {
      final data = documento.data();
      return {
        'cantidad': data['cantidad'],
        'title': data['title'],
        'type': data['type'],
        'fecha': data['fecha'], // 'fecha' es un Timestamp
        'id': documento.id,
      };
    }).toList();
  });
}

Stream<List<Map<String, dynamic>>> getIngresosStream() {
  return db.collection('ingresos').snapshots().map((querySnapshot) {
    return querySnapshot.docs.map((documento) {
      final data = documento.data();
      return {
        'cantidad': data['cantidad'],
        'title': data['title'],
        'type': data['type'],
        'fecha': data['fecha'], // 'fecha' es un Timestamp
        'id': documento.id,
      };
    }).toList();
  });
}
