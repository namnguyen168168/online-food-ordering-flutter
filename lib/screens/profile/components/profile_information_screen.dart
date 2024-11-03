import 'package:flutter/material.dart';

class ProfileInformationScreen extends StatelessWidget {
  const ProfileInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Information"),
      ),
      body: Center(
        child: Text("Profile Information Screen"),
      ),
    );
  }
}