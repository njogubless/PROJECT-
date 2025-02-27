import 'dart:convert';

import 'package:devotion/features/Notification/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationManager {
  static const String _storageKey = 'app_notifications';

  // Save a notification to local storage
  static Future<void> saveNotification(NotificationModel notification) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getNotifications();
    notifications.add(notification);
    await prefs.setString(_storageKey, jsonEncode(notifications.map((e) => e.toJson()).toList()));
  }

  // Get all notifications from local storage
  static Future<List<NotificationModel>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString(_storageKey);
    if (notificationsJson == null) {
      return [];
    }
    List<dynamic> jsonList = jsonDecode(notificationsJson);
    return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
  }

  // Mark a notification as read
  static Future<void> markAsRead(String id) async {
    final notifications = await getNotifications();
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(notifications.map((e) => e.toJson()).toList()));
    }
  }

  // Get unread count
  static Future<int> getUnreadCount() async {
    final notifications = await getNotifications();
    return notifications.where((n) => !n.isRead).length;
  }
}