import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../price_range_and_food_type.dart';
import '../../rating_with_counter.dart';
import '../../small_dot.dart';
import 'big_card_image_slide.dart';

class RestaurantInfoBigCard extends StatelessWidget {
  final List<String> images, foodType;
  final String name;
  final double rating;
  final int numOfRating, deliveryTime;
  final bool isFreeDelivery;
  final VoidCallback press;

  const RestaurantInfoBigCard({
    super.key,
    required this.name,
    required this.rating,
    required this.numOfRating,
    required this.deliveryTime,
    this.isFreeDelivery = true,
    required this.images,
    required this.foodType,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure there is at least one image to display
    final imageToDisplay = images.isNotEmpty ? images : ['http://res.cloudinary.com/defqbfzkf/image/upload/v1730798080/tw3byf8fsdolpm3nept9.png']; // Placeholder image

    return InkWell(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pass the list of images here
          BigCardImageSlide(images: imageToDisplay),
          const SizedBox(height: defaultPadding / 2),
          Text(
            name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'Roboto'),
            maxLines: 1, // Limit to one line
            overflow: TextOverflow.ellipsis, // Handle overflow
          ),
          const SizedBox(height: defaultPadding / 4),
          PriceRangeAndFoodtype(foodType: foodType),
          const SizedBox(height: defaultPadding / 4),
          Row(
            children: [
              RatingWithCounter(rating: rating, numOfRating: numOfRating),
              const SizedBox(width: defaultPadding / 2),
              SvgPicture.asset(
                "assets/icons/clock.svg",
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(
                  Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.5),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "$deliveryTime Min",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: SmallDot(),
              ),
              SvgPicture.asset(
                "assets/icons/delivery.svg",
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(
                  Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.5),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(isFreeDelivery ? "Free" : "Paid",
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}