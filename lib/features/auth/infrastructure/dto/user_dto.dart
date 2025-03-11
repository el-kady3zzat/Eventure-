// lib/infrastructure/auth/dto/user_dto.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/features/auth/domain/entities/user_entity.dart';

class UserDTO {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final String location;
  final String role;
  final List<String> bookedEvents;
  final List<String> favEvents;
  final List<String> savedEvents;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    this.location = 'Egypt',
    this.role = 'client',
    this.bookedEvents = const [],
    this.favEvents = const [],
    this.savedEvents = const [],
  });

  // From Domain
  factory UserDTO.fromDomain(UserEntity user) {
    return UserDTO(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      image: user.image,
      location: user.location,
      role: user.role,
      bookedEvents: user.bookedEvents,
      favEvents: user.favEvents,
      savedEvents: user.savedEvents,
    );
  }

  // To Domain
  UserEntity toDomain() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      image: image,
      location: location,
      role: role,
      bookedEvents: bookedEvents,
      favEvents: favEvents,
      savedEvents: savedEvents,
    );
  }

  // From Firestore
  factory UserDTO.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserDTO(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      image: data['image'],
      location: data['location'] ?? 'Egypt',
      role: data['role'] ?? 'client',
      bookedEvents: List<String>.from(data['bookedEvents'] ?? []),
      favEvents: List<String>.from(data['favEvents'] ?? []),
      savedEvents: List<String>.from(data['savedEvents'] ?? []),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      if (image != null) 'image': image,
      'location': location,
      'role': role,
      'bookedEvents': bookedEvents,
      'favEvents': favEvents,
      'savedEvents': savedEvents,
    };
  }

  // Helper methods
  bool hasBookedEvent(String eventId) => bookedEvents.contains(eventId);
  bool hasFavEvent(String eventId) => favEvents.contains(eventId);
  bool hasSavedEvent(String eventId) => savedEvents.contains(eventId);
}