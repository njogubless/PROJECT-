import 'package:devotion/core/type_defs.dart';
import 'package:devotion/features/auth/data/models/user_models.dart';
import 'package:devotion/features/auth/Repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Map<String, DateTime> _lastEmailSent = {};

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Future<void> _handleAuthResult(
      BuildContext context, FutureEither<UserModel> result) async {
    state = true;
    final outcome = await result;
    state = false;

    outcome.fold(
      (l) => _showSnackBar(context, l.message),
      (userModel) async {
        if (context.mounted) {
          _ref.read(userProvider.notifier).update((state) => userModel);
          Routemaster.of(context).push('/homeScreen');
        }
      },
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    await _handleAuthResult(context, _authRepository.signInWithGoogle());
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _handleAuthResult(
        context, _authRepository.signInWithEmailAndPassword(email, password));
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    if (email.isEmpty) {
      _showSnackBar(context, 'Please enter an email address.');
      return;
    }
    try {
      state = true;
      await _auth.sendPasswordResetEmail(email: email);
      if (context.mounted) {
        _showSnackBar(context, 'Password reset link sent to your email.',
            isError: false);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        final error = _mapFirebaseError(e.code);
        _showSnackBar(context, error);
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, e.toString());
      }
    } finally {
      state = false;
    }
  }

  Future<void> resendVerificationEmail(BuildContext context) async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        final lastSent = _lastEmailSent[user.email];
        final now = DateTime.now();
        if (lastSent != null && now.difference(lastSent).inSeconds < 60) {
          throw 'Please wait ${60 - now.difference(lastSent).inSeconds} seconds before requesting another email.';
        }

        await user.sendEmailVerification();
        _lastEmailSent[user.email!] = now;

        if (context.mounted) {
          _showSnackBar(context, 'Verification email resent successfully.',
              isError: false);
        }
      } else {
        throw 'User not found or already verified.';
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, e.toString());
      }
    }
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    await _authRepository.signOutUser();
    _ref.read(userProvider.notifier).update((state) => null);
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No user found with that email address.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}