import 'package:flutter/material.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Estadísticas")),
      ),
      body: const Center(
        child: Text(
          "Estadísticas",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
