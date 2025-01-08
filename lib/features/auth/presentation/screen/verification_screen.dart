// presentation/screens/verification_screen.dart
import 'package:devotion/features/auth/presentation/screen/sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerificationScreen extends ConsumerWidget {
  final String verificationType;

  const VerificationScreen({super.key, required this.verificationType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify $verificationType')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Enter the 6-digit verification code sent to your $verificationType'),
            const TextField(
              decoration: InputDecoration(labelText: 'Verification Code'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.currentUser?.reload().then((_) {
                  if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  }
                });
              },
              child: const Text('I have verified'),
            ),
          ],
        ),
      ),
    );
  }
}
