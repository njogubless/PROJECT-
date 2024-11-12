// auth_repository.dart
import 'package:devotion/core/failure.dart';
import 'package:devotion/core/type_defs.dart';
import 'package:devotion/features/auth/data/models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:devotion/core/constants/firebase_constants.dart';

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

  // Sign in with Google
  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        UserModel userModel;

        // Save new user to Firestore if they are a new user
        if (userCredential.additionalUserInfo!.isNewUser) {
          UserModel userModel = UserModel(
            uid: userCredential.user!.uid,
            userName: userCredential.user!.displayName ?? 'No name',
            userEmail: userCredential.user!.displayemail ?? 'No email',
            role: userCredential.user!.displayrole ?? ' no role',
            isAuthenticated: true,
          );
          await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        } else {
          userModel = await getUserData(userCredential.user!.uid).first;
        }
      }
      return right(UserModel as UserModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Sign up with phone number
  Future<void> signUpWithPhoneNumber(
      String phoneNumber, BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        // Save verificationId for later use in verification
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Verify 6-digit code
  Future<void> verifyCode(
      String verificationId, String code, BuildContext context) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );
    try {
      await _auth.signInWithCredential(credential);
    } catch (e) {
      // Handle errors
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmail(
      String email, String password, String role, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        userName: email.split('@')[0],
        userEmail: email,
        role: role,
        isAuthenticated: true,
      );
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      await userCredential.user!.sendEmailVerification();
    } catch (e) {
      // Handle errors
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      // Handle errors
      return null;
    }
  }

  // Send password reset email
  Future<void> sendPasswordReset(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Handle errors
    }
  }

  // Sign out the user
  Future<void> signOutUser() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
