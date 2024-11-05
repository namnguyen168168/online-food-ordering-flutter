class Restaurant {
  final String id;
  final String name;
  final List<String> foodTypes;
  final double rating;
  final int numOfRatings;
  final int deliveryTime;
  final String description;
  final String deliveryInfo;
  final List<String> images;

  Restaurant({
    required this.id,
    required this.name,
    required this.foodTypes,
    required this.rating,
    required this.numOfRatings,
    required this.deliveryTime,
    required this.description,
    required this.deliveryInfo,
    required this.images,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id']?.toString() ?? "0", // Default ID to "0" if null
      name: json['name'] ?? "Unknown Restaurant", // Default name
      foodTypes: json['cuisineType'] != null
          ? List<String>.from(json['cuisineType'].split(', '))
          : [], // Default to empty list if null
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble() // Handle both int and double
          : 0.0, // Default rating to 0.0
      numOfRatings: json['numOfRatings'] ?? 0, // Default to 0 if null
      deliveryTime: json['deliveryTime'] ?? 0, // Default to 0 minutes if null
      description: json['description'] ?? "No description available", // Default description if null
      deliveryInfo: json['deliveryInfo'] ?? "Free delivery", // Default to "Free" if null
      images: List<String>.from(json['images'] ?? []),
    );
  }
}