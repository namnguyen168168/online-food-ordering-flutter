import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<dynamic> orders = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserOrders();
  }

  Future<void> _fetchUserOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'Token not found. Please sign in again.';
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://foodsou.store/api/order/user'), // Replace with your actual endpoint
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = json.decode(decodedBody);

        // Sort orders by createdAt date in descending order
        data.sort((a, b) {
          DateTime dateA = DateTime.parse(a['createdAt']);
          DateTime dateB = DateTime.parse(b['createdAt']);
          return dateB.compareTo(dateA); // New to old
        });

        setState(() {
          orders = data; // Ensure this matches your API response structure
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load orders. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  String formatPrice(num price) {
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isNotEmpty
          ? ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${order['createdAt'] != null ? DateTime.parse(order['createdAt']).toLocal().toString() : 'N/A'}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Total Price: ${order['totalPrice'] != null ? '${formatPrice(order['totalPrice'] as num)} VND' : 'N/A'}'),
                  const SizedBox(height: 8),
                  Text('Delivery Address: ${order['deliveryAddress'] != null ? '${order['deliveryAddress']['streetAddress']}, ${order['deliveryAddress']['district']}, ${order['deliveryAddress']['city']}' : 'N/A'}'),
                  const SizedBox(height: 8),
                  Text('Phone: ${order['customer']['phone'] ?? 'N/A'}'),
                  const SizedBox(height: 8),
                  Text('Status: ${order['orderStatus'] ?? 'N/A'}'),
                ],
              ),
            ),
          );
        },
      )
          : Center(
        child: Text(
          errorMessage ?? 'No orders found.',
          style: const TextStyle(fontSize: 16, color: Colors.red),
        ),
      ),
    );
  }
}