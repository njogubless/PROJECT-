// presentation/screens/signup_screen.dart
import 'package:devotion/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Trigger phone/email sign-up logic here
                context.read(authControllerProvider).signUpWithPhoneNumber(
                  'phone_number', context);  // Example for phone number
              },
              child: const Text('Sign Up with Phone'),
            ),
            ElevatedButton(
              onPressed: () {
                // Trigger email sign-up logic
              },
              child: const Text('Sign Up with Email'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read(authControllerProvider).signInWithGoogle();
              },
              child: const Text('Sign Up with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
