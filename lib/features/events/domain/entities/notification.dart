import 'package:equatable/equatable.dart';

class EventureNotification extends Equatable {
  final String id;
  final String title;
  final String eventId;
  final DateTime timestamp;

  const EventureNotification({
    required this.id,
    required this.title,
    required this.eventId,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        eventId,
        timestamp,
      ];
}
