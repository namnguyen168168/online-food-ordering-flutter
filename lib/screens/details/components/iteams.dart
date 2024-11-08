import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../components/cards/iteam_card.dart';
import '../../../constants.dart';
import '../../addToOrder/add_to_order_screen.dart';

class Items extends StatefulWidget {
  final String restaurantId; // Pass restaurant ID to fetch items

  const Items({super.key, required this.restaurantId});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> with SingleTickerProviderStateMixin {
  List<dynamic> _menuItems = [];
  List<dynamic> _categories = [];
  bool _isLoading = true;
  late TabController _tabController; // TabController for managing tabs
  int _selectedCategoryIndex = 0; // Track the selected category index

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch categories on initialization
    _fetchMenuItems();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('https://foodsou.store/api/restaurants/category/${widget.restaurantId}'));

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        print('Decoded Categories Response body: $decodedBody');

        final List<dynamic> data = json.decode(decodedBody);
        setState(() {
          _categories = data; // Update the categories
          _tabController = TabController(length: data.length + 1, vsync: this); // +1 for the "Menu" tab
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> _fetchMenuItems() async {
    try {
      final response = await http.get(Uri.parse('https://foodsou.store/api/restaurants/food/${widget.restaurantId}'));

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        print('Decoded Menu Items Response body: $decodedBody');

        final List<dynamic> data = json.decode(decodedBody);
        setState(() {
          _menuItems = data; // Update the menu items
          _isLoading = false; // Stop loading
        });
      } else {
        throw Exception('Failed to load menu items');
      }
    } catch (e) {
      print('Error fetching menu items: $e');
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Use SingleChildScrollView for scrolling
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _categories.isEmpty
              ? Center(child: CircularProgressIndicator())
              : DefaultTabController(
            length: _categories.length + 1, // +1 for the "Menu" tab
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  unselectedLabelColor: titleColor,
                  labelStyle: Theme.of(context).textTheme.titleLarge,
                  indicatorColor: primaryColor, // Customize indicator color
                  onTap: (index) {
                    setState(() {
                      _selectedCategoryIndex = index; // Set category index directly
                    });
                  },
                  tabs: [
                    const Tab(child: Text('Menu')), // Add "Menu" tab
                  ]..addAll(_categories.map((category) {
                    return Tab(child: Text(category['name'])); // Assuming each category has a 'name' field
                  }).toList()),
                ),
                SizedBox(height: defaultPadding), // Optional spacing below TabBar
              ],
            ),
          ),
          // Use a ListView directly for the items
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _menuItems.isEmpty
              ? Center(child: Text("No menu items available."))
              : ListView.builder(
            physics: NeverScrollableScrollPhysics(), // Disable scrolling for inner ListView
            shrinkWrap: true, // Wrap ListView to take only the needed space
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              final item = _menuItems[index];

              // Handle the images field
              final images = item['images'];
              final imageUrl = (images is List && images.isNotEmpty) ? images[0] : "assets/images/thit_nuong.jpg";

              // Extract food category name from the nested object
              final foodCategory = item['foodCategory']['name'] ?? "Unknown";

              // Show all items when the "Menu" tab is selected (index 0)
              if (_selectedCategoryIndex == 0 ||
                  (item['foodCategory']['id'] == _categories[_selectedCategoryIndex - 1]['id'])) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  child: ItemCard(
                    name: item['name'] ?? "No title available",
                    description: item['description'] ?? "No description available",
                    images: imageUrl, // Use the selected image URL
                    foodCategory: foodCategory, // Use the extracted food category name
                    price: (item['price'] is int) ? item['price'] as int : ((item['price'] as double?)?.toInt() ?? 0),
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddToOrderScrreen(
                            name: item['name'],
                            description: item['description'],
                            images: imageUrl,
                            foodCategory: foodCategory,
                            price: (item['price'] is int) ? item['price'] as int : ((item['price'] as double?)?.toInt() ?? 0),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return Container(); // Skip if not showing
            },
          ),
        ],
      ),
    );
  }
}