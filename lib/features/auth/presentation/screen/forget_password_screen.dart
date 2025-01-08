// presentation/screens/forgot_password_screen.dart
import 'package:devotion/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title:  Text('Forgot Password', style: titleText,)),
      body: Padding(
        padding: kDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50,),
            Text('Enter your email to reset your password', style: subTitle ,),
            const SizedBox(height: 5,),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 5,),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset email sent!')),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  debugPrint('Password is not being reset');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}
