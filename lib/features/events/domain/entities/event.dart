import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String address;
  final String cover;
  final DateTime dateTime;
  final String description;
  final String id;
  final String location;
  final String price;
  final int seats;
  final List registeredUsers;
  final List registeredUsersImages;
  final String title;

  const Event({
    required this.address,
    required this.cover,
    required this.dateTime,
    required this.description,
    required this.id,
    required this.location,
    required this.price,
    required this.seats,
    required this.registeredUsers,
    required this.registeredUsersImages,
    required this.title,
  });

  @override
  List<Object> get props => [
        address,
        cover,
        dateTime,
        description,
        id,
        location,
        price,
        seats,
        registeredUsers,
        registeredUsersImages,
        title,
      ];
}
