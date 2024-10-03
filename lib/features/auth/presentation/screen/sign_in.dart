// presentation/screens/signin_screen.dart
import 'package:devotion/features/auth/controller/auth_controller.dart';
import 'package:devotion/features/auth/presentation/screen/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle email sign-in here
              },
              child: const Text('Sign In with Email'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read(authControllerProvider).signInWithGoogle();
              },
              child: const Text('Sign In with Google'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle phone number sign-in here
              },
              child: const Text('Sign In with Phone Number'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to Sign Up page
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: const Text('Don’t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
