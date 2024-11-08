import 'package:flutter/material.dart';

import '../../../components/price_range_and_food_type.dart';
import '../../../constants.dart';

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.name,
    required this.description,
    required this.images,
    required this.foodCategory,
    required this.price,
  });

  final String name;
  final String description;
  final String images;
  final String foodCategory;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.33,
          child: Image.asset(
            "assets/images/Header-image.png",
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: defaultPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                "Shortbread, chocolate turtle cookies, and red velvet. 8 ounces cream cheese, softened.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              const PriceRangeAndFoodtype(
                foodType: ["Chinese", "American", "Deshi food"],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
