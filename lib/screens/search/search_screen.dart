import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../components/cards/big/restaurant_info_big_card.dart';
import '../../components/scalton/big_card_scalton.dart';
import '../../constants.dart';
import '../details/components/restaurrant_info.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _showSearchResult = false;
  bool _isLoading = false;
  List<dynamic> _searchResults = [];

  void showResult(String query) {
    setState(() {
      _isLoading = true; // Start loading
      _showSearchResult = false; // Reset search results
    });

    // Fetch restaurants based on the query
    _fetchRestaurants(query);
  }

  Future<void> _fetchRestaurants(String query) async {
    try {
      final response = await http.get(Uri.parse('https://foodsou.store/api/restaurants'));

      if (response.statusCode == 200) {
        // Decode the response body
        final decodedBody = utf8.decode(response.bodyBytes);
        print('Decoded Response body: $decodedBody');

        // Parse the JSON data
        final List<dynamic> data = json.decode(decodedBody);

        // Update the state with filtered search results
        setState(() {
          // Filter the results based on the search query
          _searchResults = data.where((restaurant) {
            final name = restaurant['name'].toLowerCase();
            return name.contains(query.toLowerCase()); // Check if the name contains the query
          }).toList();

          _showSearchResult = true; // Show search results
          _isLoading = false; // Stop loading
        });
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      print("Error fetching restaurants: $e");
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              SearchForm(showResult: showResult),
              const SizedBox(height: defaultPadding),
              Text(
                _showSearchResult ? "Search Results" : "Top Restaurants",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: ListView.builder(
                  itemCount: _isLoading ? 2 : _searchResults.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: _isLoading
                        ? const BigCardScalton()
                        : RestaurantInfoBigCard(
                      images: List<String>.from(_searchResults[index]['images'])..shuffle(),
                      name: _searchResults[index]['name'],
                      rating: (_searchResults[index]['rating']?.toDouble() ?? 0.0),
                      numOfRating: _searchResults[index]['numOfRatings'] ?? 0,
                      deliveryTime: _searchResults[index]['deliveryTime'] ?? 0,
                      foodType: List<String>.from(_searchResults[index]['cuisineType'].split(', ')),
                      press: () {
                        // Navigate to restaurant detail
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantInfo(
                              restaurantId: _searchResults[index]['id'].toString(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchForm extends StatefulWidget {
  final Function(String) showResult;

  const SearchForm({super.key, required this.showResult});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  String? _searchQuery;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        onChanged: (value) {
          _searchQuery = value; // Capture the input
        },
        onFieldSubmitted: (value) {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            widget.showResult(_searchQuery!); // Trigger search
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a search term';
          }
          return null; // Valid input
        },
        style: Theme.of(context).textTheme.labelLarge,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Search on foodSou",
          contentPadding: kTextFieldPadding,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: const ColorFilter.mode(
                bodyTextColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}