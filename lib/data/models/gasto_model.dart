import 'package:cloud_firestore/cloud_firestore.dart';

class Gasto {
  final String id;
  final int cantidad;
  final String titulo;
  final String tipo;
  final Timestamp fecha;

  Gasto({
    required this.id,
    required this.cantidad,
    required this.titulo,
    required this.tipo,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cantidad': cantidad,
      'titulo': titulo,
      'tipo': tipo,
      'fecha': fecha, // Mantener el Timestamp
    };
  }

  factory Gasto.fromMap(Map<String, dynamic> map) {
    return Gasto(
      id: map['id'],
      cantidad: map['cantidad'],
      titulo: map['titulo'],
      tipo: map['tipo'],
      fecha:
          map['fecha'] as Timestamp, // Asegúrate de que `fecha` es un Timestamp
    );
  }
}
