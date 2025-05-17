import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notifications/services/notification_service.dart';

class FcmService {
  static final AwesomeNotificationsFcm _fcmPlugin = AwesomeNotificationsFcm();

  static Future<void> initializeFCM() async {
    // initialize Firebase
    await Firebase.initializeApp();

    // initialize FCM
    await _fcmPlugin.initialize(
      onFcmSilentDataHandle: _onFcmSilentDataHandle,
      onFcmTokenHandle: _onFcmTokenHandle,
      onNativeTokenHandle: _onNativeTokenHandle,
      debug: true,
    );

    // get FCM Token
    await requestFCMToken();
  }

  // Request FCM token for this device
  static Future<String> requestFCMToken() async {
    try {
      String token = await _fcmPlugin.requestFirebaseAppToken();
      debugPrint('FCM token: $token');
      return token;
    } catch (error) {
      debugPrint('Error getting FCM token: $error');
      return '';
    }
  }

  // Subscribe to a specific topic
  static Future<bool> subscribeTopic(String topic) async {
    try {
      await _fcmPlugin.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
      return true;
    } catch (error) {
      debugPrint('Error subscribing to topic: $error');
      return false;
    }
  }

  // Unsubscribe from a specific topic
  static Future<bool> unsubscribeTopic(String topic) async {
    try {
      await _fcmPlugin.unsubscribeToTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
      return true;
    } catch (error) {
      debugPrint('Error unsubscribing from topic: $error');
      return false;
    }
  }

  // Handlers
  // This method is called when a silent data message is received
  static Future<void> _onFcmSilentDataHandle(FcmSilentData silentData) async {
    debugPrint('FCM silent data received:');
    debugPrint('${silentData.data}');

    // You can handle background tasks here when a silent notification is received
    // For example, sync data or perform other background work

    if (silentData.createdLifeCycle == NotificationLifeCycle.Foreground) {
      debugPrint('Silent notification received while app is in foreground');
    } else {
      debugPrint('Silent notification received while app is in background or terminated');
    }
  }

  // This method is called when a new FCM token is received
  static Future<void> _onFcmTokenHandle(String token) async {
    debugPrint('FCM token received: $token');

    // Here you can send the token to your server
    // For example:
    // await apiService.updateFcmToken(token);
  }

  // This method is called when a new native token is received
  static Future<void> _onNativeTokenHandle(String token) async {
    debugPrint('Native token received: $token');

    // For Android, this is the same as the FCM token
    // For iOS, this is the APNs token
  }

  // Process a push notification received from FCM
  static Future<void> processRemoteMessage({
    required String title,
    required String body,
    String? image,
    Map<String, String>? payload,
    bool scheduled = false,
    Duration? interval,
  }) async {
    await NotificationService.createNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      bigPicture: image,
      payload: payload,
      notificationLayout:
          image != null ? NotificationLayout.BigPicture : NotificationLayout.Default,
      scheduled: scheduled,
      interval: interval,
    );
  }
}
