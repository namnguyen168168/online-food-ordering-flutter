import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Order> orders = [];
  bool isLoading = true;
  String? errorMessage;

  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchOrderHistory();
  }

  Future<void> fetchOrderHistory() async {
    try {
      // Retrieve the JWT token
      String? jwtToken = await storage.read(key: 'jwt_token');

      // Make the API request with the token in the headers
      final response = await http.get(
        Uri.parse('https://foodsou.store/api/order/user'),
        headers: {
          'Authorization': 'Bearer $jwtToken', // Include the token in the headers
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          orders = data.map((order) => Order.fromJson(order)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load orders';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text('Order ID: ${order.id}'),
              subtitle: Text('Total: ${order.total} VND\nDate: ${order.date}'),
            ),
          );
        },
      ),
    );
  }
}

class Order {
  final int id;
  final double total;
  final String date;

  Order({required this.id, required this.total, required this.date});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      total: json['total'],
      date: json['created_at'], // Adjust this key based on the API response
    );
  }
}