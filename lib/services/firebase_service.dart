import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Stream<List<Map<String, dynamic>>> getGastosStream() {
  return db.collection('gastos').snapshots().map((querySnapshot) {
    List<Map<String, dynamic>> movimientos = [];
    for (var documento in querySnapshot.docs) {
      final Map<String, dynamic> data = documento.data();
      final movimiento = {
        'cantidad': (data['cantidad'] as num).toInt(), // Convertir a double
        'title': data['title'],
        'type': data['type'],
        'fecha': (data['fecha'] as Timestamp).toDate(),
        'id': documento.id,
      };
      movimientos.add(movimiento);
    }
    return movimientos;
  });
}

// Guardar gasto en base de datos
Future<void> addGasto(
    String titulo, String tipo, int cantidad, DateTime fecha) async {
  await db.collection('gastos').add({
    'title': titulo,
    'type': tipo,
    'cantidad': cantidad, // Guardar como double
    'fecha': fecha,
  });
}

// Actualizar un gasto en la base de datos
Future<void> updateGasto(
  String idGasto,
  String newTitulo,
  String newTipo,
  int newCantidad, // Cambiado a double
  DateTime newFecha,
) async {
  await db.collection('gastos').doc(idGasto).update({
    'title': newTitulo,
    'type': newTipo,
    'cantidad': newCantidad, // Guardar como double
    'fecha': newFecha,
  });
}

// Borrar gasto de la base de datos
Future<void> deleteGasto(String id) async {
  await db.collection('gastos').doc(id).delete();
}

// INGRESOS
// Cargar ingresos desde firebase
Stream<List<Map<String, dynamic>>> getIngresosStream() {
  return db.collection('ingresos').snapshots().map((querySnapshot) {
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

// Guardar ingreso en base de datos
Future<void> addIngreso(
    String titulo, String tipo, int cantidad, DateTime fecha) async {
  await db.collection('ingresos').add({
    'title': titulo,
    'type': tipo,
    'cantidad': cantidad, // Guardar como double
    'fecha': fecha,
  });
}

// Actualizar un ingreso en la base de datos
Future<void> updateIngreso(String idGasto, String newTitulo, String newTipo,
    int newCantidad, DateTime newFecha) async {
  await db.collection('ingresos').doc(idGasto).update({
    'title': newTitulo,
    'type': newTipo,
    'cantidad': newCantidad, // Guardar como double
    'fecha': newFecha,
  });
}

// Borrar ingreso de la base de datos
Future<void> deleteIngreso(String id) async {
  await db.collection('ingresos').doc(id).delete();
}