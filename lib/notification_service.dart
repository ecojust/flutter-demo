import 'package:awesome_notifications/awesome_notifications.dart';

import 'notification_controller.dart';
import 'theme.dart';

class NotificationService {
  /// Invoke before `runApp`
  Future<bool> initialize() {
    return AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/app_icon',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: brandColor,
        ),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group',
        ),
      ],
      debug: true,
    );
  }

  /// Register callbacks for the notification.
  Future<bool> setupCallbacks() async {
    // Only after at least the action method is set, the notification events are delivered
    final success = await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    return success;
  }

  /// Request permission from OS to show notifications, if it isn't allowed already
  Future<bool> requestPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  int _lastId = 0;

  /// Create a notification
  show({String? title, String? body, Map<String, String?>? payload}) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _lastId++,
        channelKey: 'basic_channel',
        actionType: ActionType.Default,
        title: title,
        body: body,
        payload: payload,
      ),
    );
  }
}
