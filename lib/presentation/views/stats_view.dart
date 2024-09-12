import 'package:flutter/material.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
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
