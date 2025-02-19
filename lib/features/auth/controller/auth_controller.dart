// auth_controller.dart
import 'package:devotion/core/util/utils.dart';
import 'package:devotion/features/auth/data/models/user_models.dart';
import 'package:devotion/features/auth/Repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

//use the userProvider to update user information
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
    Routemaster.of(context).replace('/homeScreen');
  }

//signinWithEmailandPassword
  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    state = true;
    final user = await _authRepository.signInWithEmailAndPassword(
      email,
      password,
    );
    state = false;
    user.fold(
      (l) => showSnackbar(context, l.message),
      (userModel) {
        _ref.read(userProvider.notifier).update((state) => userModel);
        Routemaster.of(context).replace('/homeScreen');
      },
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      state = true;
      if (email.isEmpty) {
        throw 'please enter an email adress';
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset link sent to your email'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'Invalid-email':
          errorMessage = ' The email adress is invalid';
          break;
        case 'user-not-found':
          errorMessage = 'No User found with email adress';
          break;
        case ' too-many-requests ':
          errorMessage = 'Too many requests. Try again later';
          break;
        default:
          errorMessage = e.message ?? 'An error occured';
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      state = false;
    }
  }

  // Sign out the user
  void signOut(BuildContext context) async {
    await _authRepository.signOutUser();
    Navigator.pushReplacementNamed(
        context, '/login'); // Update to navigate back to the login screen
  }
}
