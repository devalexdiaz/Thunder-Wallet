import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/core/services/firebase_service.dart';
import 'package:wallet/data/repositories/movimiento_repository.dart';
import 'cards.dart'; // Asegúrate de que este archivo exista y sea accesible

class Balance extends StatelessWidget {
  const Balance({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(
        context); // Obtener FirebaseService del contexto
    final repository = MovimientoRepository(
        firebaseService); // Crear instancia del repositorio

    return Column(
      children: [
        _buildBalanceHeader(repository), // Pasar el repositorio
        _buildActionButtons(context),
        _buildCardList(),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }

  Widget _buildBalanceHeader(MovimientoRepository repository) {
    return StreamBuilder<Map<String, int>>(
      stream: repository.getMovimientosTotales(), // Usar el repositorio
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras se cargan los datos, mostrar una versión inicial
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No hay datos disponibles'));
        }

        // Acceder a los datos del snapshot
        final data = snapshot.data!;
        final saldoDisponible = data['saldoDisponible'] ?? 0;
        final totalIngresos = data['totalIngresos'] ?? 0;
        final totalGastos = data['totalGastos'] ?? 0;

        return Column(
          children: [
            // Saldo disponible
            Text(
              '\$${saldoDisponible.toString()}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Ingresos
                _buildBalanceColumn(
                  "Ingresos del mes", // Cambié a 'del mes' ya que el stream es mensual
                  '\$${totalIngresos.toString()}',
                  Colors.green,
                ),
                // Gastos
                _buildBalanceColumn(
                  "Gastos del mes", // Cambié a 'del mes' por el mismo motivo
                  '\$${totalGastos.toString()}',
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        );
      },
    );
  }

  Widget _buildBalanceColumn(String title, String amount, Color color) {
    return Column(
      children: [
        Text(title),
        const SizedBox(height: 5),
        Text(
          amount,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(context, 'Gasto', Icons.arrow_downward,
                  () async {
                await Navigator.pushNamed(context, '/add-gasto');
              }),
              _buildActionButton(context, 'Ingreso', Icons.arrow_upward,
                  () async {
                await Navigator.pushNamed(context, '/add-ingreso');
              }),
              _buildActionButton(context, 'Nuevo', Icons.add, () {}),
            ],
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  Widget _buildCardList() {
    return SizedBox(
      height: 58,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          SizedBox(width: 20),
          MyCard(
            cardType: 'Visa',
            cardNumber: '**** 5052',
            balance: '10.000.000',
            colors: [
              Color.fromARGB(255, 214, 53, 174),
              Color.fromARGB(255, 14, 99, 209),
            ],
          ),
          SizedBox(width: 10),
          MyCard(
            cardType: 'Visa',
            cardNumber: '**** 5052',
            balance: '10.000.000',
            colors: [
              Color.fromARGB(255, 177, 14, 209),
              Color.fromARGB(255, 182, 92, 8),
            ],
          ),
          SizedBox(width: 10),
          MyCard(
            cardType: 'Visa',
            cardNumber: '**** 5052',
            balance: '10.000.000',
            colors: [
              Color.fromARGB(255, 14, 99, 209),
              Color.fromARGB(255, 165, 190, 0),
            ],
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}

Widget _buildActionButton(
    BuildContext context, String label, IconData icon, VoidCallback onPressed) {
  return Column(
    children: [
      GestureDetector(
        onTap: onPressed, // Ejecuta la función cuando se toca el botón
        child: Container(
          width: 50, // Tamaño del círculo
          height: 50,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 31, 192, 192),
                Color.fromARGB(255, 14, 99, 209),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            shape: BoxShape.circle, // Forma circular
          ),
          child: Center(
            child: Icon(
              icon,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
      const SizedBox(height: 5),
      Text(label),
    ],
  );
}
