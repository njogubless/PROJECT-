import 'package:devotion/features/auth/data/models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Future<void> signInWithGoogle(BuildContext context) async {
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
        
        // Save new user to Firestore
        if (userCredential.additionalUserInfo!.isNewUser) {
          UserModel userModel = UserModel(
            uid: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? 'No name',
            isAuthenticated: true,
          );
          await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        }
      }
    } catch (e) {
      debugPrint(e as String?);
      // Handle errors
    }
  }

  // Sign up with phone number
  Future<void> signUpWithPhoneNumber(String phoneNumber, BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle error
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
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Save user to Firestore
      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        name: email.split('@')[0],
        isAuthenticated: true,
      );
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      // Send email verification
      await userCredential.user!.sendEmailVerification();
    } catch (e) {
      // Handle errors
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      // Handle errors
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
}
