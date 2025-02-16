// // notification_service.dart
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications = 
//       FlutterLocalNotificationsPlugin();
  
//   List<NotificationItem> notifications = [];
//   final notificationStream = StreamController<NotificationItem>.broadcast();

//   Future<void> initialize() async {
//     // Request permission
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Initialize local notifications
//     const initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//     const initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await _localNotifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onNotificationTapped,
//     );

//     // Handle FCM messages
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    
//     // Get FCM token
//     final token = await _firebaseMessaging.getToken();
//     print('FCM Token: $token');
//   }

//   void _handleForegroundMessage(RemoteMessage message) {
//     final notification = NotificationItem(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: message.notification?.title ?? '',
//       body: message.notification?.body ?? '',
//       timestamp: DateTime.now(),
//       read: false,
//       data: message.data,
//     );

//     notifications.insert(0, notification);
//     notificationStream.add(notification);
//     _showLocalNotification(notification);
//   }

//   void _handleBackgroundMessage(RemoteMessage message) {
//     // Handle notification tapped when app was in background
//     print('Background message: ${message.data}');
//   }

//   Future<void> _showLocalNotification(NotificationItem notification) async {
//     const androidDetails = AndroidNotificationDetails(
//       'default_channel',
//       'Default Channel',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//     const iosDetails = DarwinNotificationDetails();
//     const details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotifications.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       details,
//       payload: notification.id,
//     );
//   }

//   void _onNotificationTapped(NotificationResponse response) {
//     // Handle notification tapped
//     final notification = notifications.firstWhere(
//       (n) => n.id == response.payload,
//       orElse: () => notifications.first,
//     );
//     notification.read = true;
    
//   }
// }

// class NotificationItem {
//   final String id;
//   final String title;
//   final String body;
//   final DateTime timestamp;
//   bool read;
//   final Map<String, dynamic> data;

//   NotificationItem({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.timestamp,
//     this.read = false,
//     required this.data,
//   });
// }
