import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

import '../../constants.dart';
import '../orderDetails/order_details_screen.dart';

class AddToOrderScreen extends StatefulWidget {
  final String name;
  final String description;
  final String images;
  final String foodCategory;
  final int price;

  const AddToOrderScreen({
    super.key,
    required this.name,
    required this.description,
    required this.images,
    required this.foodCategory,
    required this.price,
  });

  @override
  State<AddToOrderScreen> createState() => _AddToOrderScreenState();
}

class _AddToOrderScreenState extends State<AddToOrderScreen> {
  int numOfItems = 1;

  @override
  Widget build(BuildContext context) {
    // Format the price using NumberFormat
    final NumberFormat currencyFormat = NumberFormat('#,##0', 'vi_VN'); // Vietnamese format
    String formattedPrice = currencyFormat.format(widget.price);
    String totalFormattedPrice = currencyFormat.format(widget.price * numOfItems);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Add To Order"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              backgroundColor: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.images,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(widget.foodCategory, style: TextStyle(color: bodyTextColor)),
                    const SizedBox(height: defaultPadding),
                    Text(widget.description),
                    const SizedBox(height: defaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (numOfItems > 1) numOfItems--;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.remove),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                          child: Text(numOfItems.toString().padLeft(2, "0"),
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                numOfItems++;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding),
                    ElevatedButton(
                      onPressed: () {
                        // Prepare selected item data
                        final selectedItem = {
                          "title": widget.name,
                          "price": widget.price,
                          "numOfItem": numOfItems,
                        };

                        // Navigate to OrderDetailsScreen with the new item
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailsScreen(
                              orderedItems: [selectedItem], // Pass the item in a list
                            ),
                          ),
                        );
                      },
                      child: Text("Add to Order (${totalFormattedPrice} VND)"), // Use formatted total price
                    ),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding)
            ],
          ),
        ),
      ),
    );
  }
}