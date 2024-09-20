import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GastoTile extends StatelessWidget {
  final String id;
  final int cantidad;
  final String titulo;
  final String tipo;
  final DateTime fecha; // Cambiado a DateTime
  final Future<void> Function(String id) onDismissed;
  final Future<bool> Function() confirmDismiss;
  final Future<void> Function() onTap;

  const GastoTile({
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
    final fechaFormateada =
        DateFormat('dd/MM/yyyy').format(fecha); // Usa DateTime directamente

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
          title: Text(
            titulo.toString(),
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          subtitle: Text(
            tipo.toString(),
            style: const TextStyle(fontWeight: FontWeight.w300),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(cantidad.toString(),
                  style: const TextStyle(fontSize: 15, color: Colors.red)),
              Text(fechaFormateada, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
