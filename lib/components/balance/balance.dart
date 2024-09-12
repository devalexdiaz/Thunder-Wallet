import 'package:flutter/material.dart';
import 'cards.dart'; // Asegúrate de que este archivo exista y sea accesible

class Balance extends StatelessWidget {
  const Balance({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBalanceHeader(context),
        _buildActionButtons(context),
        _buildCardList(),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }

  Widget _buildBalanceHeader(BuildContext context) {
    return Column(
      children: [
        Text('DINERO DISPONIBLE',
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
        const Text(
          '\$100.379',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBalanceColumn(
                "Ingresos semanales", '\$471.379', Colors.green),
            _buildBalanceColumn("Gastos semanales", '\$411.379', Colors.red),
          ],
        ),
        const SizedBox(height: 15),
      ],
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
              _buildActionButton(
                  context, 'Inversión', Icons.monetization_on_outlined, () {}),
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
