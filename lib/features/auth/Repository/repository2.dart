// // auth_repository.dart
// import 'package:devotion/core/providers/firebase_providers.dart';
// import 'package:devotion/features/auth/data/models/user_models.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:fpdart/fpdart.dart';



// final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {

//   return FirebaseAuth.instance;

// });

// final authRepositoryProvider = Provider((ref) => AuthRepository(
//       auth: ref.watch(firebaseAuthProvider),
//       firestore: ref.watch(firestoreProvider),
//       googleSignIn: ref.watch(googleSignInProvider),
//     ));

// class AuthRepository {
//   final FirebaseAuth _auth;
//   final FirebaseFirestore _firestore;
//   final GoogleSignIn _googleSignIn;

//   AuthRepository({
//     required FirebaseAuth auth,
//     required FirebaseFirestore firestore,
//     required GoogleSignIn googleSignIn,
//   })  : _auth = auth,
//         _firestore = firestore,
//         _googleSignIn = googleSignIn;

//   CollectionReference get _users => _firestore.collection('users');
  
//   Stream<User?> get authStateChange => _auth.authStateChanges();

//   Future<Either<String, UserModel>> signInWithEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
      
//       final userDoc = await _users.doc(userCredential.user!.uid).get();
      
//       if (!userDoc.exists) {
//         return left('User data not found');
//       }
      
//       final userData = userDoc.data() as Map<String, dynamic>;
//       final userModel = UserModel.fromMap(userData);
      
//       return right(userModel);
//     } on FirebaseAuthException catch (e) {
//       return left(e.message ?? 'Authentication failed');
//     } catch (e) {
//       return left('An unexpected error occurred');
//     }
//   }

//   Future<Either<String, UserModel>> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return left('Google sign in aborted');

//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final userCredential = await _auth.signInWithCredential(credential);
//       final user = userCredential.user!;

//       // Check if user exists in Firestore
//       final userDoc = await _users.doc(user.uid).get();
      
//       if (!userDoc.exists) {
//         // Create new user
//         final userModel = UserModel(
//           uid: user.uid,
//           role: 'user',
//           isAuthenticated: true,
//           userEmail: user.email!,
//           userName: user.displayName ?? 'No name',
//         );
        
//         await _users.doc(user.uid).set(userModel.toMap());
//         return right(userModel);
//       }
      
//       // Return existing user
//       return right(UserModel.fromMap(userDoc.data() as Map<String, dynamic>));
//     } catch (e) {
//       return left(e.toString());
//     }
//   }

//   Future<void> signOut() async {
//     await Future.wait([
//       _auth.signOut(),
//       _googleSignIn.signOut(),
//     ]);
//   }
// }

// // auth_controller.dart
// class AuthController extends StateNotifier<AsyncValue<UserModel?>> {

//   void showErrorSnackbar(BuildContext context, String message) {
//     final snackBar = SnackBar(content: Text(message));
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//   final AuthRepository _authRepository;
//   final Ref _ref;

//   AuthController({
//     required AuthRepository authRepository,
//     required Ref ref,
//   })  : _authRepository = authRepository,
//         _ref = ref,
//         super(const AsyncValue.data(null));

//   Future<void> signInWithEmailAndPassword(
//     BuildContext context,
//     String email,
//     String password,
//   ) async {
//     state = const AsyncValue.loading();
    
//     final result = await _authRepository.signInWithEmailAndPassword(email, password);
    
//     result.fold(
//       (error) {
//         state = AsyncValue.error(error, StackTrace.current);
//         showErrorSnackbar(context, error);
//       },
//       (user) {
//         state = AsyncValue.data(user);
//         if (user.role == 'admin') {
//           Navigator.pushReplacementNamed(context, '/admin-dashboard');
//         } else {
//           Navigator.pushReplacementNamed(context, '/home');
//         }
//       },
//     );
//   }

//   Future<void> signInWithGoogle(BuildContext context) async {
//     state = const AsyncValue.loading();
    
//     final result = await _authRepository.signInWithGoogle();
    
//     result.fold(
//       (error) {
//         state = AsyncValue.error(error, StackTrace.current);
//         showErrorSnackbar(context, error);
//       },
//       (user) {
//         state = AsyncValue.data(user);
//         Navigator.pushReplacementNamed(context, '/home');
//       },
//     );
//   }

//   Future<void> signOut(BuildContext context) async {
//     await _authRepository.signOut();
//     state = const AsyncValue.data(null);
//     Navigator.pushReplacementNamed(context, '/login');
//   }
// }

