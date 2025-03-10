import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String location;
  final String role;
  final String image;
  final List<String> bookedEvents;
  final List<String> favEvents;
  final List<String> savedEvents;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.location,
    required this.role,
    required this.image,
    required this.bookedEvents,
    required this.favEvents,
    required this.savedEvents,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    email: json["email"] ?? '',
    phone: json["phone"] ?? '',
    password: json["password"] ?? '',
    location: json["location"] ?? '',
    role: json["role"] ?? '',
    image: json["image"] ?? '',
    bookedEvents: List<String>.from(json["bookedEvents"] ?? []),
    favEvents: List<String>.from(json["favEvents"] ?? []),
    savedEvents: List<String>.from(json["savedEvents"] ?? []),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "password": password,
    "location": location,
    "role": role,
    "image": image,
    "bookedEvents": bookedEvents,
    "favEvents": favEvents,
    "savedEvents": savedEvents,
  };

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "location": location,
      "role": role,
      "image": image,
      "bookedEvents": bookedEvents,
      "favEvents": favEvents,
      "savedEvents": savedEvents,
    };
  }

  // Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      password: data['password'] ?? '',
      location: data['location'] ?? '',
      role: data['role'] ?? '',
      image: data['image'] ?? '',
      bookedEvents: List<String>.from(data['bookedEvents'] ?? []),
      favEvents: List<String>.from(data['favEvents'] ?? []),
      savedEvents: List<String>.from(data['savedEvents'] ?? []),
    );
  }

  // Create a copy of UserModel with modified fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? role,
    String? image,
    List<String>? bookedEvents,
    List<String>? favEvents,
    List<String>? savedEvents,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ,
      location: location ?? this.location,
      role: role ?? this.role,
      image: image ?? this.image,
      bookedEvents: bookedEvents ?? this.bookedEvents,
      favEvents: favEvents ?? this.favEvents,
      savedEvents: savedEvents ?? this.savedEvents,
    );
  }
}