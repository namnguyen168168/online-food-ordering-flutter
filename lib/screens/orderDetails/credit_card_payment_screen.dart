import 'package:flutter/material.dart';

class CreditCardPaymentScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orderedItems;
  final int subtotal;

  const CreditCardPaymentScreen({
    Key? key,
    required this.orderedItems,
    required this.subtotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Amount: $subtotal VND',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display ordered items
            Expanded(
              child: ListView.builder(
                itemCount: orderedItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(orderedItems[index]['title']),
                    subtitle: Text('Quantity: ${orderedItems[index]['numOfItem']}'),
                    trailing: Text('${orderedItems[index]['price']} VND'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Credit card input fields
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Expiry Date (MM/YY)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'CVV',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // Submit payment button
            ElevatedButton(
              onPressed: () {
                // Simulate payment processing. Replace with actual payment logic.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payment successful!')),
                );

                // Optionally navigate back or to a confirmation screen
                Navigator.pop(context);
              },
              child: const Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}