// // notification_screen.dart
// import 'package:devotion/services/notification_service.dart';
// import 'package:flutter/material.dart';

// class NotificationScreen extends StatelessWidget {
//   final NotificationService notificationService;

//   const NotificationScreen({
//     Key? key,
//     required this.notificationService,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.done_all),
//             onPressed: () {
//               // Mark all as read
//               for (var notification in notificationService.notifications) {
//                 notification.read = true;
//               }
//               (context as Element).markNeedsBuild();
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<NotificationItem>(
//         stream: notificationService.notificationStream.stream,
//         builder: (context, snapshot) {
//           return ListView.builder(
//             itemCount: notificationService.notifications.length,
//             itemBuilder: (context, index) {
//               final notification = notificationService.notifications[index];
//               return ListTile(
//                 title: Text(
//                   notification.title,
//                   style: TextStyle(
//                     fontWeight:
//                         notification.read ? FontWeight.normal : FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(notification.body),
//                     const SizedBox(height: 4),
//                     Text(
//                       _formatTimestamp(notification.timestamp),
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//                 leading: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.notifications,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//                 onTap: () {
//                   notification.read = true;
//                   // Handle notification tap
//                   // Navigate based on notification.data
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   String _formatTimestamp(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);

//     if (difference.inMinutes < 1) {
//       return 'Just now';
//     } else if (difference.inHours < 1) {
//       return '${difference.inMinutes}m ago';
//     } else if (difference.inDays < 1) {
//       return '${difference.inHours}h ago';
//     } else if (difference.inDays < 7) {
//       return '${difference.inDays}d ago';
//     } else {
//       return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
//     }
//   }
// }