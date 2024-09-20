import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallet/core/services/firebase_service.dart';

class MovimientoRepository {
  final FirebaseService _firebaseService;

  MovimientoRepository(this._firebaseService);

  Stream<List<Map<String, dynamic>>> getMovimientosStream(String tipo) {
    return _firebaseService.getMovimientosStream(tipo);
  }

  Future<void> addMovimiento(String tipo, String titulo, String tipoMov,
      int cantidad, Timestamp fecha) async {
    return _firebaseService.addMovimiento(
        tipo, titulo, tipoMov, cantidad, fecha.toDate());
  }

  Future<void> updateMovimiento(String tipo, String id, String newTitulo,
      String newTipoMov, int newCantidad, Timestamp newFecha) async {
    return _firebaseService.updateMovimiento(
        tipo, id, newTitulo, newTipoMov, newCantidad, newFecha.toDate());
  }

  Future<void> deleteMovimiento(String tipo, String id) async {
    return await _firebaseService.deleteMovimiento(tipo, id);
  }

  Stream<Map<String, int>> getMovimientosTotales() {
    return _firebaseService.getMovimientosTotales().map((totales) {
      return {
        'saldoDisponible': totales['saldoDisponible'] ?? 0, // Manejar null
        'totalIngresos': totales['totalIngresos'] ?? 0, // Manejar null
        'totalGastos': totales['totalGastos'] ?? 0, // Manejar null
      };
    });
  }
}
