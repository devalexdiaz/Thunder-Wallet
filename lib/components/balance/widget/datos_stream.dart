import 'package:flutter/material.dart';

// Componente que muestra el saldo, ingresos y gastos
class MovimientosTotalesWidget extends StatelessWidget {
  // Stream con los datos de saldo disponible, ingresos y gastos
  final Stream<Map<String, int>> movimientosTotalesStream;

  const MovimientosTotalesWidget(
      {required this.movimientosTotalesStream, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, int>>(
      stream: movimientosTotalesStream,
      builder: (context, snapshot) {
        // Mostrar un indicador de carga mientras se obtienen los datos
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Mostrar un mensaje de error en caso de que ocurra algún problema
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Mostrar mensaje si no hay datos disponibles
        if (!snapshot.hasData) {
          return const Center(child: Text('No hay datos disponibles'));
        }

        // Acceder a los datos desde el snapshot
        final data = snapshot.data!;
        final saldoDisponible = data['saldoDisponible']!;
        final totalIngresos = data['totalIngresos']!;
        final totalGastos = data['totalGastos']!;

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
