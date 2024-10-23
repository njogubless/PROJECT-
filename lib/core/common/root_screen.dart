// // lib/core/presentation/screens/root_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class RootScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final isAdmin = watch(isAdminProvider);

//     return isAdmin.when(
//       data: (isAdmin) {
//         if (isAdmin) {
//           return AdminDashboardScreen();
//         } else {
//           return UserBottomNavBar();
//         }
//       },
//       loading: () => CircularProgressIndicator(),
//       error: (e, _) => Text('Error determining role'),
//     );
//   }
// }
