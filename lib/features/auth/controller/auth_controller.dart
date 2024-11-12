// auth_controller.dart
import 'package:devotion/core/util/utils.dart';
import 'package:devotion/features/auth/data/models/user_models.dart';
import 'package:devotion/features/auth/data/repository/auth_repository.dart';
import 'package:devotion/features/auth/presentation/screen/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.authStateChange;
});



final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); //loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  // Sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackbar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
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
  void signUpWithEmail(
      String email, String password, String role, BuildContext context) {
    _authRepository.signUpWithEmail(email, password, role, context);
  }

  // Sign in with email and password
  void signInWithEmail(
      String email, String password, BuildContext context) async {
    final user =
        await _authRepository.signInWithEmail(email, password, context);

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
    Navigator.pushReplacementNamed(
        context, '/login'); // Update to navigate back to the login screen
  }
}
