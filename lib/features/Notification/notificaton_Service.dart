import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  
  factory NotificationService() {
    return _instance;
  }
  
  NotificationService._internal();
  
  // Initialize listeners
  void initializeNotificationListeners(Function(ReceivedNotification) onNotificationCreated, 
                                      Function(ReceivedNotification) onNotificationDisplayed,
                                      Function(ReceivedAction) onActionReceived) {
    AwesomeNotifications().actionStream.listen(onActionReceived);
    AwesomeNotifications().createdStream.listen(onNotificationCreated);
    AwesomeNotifications().displayedStream.listen(onNotificationDisplayed);
  }
  
  // Dispose listeners
  void disposeNotificationListeners() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
  }
  
  // Create notification for new audio content
  Future<void> createAudioNotification(String title, String description) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'content_channel',
        title: 'New Audio: $title',
        body: description,
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Message,
        payload: {'type': 'audio', 'id': createUniqueId().toString()}
      ),
    );
  }
  
  // Create notification for new article
  Future<void> createArticleNotification(String title, String date) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'content_channel',
        title: 'New Article: $title',
        body: 'Published on $date',
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Message,
        payload: {'type': 'article', 'id': createUniqueId().toString()}
      ),
    );
  }
  
  // Create notification for new devotion
  Future<void> createDevotionNotification(String title, String description) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'content_channel',
        title: 'New Devotion: $title',
        body: description,
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Message,
        payload: {'type': 'devotion', 'id': createUniqueId().toString()}
      ),
    );
  }
  
  // Create notification for new book
  Future<void> createBookNotification(String title, String author) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'content_channel',
        title: 'New Book: $title',
        body: 'By $author',
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Message,
        payload: {'type': 'book', 'id': createUniqueId().toString()}
      ),
    );
  }
  
  // Create notification for new Q&A
  Future<void> createQAndANotification(String question) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'content_channel',
        title: 'New Question Posted',
        body: question,
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Message,
        payload: {'type': 'qa', 'id': createUniqueId().toString()}
      ),
    );
  }
  
  // Helper to create unique IDs
  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}