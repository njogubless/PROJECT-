import 'package:devotion/features/auth/presentation/screen/login_screen.dart';
import 'package:devotion/features/auth/presentation/screen/welcome.dart';
import 'package:devotion/firebase_options.dart';
import 'package:devotion/theme/pallete.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reflections on Faith',
      theme: Pallete.lightModeAppTheme,
      home: const LoginScreen(),
    );
  }
}
