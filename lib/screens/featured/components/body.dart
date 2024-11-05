import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../components/cards/big/restaurant_info_big_card.dart';
import '../../../components/scalton/big_card_scalton.dart';
import '../../../constants.dart';
import '../../../demo_data.dart';
import '../../details/components/restaurrant_info.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<dynamic> _restaurants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    try {
      final response = await http.get(Uri.parse('https://foodsou.store/api/restaurants'));

      if (response.statusCode == 200) {
        // Decode the response body
        final decodedBody = utf8.decode(response.bodyBytes);
        print('Decoded Response body: $decodedBody');

        // Parse the JSON data
        final List<dynamic> data = json.decode(decodedBody);

        // Update the state with the first four restaurants
        setState(() {
          _restaurants = data.take(4).toList(); // Take the first 4 restaurants
          isLoading = false; // Update loading state
        });
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      // Handle errors accordingly
      setState(() {
        isLoading = false; // Stop loading in case of error
      });
      print(e); // Print the error for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: ListView.builder(
          itemCount: isLoading ? 3 : _restaurants.length, // Show 3 skeletons while loading
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: isLoading
                ? const BigCardScalton()
                : RestaurantInfoBigCard(
              images: List<String>.from(_restaurants[index]['images'])..shuffle(), // Safely convert to List<String>
              name: _restaurants[index]['name'] as String,
              rating: (_restaurants[index]['rating'] as num?)?.toDouble() ?? 0.0, // Handle potential null
              numOfRating: (_restaurants[index]['numOfRatings'] as int?) ?? 0, // Handle potential null
              deliveryTime: (_restaurants[index]['deliveryTime'] as int?) ?? 0, // Handle potential null
              foodType: (_restaurants[index]['cuisineType'] as String).split(', '), // Assuming food types are comma-separated
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantInfo(restaurantId: _restaurants[index]['id'].toString()), // Pass the restaurant ID
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}