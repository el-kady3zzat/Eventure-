import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/features/events/domain/entities/notification.dart';

class NotificationModel extends EventureNotification {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.eventId,
    required super.timestamp,
  });

  factory NotificationModel.fromFs(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      eventId: data['eventId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
