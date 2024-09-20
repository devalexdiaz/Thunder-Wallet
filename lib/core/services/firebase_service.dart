import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart'; // Importar rxdart para combinar streams

class FirebaseService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Stream genérico para obtener gastos o ingresos
  Stream<List<Map<String, dynamic>>> getMovimientosStream(String tipo) {
    return db.collection(tipo).snapshots().map((querySnapshot) {
      List<Map<String, dynamic>> movimientos = [];
      for (var documento in querySnapshot.docs) {
        final Map<String, dynamic> data = documento.data();
        final movimiento = {
          'cantidad': (data['cantidad'] as num).toInt(), // Convertir a double
          'titulo': data['title'],
          'tipo': data['type'],
          'fecha': (data['fecha'] as Timestamp).toDate(),
          'id': documento.id,
        };
        movimientos.add(movimiento);
      }
      return movimientos;
    });
  }

  // Guardar movimiento (gasto o ingreso)
  Future<void> addMovimiento(String tipo, String titulo, String tipoMov,
      int cantidad, DateTime fecha) async {
    await db.collection(tipo).add({
      'title': titulo,
      'type': tipoMov,
      'cantidad': cantidad, // Guardar como int
      'fecha': fecha,
    });
  }

  // Actualizar movimiento (gasto o ingreso)
  Future<void> updateMovimiento(
    String tipo,
    String id,
    String newTitulo,
    String newTipoMov,
    int newCantidad,
    DateTime newFecha,
  ) async {
    await db.collection(tipo).doc(id).update({
      'title': newTitulo,
      'type': newTipoMov,
      'cantidad': newCantidad, // Guardar como int
      'fecha': newFecha,
    });
  }

  // Eliminar movimiento (gasto o ingreso)
  Future<void> deleteMovimiento(String tipo, String id) async {
    await db.collection(tipo).doc(id).delete();
  }

  // Stream combinado para calcular los totales
  Stream<Map<String, int>> getMovimientosTotales() {
    return Rx.combineLatest2<List<Map<String, dynamic>>,
        List<Map<String, dynamic>>, Map<String, int>>(
      getMovimientosStream('gastos'),
      getMovimientosStream('ingresos'),
      (gastos, ingresos) {
        final totalGastos = gastos.where((gasto) {
          // Asegúrate de que 'fecha' sea un Timestamp y conviértelo a DateTime
          final fecha = (gasto['fecha'] is Timestamp)
              ? (gasto['fecha'] as Timestamp).toDate()
              : gasto['fecha'] as DateTime;

          return fecha.month == DateTime.now().month &&
              fecha.year == DateTime.now().year;
        }).fold<int>(
            0,
            (acumulador, item) =>
                acumulador + (item['cantidad'] as num).toInt());

        final totalIngresos = ingresos.where((ingreso) {
          // Asegúrate de que 'fecha' sea un Timestamp y conviértelo a DateTime
          final fecha = (ingreso['fecha'] is Timestamp)
              ? (ingreso['fecha'] as Timestamp).toDate()
              : ingreso['fecha'] as DateTime;

          return fecha.month == DateTime.now().month &&
              fecha.year == DateTime.now().year;
        }).fold<int>(
            0,
            (acumulador, item) =>
                acumulador + (item['cantidad'] as num).toInt());

        final saldoDisponible = totalIngresos - totalGastos;

        return {
          'saldoDisponible': saldoDisponible,
          'totalIngresos': totalIngresos,
          'totalGastos': totalGastos,
        };
      },
    );
  }
}
