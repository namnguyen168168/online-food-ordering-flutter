import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'featured_item_card.dart';
import '../../addToOrder/add_to_order_screen.dart';

class FeaturedItems extends StatelessWidget {
  const FeaturedItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text("Featured Items",
              style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: defaultPadding / 2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                3, // for demo we use 3
                    (index) => Padding(
                  padding: const EdgeInsets.only(left: defaultPadding),
                  child: FeaturedItemCard(
                    title: "Cookie Sandwich",
                    image: "assets/images/thit_nuong.jpg",
                    foodType: "Chinese",
                    priceRange: "\$" * 2,
                    press: () {
                      }, // Updated press callback
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
            ],
          ),
        ),
      ],
    );
  }
}