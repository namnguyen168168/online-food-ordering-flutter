class Restaurant {
  final String name;
  final double rating;
  final int numOfRating;
  final int deliveryTime;
  final List<String> foodTypes;

  Restaurant({
    required this.name,
    required this.rating,
    required this.numOfRating,
    required this.deliveryTime,
    required this.foodTypes,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'] ?? 'Unknown', // Default value if null
      rating: (json['rating'] != null) ? json['rating'].toDouble() : 0.0, // Handle null
      numOfRating: json['numOfRating'] ?? 0, // Default value if null
      deliveryTime: json['deliveryTime'] ?? 0, // Default value if null
      foodTypes: List<String>.from(json['foodTypes'] ?? []), // Handle null
    );
  }
}