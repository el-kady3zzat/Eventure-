import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/features/events/domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({
    required super.address,
    required super.cover,
    required super.dateTime,
    required super.description,
    required super.id,
    required super.location,
    required super.price,
    required super.seats,
    required super.registeredUsers,
    required super.registeredUsersImages,
    required super.title,
  });

  factory EventModel.fromFs(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      address: data['address'],
      cover: data['cover'],
      dateTime: data['dateTime'].toDate(),
      description: data['description'],
      id: data['id'],
      location: data['location'],
      price: data['price'],
      seats: data['seats'],
      registeredUsers: data['registeredUsers'],
      registeredUsersImages: data['registeredUsersImages'],
      title: data['title'],
    );
  }
}
