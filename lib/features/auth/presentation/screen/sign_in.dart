 import 'package:devotion/core/providers/firebase_providers.dart';
import 'package:devotion/features/auth/Repository/auth_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInPage({super.key});

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
            // ElevatedButton(
            //   onPressed: () async {
            //     await _signIn(context, authRepository);
            //   },
            //   child: const Text('Sign In'),
            // ),
            ElevatedButton(
              onPressed: () => googleSignInProvider,
              child: const Text('Sign In with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
