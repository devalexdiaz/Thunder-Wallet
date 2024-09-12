import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IngresoTile extends StatelessWidget {
  final String id;
  final int cantidad;
  final String titulo;
  final String tipo;
  final DateTime fecha;
  final Future<void> Function(String id) onDismissed;
  final Future<bool> Function() confirmDismiss;
  final Future<void> Function() onTap;

  const IngresoTile({
    required this.id,
    required this.cantidad,
    required this.titulo,
    required this.tipo,
    required this.fecha,
    required this.onDismissed,
    required this.confirmDismiss,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);

    return Dismissible(
      onDismissed: (direction) async {
        await onDismissed(id);
      },
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete),
      ),
      confirmDismiss: (direction) async {
        return await confirmDismiss();
      },
      direction: DismissDirection.startToEnd,
      key: Key(id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListTile(
          title: Text(titulo),
          subtitle: Text(tipo),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(cantidad.toString(),
                  style: const TextStyle(color: Colors.green)),
              Text(fechaFormateada, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}