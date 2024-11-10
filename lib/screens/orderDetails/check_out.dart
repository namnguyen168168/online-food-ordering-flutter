import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'credit_card_payment_screen.dart'; // Import your payment screen

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> orderedItems;
  final int subtotal;

  const CheckoutScreen({
    super.key,
    required this.orderedItems,
    required this.subtotal,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? paymentMethod; // Variable to store selected payment method

  @override
  Widget build(BuildContext context) {
    // Format the price using NumberFormat
    final NumberFormat currencyFormat = NumberFormat('#,##0', 'vi_VN'); // Vietnamese format

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Amount: ${currencyFormat.format(widget.subtotal)} VND', // Use formatted subtotal
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display ordered items
            Expanded(
              child: ListView.builder(
                itemCount: widget.orderedItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.orderedItems[index]['title']),
                    subtitle: Text('Quantity: ${widget.orderedItems[index]['numOfItem']}'),
                    trailing: Text('${currencyFormat.format(widget.orderedItems[index]['price'])} VND'), // Use formatted price
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Payment method selection
            const Text(
              'Select Payment Method:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Credit/Debit Card option
            ListTile(
              title: const Text('Credit/Debit Card'),
              leading: Radio<String>(
                value: 'card',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value;
                  });
                },
              ),
            ),
            // PayPal option
            ListTile(
              title: const Text('PayPal'),
              leading: Radio<String>(
                value: 'paypal',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value;
                  });
                },
              ),
            ),
            // Cash on Delivery option
            ListTile(
              title: const Text('Cash on Delivery'),
              leading: Radio<String>(
                value: 'cash',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            // Confirm order button
            ElevatedButton(
              onPressed: () {
                if (paymentMethod != null) {
                  if (paymentMethod == 'card' || paymentMethod == 'paypal') {
                    // Navigate to the payment screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreditCardPaymentScreen(
                          orderedItems: widget.orderedItems,
                          subtotal: widget.subtotal,
                        ),
                      ),
                    );
                  } else if (paymentMethod == 'cash') {
                    // Handle cash on delivery
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order confirmed! Cash on delivery selected.')),
                    );
                    // Optionally navigate to a confirmation screen or back to home
                    Navigator.pop(context);
                  }
                } else {
                  // Show an error message if no payment method is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a payment method.')),
                  );
                }
              },
              child: const Text("Confirm Order"),
            ),
          ],
        ),
      ),
    );
  }
}