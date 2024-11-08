// auth_controller.dart
import 'package:devotion/features/auth/data/repository/auth_repository.dart';
import 'package:devotion/features/auth/presentation/screen/welcome.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
  ),
);

class AuthController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  // Sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    final user = await _authRepository.signInWithGoogle(context);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  // Sign up with phone number
  void signUpWithPhoneNumber(String phoneNumber, BuildContext context) {
    _authRepository.signUpWithPhoneNumber(phoneNumber, context);
  }

  // Verify 6-digit code for phone authentication
  void verifyCode(String verificationId, String code, BuildContext context) {
    _authRepository.verifyCode(verificationId, code, context);
  }

  // Sign up with email and password
  void signUpWithEmail(String email, String password, String role, BuildContext context) {
    _authRepository.signUpWithEmail(email, password, role, context);
  }

  // Sign in with email and password
  void signInWithEmail(String email, String password, BuildContext context) async {
    final user = await _authRepository.signInWithEmail(email, password, context);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  // Send password reset email
  void sendPasswordReset(String email, BuildContext context) {
    _authRepository.sendPasswordReset(email, context);
  }

  // Sign out the user
  void signOut(BuildContext context) async {
    await _authRepository.signOutUser();
    Navigator.pushReplacementNamed(context, '/login'); // Update to navigate back to the login screen
  }
}
