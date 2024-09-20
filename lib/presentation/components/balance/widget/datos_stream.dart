import 'package:flutter/material.dart';

class MovimientosTotalesWidget extends StatelessWidget {
  final Stream<Map<String, int>> movimientosTotalesStream;

  const MovimientosTotalesWidget({
    required this.movimientosTotalesStream,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, int>>(
      stream: movimientosTotalesStream,
      builder: (context, snapshot) {
        // Indicador de carga mientras se obtienen los datos
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Manejo de errores
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Mensaje si no hay datos
        if (!snapshot.hasData) {
          return const Center(child: Text('No hay datos disponibles'));
        }

        // Accediendo a los datos del snapshot
        final data = snapshot.data!;
        final saldoDisponible = data['saldoDisponible'] ?? 0;
        final totalIngresos = data['totalIngresos'] ?? 0;
        final totalGastos = data['totalGastos'] ?? 0;

        // Mostrar los datos en la UI
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Saldo Disponible: \$${saldoDisponible.toString()}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Ingresos de este mes: \$${totalIngresos.toString()}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Gastos de este mes: \$${totalGastos.toString()}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        );
      },
    );
  }
}
