import 'package:devotion/features/Notification/notification_manager.dart';
import 'package:devotion/features/Notification/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });
    final notifications = await NotificationManager.getNotifications();
    setState(() {
      _notifications = notifications;
      _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      _isLoading = false;
    });
  }

  // Get the icon based on notification type
  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'audio':
        return Icons.audiotrack;
      case 'article':
        return Icons.article;
      case 'devotion':
        return Icons.book;
      case 'book':
        return Icons.menu_book;
      case 'qa':
        return Icons.question_answer;
      default:
        return Icons.notifications;
    }
  }

  // Get the color based on notification type
  Color _getTypeColor(String type) {
    switch (type) {
      case 'audio':
        return Colors.purple;
      case 'article':
        return Colors.blue;
      case 'devotion':
        return Colors.green;
      case 'book':
        return Colors.orange;
      case 'qa':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(child: Text('No notifications yet'))
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: notification.isRead ? null : Colors.blue.shade50,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getTypeColor(notification.type),
                          child: Icon(_getTypeIcon(notification.type), color: Colors.white),
                        ),
                        title: Text(notification.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notification.body),
                            const SizedBox(height: 4),
                            Text(
                              '${_getRelativeTime(notification.timestamp)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          // Mark as read when tapped
                          if (!notification.isRead) {
                            await NotificationManager.markAsRead(notification.id);
                            setState(() {
                              notification.isRead = true;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }
}