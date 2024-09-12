import 'package:flutter/material.dart';

class TransactionsHome extends StatelessWidget {
  const TransactionsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Últimas transacciones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 15,
        ),
        _buildTransactionItem(
            'YouTube', 'Suscripción mensual', '16 May 2024', '-\$15.00'),
        _buildTransactionItem(
            'Stripe', 'Salario mensual', '15 May 2024', '+\$23,000.00'),
        _buildTransactionItem(
            'Amazon', 'Suscripción mensual', '20 May 2024', '-\$23.00'),
      ],
    );
  }

  Widget _buildTransactionItem(
      String title, String subtitle, String date, String amount) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(amount,
              style: TextStyle(
                  color: amount.startsWith('-') ? Colors.red : Colors.green)),
          Text(date, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
