import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../theme/widget/theme_button.dart';
import '../views/home_page.dart';
import '../views/planning_view.dart';
import '../views/stats_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Acceder al esquema de colores desde el tema actual
    final colors = Theme.of(context).colorScheme;

    final screens = [
      const HomeView(),
      const StatsView(),
      const PlanningView(),
    ];

    // Definir el AppBar en función del índice seleccionado
    getAppBar() {
      switch (selectedIndex) {
        case 0:
          return const AppBarHome();
        case 1:
          return AppBar(
            backgroundColor: colors.surface,
            title: Text(
              'Estadísticas',
              style: TextStyle(
                color: colors.tertiary,
              ),
            ),
          );
        case 2:
          return AppBar(
            backgroundColor: colors.surface,
            title: Text(
              'Planeación',
              style: TextStyle(
                color: colors.tertiary,
              ),
            ),
          );
        default:
          return AppBar();
      }
    }

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(60.0), // Altura fija para evitar cambios
        child: getAppBar(),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: colors.surface,
        selectedIndex: selectedIndex,
        onDestinationSelected: (int value) {
          setState(() {
            selectedIndex = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: colors.tertiary,
            ),
            selectedIcon: Icon(
              Icons.home,
              color: colors.tertiary,
            ),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.insert_chart_outlined,
              color: colors.tertiary,
            ),
            selectedIcon: Icon(
              Icons.insert_chart,
              color: colors.tertiary,
            ),
            label: 'Estadísticas',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
              color: colors.tertiary,
            ),
            selectedIcon: Icon(
              Icons.person,
              color: colors.tertiary,
            ),
            label: 'Cuenta',
          ),
        ],
      ),
    );
  }
}

class AppBarHome extends StatelessWidget {
  const AppBarHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
              backgroundColor: Theme.of(context).colorScheme.surface,
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 17,
            ),
          )),
        ],
      ),
      actions: [
        ThemeButton(
          onTap: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
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
    );
  }
}
