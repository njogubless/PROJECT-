import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/core/constants/firebase_constants.dart';
import 'package:devotion/core/failure.dart';
import 'package:devotion/core/type_defs.dart';
import 'package:devotion/features/auth/data/models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    googleSignIn: GoogleSignIn(),
  ),
);

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();


  Future<bool> _userExistsInFirestore(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> _createUserInFirestore(User user) async {
    final newUser = UserModel(
      uid: user.uid,
      userName: user.displayName ?? 'No name',
      userEmail: user.email ?? 'No email',
      isAuthenticated: true,
      isAdmin: false,
    );
    await _users.doc(user.uid).set(newUser.toMap());
    return newUser;
  }

  /// Get user from Firestore
  Future<UserModel> _getUserFromFirestore(String uid) async {
    final doc = await _users.doc(uid).get();
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception('User data not found in Firestore');
    return UserModel.fromMap(data);
  }

  /// Sign in with Google
  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return left(Failure('Google sign-in cancelled.'));

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Check if user exists in Firestore
      final userExists = await _userExistsInFirestore(user.uid);
      
      UserModel userModel;
      if (userExists) {
        userModel = await _getUserFromFirestore(user.uid);
      } else {
        // Create new user in Firestore
        userModel = await _createUserInFirestore(user);
      }

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Google sign-in failed.'));
    } catch (e) {
      return left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  /// Sign in with Email and Password
  FutureEither<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;

      // For email/password login, user MUST exist in Firestore
      // We don't auto-create users for email/password login
      final userExists = await _userExistsInFirestore(user.uid);
      
      if (!userExists) {
        // Sign out the user from Firebase Auth since they don't exist in our system
        await _auth.signOut();
        return left(Failure('Account not found. Please sign up first.'));
      }

      final userModel = await _getUserFromFirestore(user.uid);
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      return left(Failure(_mapFirebaseAuthError(e.code)));
    } catch (e) {
      return left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  /// Sign up with Email and Password (create new account)
  FutureEither<UserModel> signUpWithEmailAndPassword(
      String email, String password, String userName) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;

      // Update display name
      await user.updateDisplayName(userName);
      
      // Create user in Firestore
      final userModel = await _createUserInFirestore(user);
      
      // Send email verification
      await user.sendEmailVerification();

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      return left(Failure(_mapFirebaseAuthError(e.code)));
    } catch (e) {
      return left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  /// Get user data stream from Firestore
  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) throw Exception('User data not found');
      return UserModel.fromMap(data);
    });
  }

  /// Sign out from Firebase and Google
  Future<void> signOutUser() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Map Firebase Auth error codes to user-friendly messages
  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}