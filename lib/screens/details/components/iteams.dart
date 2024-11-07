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
  bool _isLoading = true;
  late TabController _tabController; // TabController for managing tabs

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
    _tabController = TabController(length: demoTabs.length, vsync: this);
  }

  Future<void> _fetchMenuItems() async {
    try {
      final response = await http.get(Uri.parse('https://foodsou.store/api/restaurants/food/${widget.restaurantId}'));

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        print('Decoded Response body: $decodedBody');

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
          DefaultTabController(
            length: demoTabs.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  unselectedLabelColor: titleColor,
                  labelStyle: Theme.of(context).textTheme.titleLarge,
                  indicatorColor: primaryColor, // Customize indicator color
                  tabs: demoTabs,
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

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 2),
                child: ItemCard(
                  name: item['name'] ?? "No title available",
                  description: item['description'] ?? "No description available",
                  images: imageUrl, // Use the selected image URL
                  foodCategory: item['foodType'] ?? "Unknown",
                  price: (item['price'] is int)
                      ? item['price'] as int
                      : ((item['price'] as double?)?.toInt() ?? 0),
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddToOrderScrreen(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

final List<Tab> demoTabs = <Tab>[
  const Tab(child: Text('Most Populars')),
  const Tab(child: Text('Main Course')),
  const Tab(child: Text('Seafood')),
  const Tab(child: Text('Appetizers')),
  const Tab(child: Text('Drinks')),
];