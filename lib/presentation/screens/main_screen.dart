import 'package:flutter/material.dart';

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

    return Scaffold(
      // Establecer el color de fondo usando el esquema de colores
      backgroundColor: colors.surface,
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      bottomNavigationBar: NavigationBar(
        // Usar el color de la superficie para el fondo del NavigationBar
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
              color: colors.tertiary, // Color de icono no seleccionado
            ),
            selectedIcon: Icon(
              Icons.home,
              color: colors.tertiary, // Color de icono seleccionado
            ),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.insert_chart_outlined,
              color: colors.tertiary, // Color de icono no seleccionado
            ),
            selectedIcon: Icon(
              Icons.insert_chart,
              color: colors.tertiary, // Color de icono seleccionado
            ),
            label: 'Estadísticas',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
              color: colors.tertiary, // Color de icono no seleccionado
            ),
            selectedIcon: Icon(
              Icons.person,
              color: colors.tertiary, // Color de icono seleccionado
            ),
            label: 'Cuenta',
          ),
        ],
      ),
    );
  }
}
