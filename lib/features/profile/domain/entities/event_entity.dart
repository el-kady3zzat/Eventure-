import 'package:cloud_firestore/cloud_firestore.dart';

class EventEntity {
  final String id;
  final String title;
  final DateTime date;
  final String cover;
  final String description;
  final String location;
  final String price;
  final int seats;

  EventEntity({
    required this.id,
    required this.title,
    required this.date,
    required this.cover,
    required this.description,
    required this.location,
    required this.price,
    required this.seats,
  });

  factory EventEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Error: Event document data is null!");
    }

    return EventEntity(
      id: doc.id,
      title: data['title'] ?? 'Unknown Event',
      date: (data['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      cover: data['cover'] ?? 'assets/images/default_event.png',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      price: data['price'].toString(),
      seats: (data['seats'] as num?)?.toInt() ?? 0,
    );
  }
}