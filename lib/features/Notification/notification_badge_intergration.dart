import 'package:devotion/features/Notification/notification_manager.dart';
import 'package:devotion/features/Notification/notification_screen.dart';
import 'package:devotion/features/Notification/notificaton_Service.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationBadge extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  
  const NotificationBadge({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  _NotificationBadgeState createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
    
    // Listen for notifications to update the badge
    AwesomeNotifications().createdStream.listen((_) {
      _loadUnreadCount();
    });
  }

  Future<void> _loadUnreadCount() async {
    final count = await NotificationManager.getUnreadCount();
    setState(() {
      _unreadCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: widget.child,
          onPressed: () {
            widget.onPressed();
          },
        ),
        if (_unreadCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                _unreadCount > 99 ? '99+' : _unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

// In your home page/main app
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    
    // Set up notification service
    NotificationService notificationService = NotificationService();
    notificationService.initializeNotificationListeners(
      (receivedNotification) {
        // When notification is created, save it to local storage
        NotificationManager.saveNotification(
          NotificationModel(
            id: receivedNotification.id?.toString() ?? '',
            title: receivedNotification.title ?? '',
            body: receivedNotification.body ?? '',
            type: receivedNotification.payload?['type'] ?? 'unknown',
            timestamp: DateTime.now(),
          ),
        );
      },
      (receivedNotification) {
        // When notification is displayed
        print('Notification displayed: ${receivedNotification.title}');
      },
      (receivedAction) {
        // When user taps on notification
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NotificationScreen()),
        );
        
        // Mark notification as read
        if (receivedAction.id != null) {
          NotificationManager.markAsRead(receivedAction.id.toString());
        }
      },
    );
  }
  
  @override
  void dispose() {
    NotificationService().disposeNotificationListeners();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Home'),
        actions: [
          NotificationBadge(
            child: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
        ],
      ),
      // Rest of your homepage
    );
  }
}

// Example of how to trigger notifications when content is added
class ContentService {
  final NotificationService _notificationService = NotificationService();
  
  // Call this when a new audio is added
  Future<void> addNewAudio(String title, String description) async {
    // Your code to save the audio to your database
    
    // Then send notification
    await _notificationService.createAudioNotification(title, description);
  }
  
  // Call this when a new article is added
  Future<void> addNewArticle(String title, String date) async {
    // Your code to save the article to your database
    
    // Then send notification
    await _notificationService.createArticleNotification(title, date);
  }
  
  // Similar methods for devotion, book, Q&A
}