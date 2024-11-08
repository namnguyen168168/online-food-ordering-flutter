import 'package:flutter/material.dart';
import '../../../constants.dart';

class OrderedItemCard extends StatelessWidget {
  const OrderedItemCard({
    super.key,
    required this.numOfItem,
    required this.title,
    required this.price,
  });

  final int numOfItem;
  final String? title;
  final int price; // Change price to int

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NumOfItems(numOfItem: numOfItem),
            const SizedBox(width: defaultPadding * 0.75),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: defaultPadding / 4),

                ],
              ),
            ),
            const SizedBox(width: defaultPadding / 2),
            Text(
              "$price VND", // No change needed here, price is now int
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: primaryColor),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding / 2),
        const Divider(),
      ],
    );
  }
}

class NumOfItems extends StatelessWidget {
  const NumOfItems({
    super.key,
    required this.numOfItem,
  });

  final int numOfItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
            width: 0.5, color: const Color(0xFF868686).withOpacity(0.3)),
      ),
      child: Text(
        numOfItem.toString(),
        style: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(color: primaryColor),
      ),
    );
  }
}