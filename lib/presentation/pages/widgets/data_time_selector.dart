import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeSelector extends StatelessWidget {
  final DateTime? selectedDateTime;
  final VoidCallback onPressed;

  const DateTimeSelector({
    required this.selectedDateTime,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            selectedDateTime == null
                ? 'Seleccione la fecha y hora'
                : DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!),
            style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          color: colorScheme.tertiary,
          splashRadius: 30, // Hacer que el ícono responda mejor
          onPressed: onPressed,
        ),
      ],
    );
  }
}
