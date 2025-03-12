import 'package:cloud_firestore/cloud_firestore.dart';

class FSEvent {
  String id;
  String title;
  int seats;
  String address;
  String cover;
  DateTime dateTime;
  String description;
  String location;
  String price;
  List<String>? registeredUsers;
  List<String>? registeredUsersImages;
  List<String>? likedUsers;

  FSEvent(
      {required this.id,
      required this.title,
      required this.seats,
      required this.address,
      this.cover = '',
      required this.dateTime,
      required this.description,
      required this.location,
      required this.price,
      this.registeredUsers,
      this.registeredUsersImages,
      this.likedUsers});

  factory FSEvent.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FSEvent(
        id: doc.id,
        title: data['title'],
        seats: data['seats'],
        address: data['address'],
        cover: data['cover'] ?? '',
        dateTime: (data['dateTime'] as Timestamp).toDate(),
        description: data['description'],
        location: data['location'],
        price: data['price'],
        registeredUsers: (data['registeredUsers'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        registeredUsersImages: (data['registeredUsersImages'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        likedUsers: (data['likedUsers'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList());
  }

  Map<String, dynamic> toFirestore() => {
        "id": id,
        "title": title,
        "seats": seats,
        "address": address,
        "cover": cover,
        "dateTime": dateTime,
        "description": description,
        "location": location,
        "price": price,
        "registeredUsers": registeredUsers,
        "likedUsers":likedUsers
      };
}
