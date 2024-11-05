import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String startAt;
  final String endAt;


  const EventCard({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.startAt,
    required this.endAt,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220, // Set a fixed height for the card
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top of the card
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                height: 120, // Set a specific height for the image
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis, // Prevent title overflow
                maxLines: 1, // Limit to one line
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                description,
                maxLines: 2, // Limit to two lines
                overflow: TextOverflow.ellipsis, // Prevent description overflow
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'From: $startAt To: $endAt',
                maxLines: 1, // Limit to one line
                overflow: TextOverflow.ellipsis, // Prevent overflow
              ),
            ),
          ],
        ),
      ),
    );
  }
}