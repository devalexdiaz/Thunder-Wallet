import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/presentation/pages/widget/movimientos_list.dart';
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
          title: const Center(child: Text("")),
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
        body: const SafeArea(
            child: Column(
          children: [
            Balance(),
            MovimientosHome()
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
