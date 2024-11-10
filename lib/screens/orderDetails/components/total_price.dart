import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';

class TotalPrice extends StatelessWidget {
  const TotalPrice({
    super.key,
    required this.price,
  });

  final int price;

  @override
  Widget build(BuildContext context) {
    // Format the price using NumberFormat
    final NumberFormat currencyFormat = NumberFormat('#,##0', 'vi_VN'); // Vietnamese format
    String formattedPrice = currencyFormat.format(price);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text.rich(
          TextSpan(
            text: "Total ",
            style: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: "(incl. VAT)",
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Text(
          "$formattedPrice VND", // Use the formatted price
          style:
          const TextStyle(color: titleColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}