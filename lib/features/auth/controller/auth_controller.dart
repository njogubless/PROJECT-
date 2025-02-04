// auth_controller.dart
import 'package:devotion/core/util/utils.dart';
import 'package:devotion/features/auth/data/models/user_models.dart';
import 'package:devotion/features/auth/Repository/auth_repository.dart';
import 'package:devotion/features/auth/presentation/screen/home_screen.dart';
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

  // Sign out the user
  void signOut(BuildContext context) async {
    await _authRepository.signOutUser();
    Navigator.pushReplacementNamed(
        context, '/login'); // Update to navigate back to the login screen
  }
}

// import 'package:devotion/core/util/utils.dart';
// import 'package:devotion/features/auth/Repository/auth_repository.dart';
// import 'package:devotion/features/auth/data/models/user_models.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// import 'package:routemaster/routemaster.dart';

// final userProvider = StateProvider<UserModel?>((ref) => null);

// final authControllerProvider =
//     StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
//   return AuthController(
//     authRepository: ref.watch(authRepositoryProvider),
//     ref: ref,
//   );
// });

// final authStateChangeProvider = StreamProvider((ref) {
//   final authController = ref.watch(authControllerProvider.notifier);
//   return authController.authStateChange;
// });

// final getUserDataProvider = StreamProvider.family((ref, String uid) {
//   final authController = ref.watch(authControllerProvider.notifier);
//   return authController.getUserData(uid);
// });

// class AuthController extends StateNotifier<AsyncValue<void>> {
//   final AuthRepository _authRepository;
//   final Ref _ref;

//   AuthController({
//     required AuthRepository authRepository,
//     required Ref ref,
//   })  : _authRepository = authRepository,
//         _ref = ref,
//         super(const AsyncValue.data(null));

//   Stream<User?> get authStateChange => _authRepository.authStateChange;

//   Future<void> signInWithGoogle(BuildContext context) async {
//     state = const AsyncValue.loading();
//     try {
//       final result = await _authRepository.signInWithGoogle();
//       state = const AsyncValue.data(null);

//       result.fold(
//         (failure) => showSnackbar(context, failure.message),
//         (userModel) {
//           _ref.read(userProvider.notifier).state = userModel;
//           if (userModel.role == 'admin') {
//             Routemaster.of(context).replace('/admin-dashboard');
//           } else {
//             Routemaster.of(context).replace('/homeScreen');
//           }
//         },
//       );
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//       showSnackbar(context, 'Error: $e');
//     }
//   }

//   Future<void> signInWithEmailAndPassword(
//     BuildContext context,
//     String email,
//     String password,
//   ) async {
//     state = const AsyncValue.loading();
//     try {
//       final result = await _authRepository.signInWithEmailAndPassword(
//         email,
//         password,
//       );
//       state = const AsyncValue.data(null);

//       result.fold(
//         (failure) => showSnackbar(context, failure.message),
//         (userModel) {
//           _ref.read(userProvider.notifier).state = userModel;
//           if (userModel.role == 'admin') {
//             Routemaster.of(context).replace('/admin-dashboard');
//           } else {
//             Routemaster.of(context).replace('/homescreen');
//           }
//         },
//       );
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//       showSnackbar(context, 'Error: $e');
//     }
//   }

//   Stream<UserModel> getUserData(String uid) {
//     return _authRepository.getUserData(uid);
//   }

//   Future<void> signOut(BuildContext context) async {
//     state = const AsyncValue.loading();
//     try {
//       await _authRepository.signOutUser();
//       _ref.read(userProvider.notifier).state = null;
//       state = const AsyncValue.data(null);
//       Routemaster.of(context).replace('/login');
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//       showSnackbar(context, 'Error: $e');
//     }
//   }
// }
