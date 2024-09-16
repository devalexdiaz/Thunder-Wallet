import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/components/movimientos/movimientos_list.dart';
import '../../components/balance/balance.dart';
//import '../../components/transactions/transactions_home.dart';
import '../../theme/theme_provider.dart';
import '../../theme/widget/theme_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Column(
            children: [
              const SizedBox(
                height: 35,
              ),
              Center(
                  child: Text(
                'SALDO DISPONIBLE',
                style: TextStyle(
                  //backgroundColor: Theme.of(context).colorScheme.surface,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 17,
                ),
              )),
            ],
          ),
          actions: [
            ThemeButton(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ],
          // Volver a mirar la gestion de estado de este widget
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Abre el Drawer
              },
            );
          }),
        ),
        body: SafeArea(
            child: Column(
          children: [
            const Balance(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: const Text('Transacciones Recientes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const MovimientosHome()
            //TransactionsHome(),
          ],
        )));
  }
}

class MovimientosHome extends StatelessWidget {
  const MovimientosHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: MovimientosList());
  }
}
