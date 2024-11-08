import 'package:flutter/material.dart';

import '../../components/buttons/primary_button.dart';
import '../../constants.dart';
import 'components/order_item_card.dart';
import 'components/price_row.dart';
import 'components/total_price.dart';

class OrderDetailsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orderedItems; // Accept ordered items

  const OrderDetailsScreen({super.key, required this.orderedItems}); // Keep this required

  @override
  Widget build(BuildContext context) {
    // Calculate subtotal as int
    int subtotal = orderedItems.fold(0, (sum, item) {
      // Ensure both price and numOfItem are treated as int
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
                orderedItems.length,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                  child: OrderedItemCard(
                    title: orderedItems[index]["title"],

                    numOfItem: orderedItems[index]["numOfItem"],
                    price: orderedItems[index]["price"], // Use int price directly
                  ),
                ),
              ),
              PriceRow(text: "Subtotal", price: subtotal), // Update subtotal price
              const SizedBox(height: defaultPadding / 2),
              const PriceRow(text: "Delivery", price: 0),
              const SizedBox(height: defaultPadding / 2),
              TotalPrice(price: subtotal), // Display the computed subtotal
              const SizedBox(height: defaultPadding * 2),
              PrimaryButton(
                text: "Checkout (${subtotal} VND)", // Display subtotal as int
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}