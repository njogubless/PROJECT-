// presentation/screens/splash_screen.dart
import 'package:devotion/features/auth/presentation/screen/sign_in.dart';
import 'package:devotion/features/auth/presentation/screen/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is signed in, navigate to the main screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      } else {
        // User is not signed in, navigate to sign-up screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      }
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/flower.jpg', fit: BoxFit.cover),
          const Center(
            child: Text(
              'Reflections on Faith',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
