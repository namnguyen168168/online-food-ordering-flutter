import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/buttons/primary_button.dart';
import '../../constants.dart';
import 'check_out.dart';
import 'components/order_item_card.dart';
import 'components/price_row.dart';
import 'components/total_price.dart';

class OrderDetailsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> orderedItems;

  const OrderDetailsScreen({super.key, required this.orderedItems});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late List<Map<String, dynamic>> _currentOrderedItems;

  @override
  void initState() {
    super.initState();
    _currentOrderedItems = List.from(widget.orderedItems);
  }

  @override
  Widget build(BuildContext context) {
    // Format the price using NumberFormat
    final NumberFormat currencyFormat = NumberFormat('#,##0', 'vi_VN');

    // Calculate subtotal
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
                    price: _currentOrderedItems[index]["price"],
                  ),
                ),
              ),
              PriceRow(text: "Subtotal", price: subtotal), // Pass formatted subtotal
              const SizedBox(height: defaultPadding / 2),
              const PriceRow(text: "Delivery", price: 0),
              const SizedBox(height: defaultPadding / 2),
              TotalPrice(price: subtotal), // Pass formatted total price
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
                text: "Checkout (${currencyFormat.format(subtotal)} VND)", // Use formatted subtotal
                press: () {
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