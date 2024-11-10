import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../components/price_range_and_food_type.dart';
import '../../../components/rating_with_counter.dart';
import '../../../constants.dart';
import '../../home/restaurant.dart';
import 'featured_items.dart';
import 'iteams.dart';

class RestaurantInfo extends StatefulWidget {
  final String restaurantId; // Pass restaurant ID to fetch data

  const RestaurantInfo({super.key, required this.restaurantId});

  @override
  _RestaurantInfoState createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  Restaurant? restaurant;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRestaurantData();
  }

  Future<void> _fetchRestaurantData() async {
    try {
      final response = await http.get(Uri.parse('https://foodsou.store/api/restaurants/${widget.restaurantId}'));

      // Decode the response body
      final decodedBody = utf8.decode(response.bodyBytes);
      print('Decoded Response body: $decodedBody');
      if (response.statusCode == 200) {
        final data = json.decode(decodedBody);
        setState(() {
          restaurant = Restaurant.fromJson(data);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load restaurant');
      }
    } catch (e) {
      print("Error fetching restaurant data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (restaurant == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(child: Text("No restaurant found")),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Restaurant Info"),
      ),
      body: SingleChildScrollView( // Make the Column scrollable
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurant!.name,
              style: Theme.of(context).textTheme.headlineMedium,
              maxLines: 1,
            ),
            const SizedBox(height: defaultPadding / 2),
            PriceRangeAndFoodtype(foodType: restaurant!.foodTypes),
            const SizedBox(height: defaultPadding / 2),
            RatingWithCounter(rating: restaurant!.rating, numOfRating: restaurant!.numOfRatings),
            const SizedBox(height: defaultPadding),
            Row(
              children: [
                DeliveryInfo(
                  iconSrc: "assets/icons/delivery.svg",
                  text: restaurant!.deliveryInfo,
                  subText: "Delivery order on App",
                ),
                const SizedBox(width: defaultPadding),

                const Spacer(),
                OutlinedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Take away"),
                ),
              ],
            ),


            const SizedBox(height: defaultPadding), // Add spacing before items
            Items(restaurantId: widget.restaurantId), // Add Items widget
          ],
        ),
      ),
    );
  }
}

class DeliveryInfo extends StatelessWidget {
  const DeliveryInfo({
    super.key,
    required this.iconSrc,
    required this.text,
    required this.subText,
  });

  final String iconSrc, text, subText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconSrc,
          height: 20,
          width: 20,
          colorFilter: const ColorFilter.mode(
            primaryColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            text: "$text\n",
            style: Theme.of(context).textTheme.labelLarge,
            children: [
              TextSpan(
                text: subText,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
      ],
    );
  }
}