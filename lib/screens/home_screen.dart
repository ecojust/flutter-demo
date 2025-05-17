import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:notifications/services/fcm_service.dart';
import 'package:notifications/services/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // DEFAULT NOTIFICATION
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 1,
                title: 'Default Notification',
                body: 'This is the body of the notification',
                summary: 'Small summary',
              );
            },
            child: const Text('Default Notification'),
          ),

          // NOTIFICATION WITH SUMMARY
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 2,
                title: 'Notification with Summary',
                body: 'This is the body of the notification',
                summary: 'Small summary',
                notificationLayout: NotificationLayout.Inbox,
              );
            },
            child: const Text("Notification with Summary"),
          ),

          // PROGRESS BAR NOTIFICATION
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 3,
                title: 'Progress Bar Notification',
                body: 'This is the body of the notification',
                summary: 'Small summary',
                notificationLayout: NotificationLayout.ProgressBar,
              );
            },
            child: const Text('Progress Bar Notification'),
          ),

          // MESSAGE NOTIFICATION
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 4,
                title: 'Message Notification',
                body: 'This is the body of the notification',
                summary: 'Small summary',
                notificationLayout: NotificationLayout.Messaging,
              );
            },
            child: const Text('Message Notification'),
          ),

          // BIG PICTURE NOTIFICATION
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 5,
                title: 'Big Image Notification',
                body: 'This is the body of the notification',
                summary: 'Small summary',
                notificationLayout: NotificationLayout.BigPicture,
                bigPicture: 'https://picsum.photos/300/200',
              );
            },
            child: const Text('Big Image Notification'),
          ),

          // ACTION BUTTON NOTIFICATION
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 6,
                title: 'Action Button Notification',
                body: 'This is the body of the notification',
                payload: {'navigate': 'true'},
                actionButtons: [
                  NotificationActionButton(
                    key: 'action_button',
                    label: 'Click me',
                    actionType: ActionType.Default,
                  ),
                  NotificationActionButton(
                    key: 'action_button',
                    label: 'Click me',
                    actionType: ActionType.Default,
                  ),
                  NotificationActionButton(
                    key: 'action_button',
                    label: 'Click me',
                    actionType: ActionType.Default,
                  ),
                  NotificationActionButton(
                    key: 'action_button',
                    label: 'Click me',
                    actionType: ActionType.Default,
                  ),
                ],
              );
            },
            child: const Text('Action Button Notification'),
          ),

          // SCHEDULED NOTIFICATION
          OutlinedButton(
            onPressed: () async {
              await NotificationService.createNotification(
                id: 7,
                title: 'Scheduled Notification',
                body: 'This is the body of the notification',
                scheduled: true,
                interval: const Duration(seconds: 5),
              );
            },
            child: const Text('Scheduled Notification'),
          ),

          const SizedBox(height: 30),
          const Text(
            'Firebase Cloud Messaging',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          // GET FCM TOKEN
          OutlinedButton(
            onPressed: () async {
              final token = await FcmService.requestFCMToken();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('FCM Token: ${token.substring(0, 20)}...'),
                  action: SnackBarAction(
                    label: 'Copy',
                    onPressed: () {
                      // Copy to clipboard functionality could be added here
                    },
                  ),
                ),
              );
            },
            child: const Text('Get FCM Token'),
          ),

          // SUBSCRIBE TO TOPIC
          OutlinedButton(
            onPressed: () async {
              final result = await FcmService.subscribeTopic('news');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result
                        ? 'Successfully subscribed to "news" topic'
                        : 'Failed to subscribe to topic',
                  ),
                ),
              );
            },
            child: const Text('Subscribe to "news" Topic'),
          ),

          // UNSUBSCRIBE FROM TOPIC
          OutlinedButton(
            onPressed: () async {
              final result = await FcmService.unsubscribeTopic('news');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result
                        ? 'Successfully unsubscribed from "news" topic'
                        : 'Failed to unsubscribe from topic',
                  ),
                ),
              );
            },
            child: const Text('Unsubscribe from "news" Topic'),
          ),

          // SIMULATE FCM NOTIFICATION (JUST FOR TESTING)
          OutlinedButton(
            onPressed: () async {
              await FcmService.processRemoteMessage(
                title: 'Test FCM Notification',
                body: 'This simulates a notification from Firebase',
                image: 'https://picsum.photos/300/200',
                payload: {'navigate': 'true'},
              );
            },
            child: const Text('Test FCM Notification (Simulation)'),
          ),
        ],
      ),
    );
  }
}
