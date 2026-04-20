import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';

class SignUpState {
  final bool isLoading;
  final String? error;

  SignUpState({this.isLoading = false, this.error});
}

final signUpControllerProvider =
    StateNotifierProvider<SignUpController, SignUpState>(
        (ref) => SignUpController());

class SignUpController extends StateNotifier<SignUpState> {
  SignUpController() : super(SignUpState());

  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController(); // ✅ Added confirm password
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();
  final signupformKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> signUp(BuildContext context) async {
    // ✅ Removed duplicate validate() call — screen owns validation
    try {
      state = SignUpState(isLoading: true);

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      try {
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'firstName': firstName.text.trim(),
          'lastName': lastName.text.trim(),
          'email': email.text.trim(),
          'phoneNumber': phoneNumber.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (firestoreError) {
        debugPrint('Firestore error: $firestoreError');
      }

      _clearForm();
      state = SignUpState(); // ✅ Reset state before navigation

      // ✅ No snackbar or navigation here — SignUpScreen owns that after signUp() returns
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = 'An error occurred during sign up.';
      }
      state = SignUpState(error: errorMessage);
      rethrow; // ✅ Rethrow so SignUpScreen can catch and show its own snackbar
    } catch (e) {
      state = SignUpState(error: e.toString());
      rethrow; // ✅ Rethrow so SignUpScreen can catch and show its own snackbar
    }
  }

  void _clearForm() {
    email.clear();
    password.clear();
    confirmPassword.clear();
    firstName.clear();
    lastName.clear();
    phoneNumber.clear();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    super.dispose();
  }
}