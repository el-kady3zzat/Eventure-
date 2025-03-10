import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:eventure/core/errors/failure.dart';
import 'package:eventure/core/utils/helper/firebase.dart';
import 'package:eventure/features/events/data/datasources/local_notification_settings.dart';
import 'package:eventure/features/events/data/models/event_model.dart';
import 'package:eventure/features/events/data/models/notification_model.dart';
import 'package:eventure/injection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class EventDatasource {
  final db = getIt<FirebaseFirestore>();
  final messaging = getIt<FirebaseMessaging>();
  List<EventModel> _events = [];
  Map<String, dynamic> userData = {};

  Future<Either<Failure, Map<String, dynamic>>> getCurrentUser() async {
    try {
      if (userData.isEmpty) {
        final userDoc = await db.collection('users').doc(currentUserId).get();

        userData = {
          'name': userDoc.data()!['name'] ?? '',
          'image': userDoc.data()!['image'] ?? '',
          'location': userDoc.data()!['location'] ?? '',
          'fcmToken': userDoc.data()!['fcmToken'] ?? '',
        };
      }

      return right(userData);
    } catch (e) {
      return left(EventFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<EventModel>>> getEvents() async {
    try {
      final snapshot = await db.collection('events').get();

      _events.clear();
      _events = snapshot.docs.map((doc) => EventModel.fromFs(doc)).toList();
      return right(_events);
    } catch (e) {
      return left(EventFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<EventModel>>> getCalndarEvents() async {
    try {
      final bookedEventsIds = await getBookIds();
      final eventIds =
          bookedEventsIds.fold((failure) => <String>[], (ids) => ids);

      List<EventModel> calendarEvents = _events
          .where((event) => eventIds.contains(event.id))
          .map((event) => EventModel(
                address: event.address,
                cover: event.cover,
                dateTime: event.dateTime,
                description: event.description,
                id: event.id,
                location: event.location,
                price: event.price,
                seats: event.seats,
                registeredUsers: event.registeredUsers,
                registeredUsersImages: event.registeredUsersImages,
                title: event.title,
              ))
          .toList();

      return right(calendarEvents);
    } catch (e) {
      return left(EventFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<EventModel>>> getFavoriteEvents() async {
    final favEventsIds = await getFavoriteIds();
    final ids = favEventsIds.fold((failure) => <String>[], (ids) => ids);

    try {
      List<EventModel> favoriteEvents = _events
          .where((event) => ids.contains(event.id))
          .map((event) => EventModel(
                address: event.address,
                cover: event.cover,
                dateTime: event.dateTime,
                description: event.description,
                id: event.id,
                location: event.location,
                price: event.price,
                seats: event.seats,
                registeredUsers: event.registeredUsers,
                registeredUsersImages: event.registeredUsersImages,
                title: event.title,
              ))
          .toList();
      return right(favoriteEvents);
    } catch (e) {
      return left(EventFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> isEventHasSeats(String eventId) async {
    try {
      final eventDoc = await db.collection('events').doc(eventId).get();
      final registeredUsers =
          List.from(eventDoc.data()?['registeredUsers'] ?? []);
      final seats = eventDoc.data()?['seats'];

      final bool hasSeats = registeredUsers.length >= seats;

      return right(!hasSeats);
    } catch (e) {
      return left(EventFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> addToRegisteredUsers(String eventId) async {
    try {
      final userRef = db.collection('events').doc(eventId);

      await userRef.update({
        'registeredUsers': FieldValue.arrayUnion([currentUserId])
      });
      await userRef.update({
        'registeredUsersImages': FieldValue.arrayUnion([userData['image']])
      });

      return Right(null);
    } catch (e) {
      return Left(EventFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> removeFromRegisteredUsers(
    String eventId,
  ) async {
    try {
      final userRef = db.collection('events').doc(eventId);

      await userRef.update({
        'registeredUsers': FieldValue.arrayRemove([currentUserId])
      });
      await userRef.update({
        'registeredUsersImages': FieldValue.arrayRemove([userData['image']])
      });

      return Right(null);
    } catch (e) {
      return Left(EventFailure(e.toString()));
    }
  }

  Stream<Either<Failure, List<String>>> registeredUsersImages(eventId) {
    return db.collection("events").doc(eventId).snapshots().map((snapshot) {
      try {
        if (!snapshot.exists) {
          return Left(EventFailure("Document does not exist"));
        }

        final data = snapshot.data();
        if (data == null || !data.containsKey("registeredUsersImages")) {
          return Left(EventFailure("Invalid data structure"));
        }

        final stringList = List<String>.from(data["registeredUsersImages"]);
        return Right(stringList);
      } catch (e) {
        return Left(EventFailure(e.toString()));
      }
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Handle Notifications

  Future<void> registerFcmToken() async {
    final String? token = await messaging.getToken();
    // if (token != null) {
    await db.collection('users').doc(currentUserId).update({
      'fcmToken': token,
    });
    // }
  }

  Future<void> toggleNotificationChannel(
    String channelId,
    bool isEnabled,
  ) async {
    final doc =
        await db.collection('notification_settings').doc(currentUserId).get();
    if (doc.exists && doc.data() != null) {
      db.collection('notification_settings').doc(currentUserId).update({
        channelId: isEnabled,
      });
    } else {
      db.collection('notification_settings').doc(currentUserId).set({
        channelId: isEnabled,
      });
    }
  }

  Future<Map<String, bool>> getNotificationSettings() async {
    final doc =
        await db.collection('notification_settings').doc(currentUserId).get();
    if (doc.exists && doc.data() != null) {
      final settings = Map<String, bool>.from(doc.data()!);

      getIt<LocalNotificationSettings>().setSettings(settings);

      return Map<String, bool>.from(doc.data()!);
    }
    return {};
  }

  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    try {
      final query = await db
          .collection('notifications')
          .where('userId', isEqualTo: currentUserId)
          // .orderBy('timestamp', descending: true)
          .get();

      return right(
        query.docs.map((doc) => NotificationModel.fromFs(doc)).toList(),
      );
    } catch (e) {
      return Left(EventFailure(e.toString()));
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Handle favorite list of the user in users collection

  Future<Either<Failure, List<String>>> getFavoriteIds() async {
    try {
      final userDoc = await db.collection('users').doc(currentUserId).get();
      final eventIds = List<String>.from(userDoc.data()?['favEvents'] ?? []);

      return right(eventIds);
    } catch (e) {
      return left(EventFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> addToFavorite(String eventId) async {
    try {
      final userRef = db.collection('users').doc(currentUserId);

      await userRef.update({
        'favEvents': FieldValue.arrayUnion([eventId])
      });

      return Right(null);
    } catch (e) {
      return Left(EventFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> removeFromFavorite(String eventId) async {
    try {
      final userRef = db.collection('users').doc(currentUserId);

      await userRef.update({
        'favEvents': FieldValue.arrayRemove([eventId])
      });
      return Right(null);
    } catch (e) {
      return Left(EventFailure(e.toString()));
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Handle booked list of the user in users collection

  Future<Either<Failure, List<String>>> getBookIds() async {
    try {
      final userDoc = await db.collection('users').doc(currentUserId).get();
      final eventIds = List<String>.from(userDoc.data()?['bookedEvents'] ?? []);

      return right(eventIds);
    } catch (e) {
      return left(EventFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> addToBook(String eventId) async {
    try {
      final userRef = db.collection('users').doc(currentUserId);

      await userRef.update({
        'bookedEvents': FieldValue.arrayUnion([eventId])
      });

      await addToRegisteredUsers(eventId);

      return Right(null);
    } catch (e) {
      return Left(EventFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> removeBook(String eventId) async {
    try {
      final userRef = db.collection('users').doc(currentUserId);

      await userRef.update({
        'bookedEvents': FieldValue.arrayRemove([eventId])
      });

      await removeFromRegisteredUsers(eventId);

      return Right(null);
    } catch (e) {
      return Left(EventFailure(e.toString()));
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Handle saved list of the user in users collection

  Future<Either<Failure, List<String>>> getSavedIds() async {
    try {
      final userDoc = await db.collection('users').doc(currentUserId).get();
      final eventIds = List<String>.from(userDoc.data()?['savedEvents'] ?? []);

      return right(eventIds);
    } catch (e) {
      return left(EventFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> addToSave(String eventId) async {
    try {
      final userRef = db.collection('users').doc(currentUserId);

      await userRef.update({
        'savedEvents': FieldValue.arrayUnion([eventId])
      });

      return Right(null);
    } catch (e) {
      return Left(EventFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> removeFromSave(String eventId) async {
    try {
      final userRef = db.collection('users').doc(currentUserId);

      await userRef.update({
        'savedEvents': FieldValue.arrayRemove([eventId])
      });
      return Right(null);
    } catch (e) {
      return Left(EventFailure(e.toString()));
    }
  }
}
