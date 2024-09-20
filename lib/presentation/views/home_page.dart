import 'package:flutter/material.dart';
import 'package:wallet/presentation/components/movimientos/movimientos_list.dart';
import '../components/balance/balance.dart';
//import '../../components/transactions/transactions_home.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Balance(), // Parte fija
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: const Text(
              'Transacciones Recientes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
            child: MovimientosHome(), // ListView que se desplaza
          ),
        ],
      ),
    );
  }
}

class MovimientosHome extends StatelessWidget {
  const MovimientosHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MovimientosList(); // Asegúrate de que este widget maneje su propio scroll
  }
}
