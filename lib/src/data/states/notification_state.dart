import 'package:realtimekit_ui/src/data/models/notification.dart';

abstract class NotificationState {}

class OnNotificationInitial extends NotificationState {}

class OnNewNotificationReceived extends NotificationState {
  final RtkNotification notification;
  OnNewNotificationReceived(this.notification);
}
