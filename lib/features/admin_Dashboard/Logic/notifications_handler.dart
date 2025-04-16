import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": dotenv.env['FIREBASE_PROJECT_ID'] ?? "",
      "private_key_id": dotenv.env['FIREBASE_PRIVATE_KEY_ID'] ?? "",
      "private_key":
          dotenv.env['FIREBASE_PRIVATE_KEY']?.replaceAll(r'\n', '\n') ?? "",
      "client_email": dotenv.env['FIREBASE_CLIENT_EMAIL'] ?? "",
      "client_id": dotenv.env['FIREBASE_CLIENT_ID'] ?? "",
      "auth_uri":
          dotenv.env['AUTH_URI'] ?? "https://accounts.google.com/o/oauth2/auth",
      "token_uri":
          dotenv.env['TOKEN_URI'] ?? "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          dotenv.env['AUTH_PROVIDER_X509_CERT_URL'] ??
              "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": dotenv.env['CLIENT_X509_CERT_URL'] ??
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40eventure-b3ff2.iam.gserviceaccount.com",
      "universe_domain": dotenv.env['UNIVERSE_DOMAIN'] ?? "googleapis.com",
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    client.close();
    return credentials.accessToken.data;
  }

  Future<List<String>> getUsersTokens() async {
    QuerySnapshot usersSnapshot =
        await FirebaseFirestore.instance.collection("users").get();

    List<String> tokens = usersSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>?)
        .where((data) => data != null && data.containsKey("fcmToken"))
        .map((data) => data!["fcmToken"] as String)
        .toSet()
        .toList();

    return tokens;
  }

  Future<List<String>> getRegisteredUsersTokens(String eventId) async {
    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection("events")
        .doc(eventId)
        .get();

    if (!eventSnapshot.exists) {
      debugPrint("Event not found.");
      return [];
    }

    List<String> registeredUserIds =
        List<String>.from(eventSnapshot["registeredUsers"] ?? []);

    if (registeredUserIds.isEmpty) {
      debugPrint("No registered users found for this event.");
      return [];
    }

    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where(FieldPath.documentId, whereIn: registeredUserIds)
        .get();

    List<String> tokens = usersSnapshot.docs
        .map((doc) => doc["fcmToken"] as String?)
        .where((token) => token != null)
        .cast<String>()
        .toList();

    return tokens;
  }

  Future<List<String>> getLikedUsersTokens(String eventId) async {
    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection("events")
        .doc(eventId)
        .get();

    if (!eventSnapshot.exists) {
      debugPrint("Event not found.");
      return [];
    }

    List<String> likedUserIds =
        List<String>.from(eventSnapshot["likedUsers"] ?? []);

    if (likedUserIds.isEmpty) {
      debugPrint("No liked users found for this event.");
      return [];
    }

    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where(FieldPath.documentId, whereIn: likedUserIds)
        .get();

    List<String> tokens = usersSnapshot.docs
        .map((doc) => doc["fcmToken"] as String?)
        .where((token) => token != null)
        .cast<String>()
        .toList();

    return tokens;
  }

  Future<void> sendNotificationToAll(id, title, cover) async {
    final String accessToken = await getAccessToken();
    List<String> tokens = await getUsersTokens();

    if (tokens.isEmpty) {
      debugPrint("No FCM tokens found.");
      return;
    }

    for (String token in tokens) {
      // final Map<String, dynamic> message = {
      //   "message": {
      //     "token": token,
      //     "notification": {
      //       "title": "New Event Created",
      //       "body": "New Event Created Check it now"
      //     },
      //     "android": {
      //       "notification": {"channel_id": "general_channel"}
      //     }
      //   }
      // };
      final Map<String, dynamic> message = {
        "message": {
          "token": token,
          "data": {
            "title": "New Event Added",
            "body": title,
            "id": id,
            "channel_id": "general_channel"
          }
        }
      };

      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/eventure-b3ff2/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        debugPrint('Notification sent successfully to $token');
      } else {
        debugPrint('Failed to send notification to $token: ${response.body}');
      }
    }
  }

  Future<void> sendNotificationToRegisteredUsers(String eventId) async {
    final String accessToken = await getAccessToken();
    List<String> tokens = await getRegisteredUsersTokens(eventId);

    if (tokens.isEmpty) {
      debugPrint("No registered users found for this event.");
      return;
    }

    for (String token in tokens) {
      // final Map<String, dynamic> message = {
      //   "message": {
      //     "token": token,
      //     "notification": {
      //       "title": "Event Reminder!",
      //       "body": "An event you registered for is coming up. Don’t miss it!"
      //     },
      //     "android": {
      //       "notification": {"channel_id": "booked_events_channel"}
      //     }
      //   }
      // };

      final Map<String, dynamic> message = {
        "message": {
          "token": token,
          "data": {
            "title": "Event Reminder!",
            // "body": title,
            "id": eventId,
            "channel_id": "booked_events_channel"
          }
        }
      };

      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/eventure-b3ff2/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        debugPrint('Notification sent successfully to registered user $token');
      } else {
        debugPrint(
            'Failed to send notification to registered user $token: ${response.body}');
      }
    }
  }

  Future<void> sendNotificationToLikedUsers(String eventId) async {
    final String accessToken = await getAccessToken();
    List<String> tokens = await getLikedUsersTokens(eventId);

    if (tokens.isEmpty) {
      debugPrint("No liked users found for this event.");
      return;
    }

    for (String token in tokens) {
      // final Map<String, dynamic> message = {
      //   "message": {
      //     "token": token,
      //     "notification": {
      //       "title": "Event Reminder! ⏳",
      //       "body": "An event you liked is starting tomorrow! Book it now."
      //     },
      //     "android": {
      //       "notification": {"channel_id": "favorite_events_channel"}
      //     }
      //   }
      // };

      final Map<String, dynamic> message = {
        "message": {
          "token": token,
          "data": {
            "title": "Event Reminder! ⏳",
            // "body": title,
            "id": eventId,
            "channel_id": "favorite_events_channel"
          }
        }
      };

      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/eventure-b3ff2/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        debugPrint('Notification sent successfully to liked user $token');
      } else {
        debugPrint(
            'Failed to send notification to liked user $token: ${response.body}');
      }
    }
  }
}

// Cultural Exchange & Networking Night

// An exclusive event for professionals and students to connect, share experiences, and discuss cultural exchange programs between Egypt and the U.S.

// 10/5

// //

// U.S. Study Abroad & Scholarship Info Session

// A dedicated session for students interested in studying in the U.S., covering visa processes, scholarship opportunities, and application tips.

// 20/6

// //

// U.S.-Egypt Business & Innovation Summit

// A high-level event bringing together entrepreneurs, investors, and business leaders to discuss U.S.-Egypt economic partnerships and innovations.

// 15/7

// //

// U.S. Embassy Cairo, 5 Tawfik Diab Street, Garden City, Cairo

// https://maps.google.com/?q=5%20Tawfik%20Diab%20Street%20Garden,%20City,%20Cairo%20Egypt
