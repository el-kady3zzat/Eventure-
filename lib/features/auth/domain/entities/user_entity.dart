class UserEntity {
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

  const UserEntity({
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

  UserEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? image,
    String? location,
    String? role,
    List<String>? bookedEvents,
    List<String>? favEvents,
    List<String>? savedEvents,
  }) {
    return UserEntity(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      location: location ?? this.location,
      role: role ?? this.role,
      bookedEvents: bookedEvents ?? this.bookedEvents,
      favEvents: favEvents ?? this.favEvents,
      savedEvents: savedEvents ?? this.savedEvents,
    );
  }
}
