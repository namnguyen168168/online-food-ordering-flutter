import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileInformationScreen extends StatefulWidget {
  const ProfileInformationScreen({super.key});

  @override
  _ProfileInformationScreenState createState() => _ProfileInformationScreenState();
}

class _ProfileInformationScreenState extends State<ProfileInformationScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
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
        Uri.parse('https://foodsou.store/api/users/profile'), // Replace with your actual endpoint
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = json.decode(decodedBody);
        setState(() {
          userData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load user data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF22A45D),
        foregroundColor: Colors.white,
        title: const Text("Profile Information"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData != null
          ? SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              userData!['fullName'] ?? 'N/A',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              userData!['email'] ?? 'N/A',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            const Divider(height: 32.0),
            _buildInfoRow("Phone", userData!['phone'] ?? 'N/A'),
            _buildInfoRow("Role", userData!['role'] ?? 'N/A'),
            _buildInfoRow("Address", userData!['addresses'] != null && userData!['addresses'].isNotEmpty
                ? '${userData!['addresses'][0]['streetAddress']}, ${userData!['addresses'][0]['district']}, ${userData!['addresses'][0]['city']}'
                : 'N/A'),
            _buildInfoRow("Favorites", userData!['favorites']?.isNotEmpty == true ? userData!['favorites'].join(', ') : 'N/A'),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 160,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22A45D),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text("Edit Profile"),
                ),
              ),
            ),
          ],
        ),
      )
          : Center(
        child: Text(
          errorMessage ?? 'No user data available.',
          style: const TextStyle(fontSize: 16, color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}