import 'package:eventure/features/events/data/datasources/event_datasource.dart';
import 'package:eventure/features/events/data/datasources/local_notification_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:eventure/injection.dart';

class NotificationHandler {
  static final _fm = getIt<FirebaseMessaging>();
  static final _flnp = FlutterLocalNotificationsPlugin();

  // Define a top-level or static function for background handling
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    // Ensure proper initialization
    LocalNotificationSettings().init();

    final localSettings = LocalNotificationSettings().getSettings();
    final String? channelId = message.data['channel_id'];

    if (channelId != null && localSettings[channelId] == true) {
      // Make sure showNotification is static as well
      showNotification(message, channelId);
    }
  }

  // Ensure this is static
  static void showNotification(RemoteMessage message, String channelId) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelId,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _flnp.show(
      message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }

  // Setup Firebase Listeners
  static void setupFirebaseListeners() {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final localSettings = getIt<LocalNotificationSettings>().getSettings();
      final String? channelId = message.data['channel_id'];
      if (channelId != null && localSettings[channelId] == true) {
        showNotification(message, channelId);
      }
    });

    // Background - Register the static function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // When user taps a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("User clicked on the notification");
    });
  }

  static Future<void> initialize() async {
    await _fm.requestPermission();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    final initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _flnp.initialize(initializationSettings);
    await _registerFcmToken();

    setupFirebaseListeners();
  }

  static Future<void> _registerFcmToken() async {
    getIt<FirebaseMessaging>().onTokenRefresh.listen((newToken) {
      getIt<EventDatasource>().registerFcmToken();
    });
  }
}
