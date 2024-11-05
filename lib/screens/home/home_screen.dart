import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../components/cards/big/restaurant_info_big_card.dart';
import '../../components/section_title.dart';
import '../../constants.dart';
import '../../screens/filter/filter_screen.dart';
import '../../screens/findRestaurants/find_restaurants_screen.dart';
import '../details/components/restaurrant_info.dart';
import '../featured/featurred_screen.dart';
import '../search/search_screen.dart';
import 'components/promotion_banner.dart';
import 'event_card.dart';
import 'restaurant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Restaurant> _restaurants = [];
  List<dynamic> _events = []; // List to store events
  bool _isLoading = true;
  bool _isEventsLoading = true; // Loading state for events
  String _selectedLocation = "Hà Nội"; // Default location

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
    _fetchEvents(); // Fetch events on initialization
  }

  Future<void> _fetchRestaurants() async {
    try {
      final response = await http.get(Uri.parse('https://foodsou.store/api/restaurants'));

      // Decode the response body
      final decodedBody = utf8.decode(response.bodyBytes);
      print('Decoded Response body: $decodedBody');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(decodedBody);
        setState(() {
          _restaurants = data.map((json) => Restaurant.fromJson(json)).toList();
          _isLoading = false; // Update loading state
        });
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      print('Error fetching restaurants: $e');
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('https://foodsou.store/api/public/event'));

      if (response.statusCode == 200) {
        // Decode the response body directly
        final decodedBody = utf8.decode(response.bodyBytes);
        print('Decoded Response body: $decodedBody'); // Debug output

        // Parse the JSON data after decoding
        final List<dynamic> data = json.decode(decodedBody);
        setState(() {
          _events = data; // Store events in the state
          _isEventsLoading = false; // Update loading state for events
        });
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        _isEventsLoading = false; // Stop loading
      });
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
              _selectedLocation,
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
              final location = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) => const FindRestaurantsScreen(),
                ),
              );
              if (location != null && location.isNotEmpty) {
                setState(() {
                  _selectedLocation = location;
                });
              } else {
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

              // Display events
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  "Upcoming Events",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: defaultPadding),

              // Check if loading events
              if (_isEventsLoading)
                Center(child: CircularProgressIndicator())
              else
              // Display list of events
                ..._events.map((event) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 8.0),
                    child: EventCard(
                      title: event['title'],
                      description: event['description'],
                      image: event['image'],
                      startAt: event['startAt'],
                      endAt: event['endAt'],
                    ),
                  );
                }),

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

              // Check if loading restaurants
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
              // Display list of restaurants
                ..._restaurants.map((restaurant) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, defaultPadding),
                    child: RestaurantInfoBigCard(
                      images: restaurant.images.isNotEmpty ? restaurant.images : [],
                      name: restaurant.name,
                      rating: restaurant.rating,
                      numOfRating: restaurant.numOfRatings,
                      deliveryTime: restaurant.deliveryTime,
                      foodType: restaurant.foodTypes,
                      press: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantInfo(restaurantId: restaurant.id.toString()),
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}