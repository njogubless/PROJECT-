import 'package:devotion/features/auth/data/repository/auth_repository.dart';
import 'package:devotion/features/auth/presentation/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Reading the AuthRepository provider using Riverpod
    final authRepository = ref.read(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _signIn(context, authRepository);
              },
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _signInWithGoogle(context, authRepository);
              },
              child: const Text('Sign In with Google'),
            ),
          ],
        ),
      ),
    );
  }

  // Email/Password Sign-In Function
  Future<void> _signIn(BuildContext context, AuthRepository authRepo) async {
    try {
      final user = await authRepo.signInWithEmail(
        emailController.text,
        passwordController.text,
        context,
      );
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to HomeScreen
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // Google Sign-In Function
  Future<void> _signInWithGoogle(BuildContext context, AuthRepository authRepo) async {
    try {
      await authRepo.signInWithGoogle(); // Handle Google Sign-In logic
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to HomeScreen
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
