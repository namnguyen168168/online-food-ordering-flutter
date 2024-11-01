import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import '../../entry_point.dart';
import '../../components/buttons/secondery_button.dart';
import '../../components/welcome_text.dart';
import '../../constants.dart';

class FindRestaurantsScreen extends StatefulWidget {
  const FindRestaurantsScreen({super.key});

  @override
  _FindRestaurantsScreenState createState() => _FindRestaurantsScreenState();
}

class _FindRestaurantsScreenState extends State<FindRestaurantsScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  String? _locationAddress;
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // Convert position to a string for display (for demo purposes)
      setState(() {
        _locationAddress = "${position.latitude}, ${position.longitude}";
        _isLoading = false; // Hide loading indicator
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      // Handle error and show a message to the user
      print("Error getting location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not get current location.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EntryPoint(),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Find restaurants near you ",
                text:
                "Please enter your location or allow access to \nyour location to find restaurants near you.",
              ),

              // Current Location Button
              SeconderyButton(
                press: _getCurrentLocation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/location.svg",
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Use current location",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: primaryColor),
                    ),
                    if (_isLoading) const CircularProgressIndicator(), // Show loading indicator
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),

              // New Address Form
              Form(
                key: _formKey, // Assign the form key
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/marker.svg",
                            colorFilter: const ColorFilter.mode(
                                bodyTextColor, BlendMode.srcIn),
                          ),
                        ),
                        hintText: "Enter a new address",
                        contentPadding: kTextFieldPadding,
                      ),
                      onSaved: (value) {
                        if (value != null) {
                          _locationAddress = value; // Save the new address
                        }
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: titleColor),
                      cursorColor: primaryColor,
                    ),
                    const SizedBox(height: defaultPadding),
                    ElevatedButton(
                      onPressed: () {
                        // Validate the form and save the input
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save(); // Save the form data

                          // Check if either current location or new address is provided
                          if (_locationAddress != null && _locationAddress!.isNotEmpty) {
                            // Proceed with the selected location
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EntryPoint(),
                              ),
                            );
                          } else {
                            // Show an error message if no location is selected
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please select a location.")),
                            );
                          }
                        }
                      },
                      child: const Text("Continue"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}