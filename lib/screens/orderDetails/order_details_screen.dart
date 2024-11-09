import 'package:flutter/material.dart';
import '../../components/buttons/primary_button.dart';
import '../../constants.dart';
import 'check_out.dart';
import 'components/order_item_card.dart';
import 'components/price_row.dart';
import 'components/total_price.dart';
import 'check_out.dart'; // Import your CheckoutScreen

class OrderDetailsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> orderedItems; // Accept ordered items

  const OrderDetailsScreen({super.key, required this.orderedItems}); // Keep this required

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late List<Map<String, dynamic>> _currentOrderedItems;

  @override
  void initState() {
    super.initState();
    _currentOrderedItems = List.from(widget.orderedItems); // Initialize current items
  }

  @override
  Widget build(BuildContext context) {
    // Calculate subtotal as int
    int subtotal = _currentOrderedItems.fold(0, (sum, item) {
      int price = item['price'] is int ? item['price'] : (item['price'] as num).toInt();
      int numOfItem = item['numOfItem'] is int ? item['numOfItem'] : (item['numOfItem'] as num).toInt();
      return sum + (price * numOfItem);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              const SizedBox(height: defaultPadding),
              // List of cart items
              ...List.generate(
                _currentOrderedItems.length,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                  child: OrderedItemCard(
                    title: _currentOrderedItems[index]["title"],
                    numOfItem: _currentOrderedItems[index]["numOfItem"],
                    price: _currentOrderedItems[index]["price"], // Use int price directly
                  ),
                ),
              ),
              PriceRow(text: "Subtotal", price: subtotal), // Update subtotal price
              const SizedBox(height: defaultPadding / 2),
              const PriceRow(text: "Delivery", price: 0),
              const SizedBox(height: defaultPadding / 2),
              TotalPrice(price: subtotal), // Display the computed subtotal
              const SizedBox(height: defaultPadding * 2),
              // Button to get more items
              PrimaryButton(
                text: "Get More Items",
                press: () {
                  Navigator.pop(context, _currentOrderedItems);
                },
              ),
              const SizedBox(height: defaultPadding),
              PrimaryButton(
                text: "Checkout (${subtotal} VND)", // Display subtotal as int
                press: () {
                  // Navigate to the CheckoutScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        orderedItems: _currentOrderedItems,
                        subtotal: subtotal,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}