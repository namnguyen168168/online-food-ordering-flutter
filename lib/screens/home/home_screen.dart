import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../components/cards/big/big_card_image_slide.dart';
import '../../components/cards/big/restaurant_info_big_card.dart';
import '../../components/section_title.dart';
import '../../constants.dart';
import '../../demo_data.dart';
import '../../screens/filter/filter_screen.dart';
import '../../screens/findRestaurants/find_restaurants_screen.dart';
import '../details/components/restaurrant_info.dart';
import '../featured/featurred_screen.dart';
import '../search/search_screen.dart';
import 'components/medium_card_list.dart';
import 'components/promotion_banner.dart';
import 'restaurant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Restaurant> _restaurants = [];
  bool _isLoading = true;
  String _selectedLocation = "Ha Noi"; // Default location

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    final response = await http.get(Uri.parse('https://foodsou.store/api/restaurants'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _restaurants = data.map((json) => Restaurant.fromJson(json)).toList();
        _isLoading = false; // Update loading state
      });
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: Column(
          children: [
            Text(
              "Location".toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: primaryColor),
            ),
            Text(
              _selectedLocation, // Display the selected location
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilterScreen(),
                ),
              );
            },
            child: Text(
              "Filter",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TextButton(
            onPressed: () async {
              // Navigate to FindRestaurantsScreen and await the returned location
              final location = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) => const FindRestaurantsScreen(),
                ),
              );
              // Check if location is not null or empty
              if (location != null && location.isNotEmpty) {
                setState(() {
                  _selectedLocation = location; // Update location state
                });
              } else {
                // Handle case where no location was returned
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No location selected.")),
                );
              }
            },
            child: Text(
              "Change Location",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: BigCardImageSlide(images: demoBigImages),
              ),
              const SizedBox(height: defaultPadding * 2),
              SectionTitle(
                title: "Featured Partners",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),

              const PromotionBanner(),
              const SizedBox(height: 20),
              SectionTitle(
                title: "All Restaurants",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Check if loading
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
              // Display list of restaurants
                ..._restaurants.map((restaurant) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, defaultPadding),
                    child: RestaurantInfoBigCard(
                      images: demoBigImages..shuffle(),
                      name: restaurant.name,
                      rating: restaurant.rating,
                      numOfRating: restaurant.numOfRatings,
                      deliveryTime: restaurant.deliveryTime,
                      foodType: restaurant.foodTypes,
                      press: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantInfo(restaurantId: restaurant.id.toString()), // Pass the restaurant ID
                        ),
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}