import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../../../constants.dart';

class PriceRow extends StatelessWidget {
  const PriceRow({
    super.key,
    required this.text,
    required this.price,
  });

  final String text;
  final int price;

  @override
  Widget build(BuildContext context) {
    // Format the price using NumberFormat
    final NumberFormat currencyFormat = NumberFormat('#,##0', 'vi_VN'); // Vietnamese format
    String formattedPrice = currencyFormat.format(price);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(color: titleColor),
        ),
        Text(
          "$formattedPrice VND", // Use the formatted price
          style: const TextStyle(color: titleColor),
        ),
      ],
    );
  }
}