import 'package:flutter/material.dart';

class PlanningView extends StatelessWidget {
  const PlanningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello Bilya!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text('Welcome back'),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('YOUR BALANCE', style: TextStyle(color: Colors.grey)),
            const Text(
              '\$41,379.00',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(context, 'Transfer', Icons.send),
                _buildActionButton(context, 'Withdraw', Icons.money_off),
                _buildActionButton(context, 'Top up', Icons.add),
              ],
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            const Text('Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildTransactionItem(
                'YouTube', 'Subscription Payment', '16 May 2024', '-\$15.00'),
            _buildTransactionItem(
                'Stripe', 'Monthly Salary', '15 May 2024', '+\$23,000.00'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          child: Icon(icon, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildTransactionItem(
      String title, String subtitle, String date, String amount) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
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
