import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// State notifier to handle loading state
class SignUpState {
  final bool isLoading;
  final String? error;

  SignUpState({this.isLoading = false, this.error});
}

// Create a StateNotifier instead of a regular provider
final signUpControllerProvider =
    StateNotifierProvider<SignUpController, SignUpState>(
        (ref) => SignUpController());

class SignUpController extends StateNotifier<SignUpState> {
  SignUpController() : super(SignUpState());

  // Variables
  final email = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();
  final signupformKey = GlobalKey<FormState>();

  // Firebase instances
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

 
  // Sign up method
  Future<void> signUp(BuildContext context) async {
    try {
      // Check if form is valid
      if (!signupformKey.currentState!.validate()) {
        return;
      }
      
      state = SignUpState(isLoading: true);

      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // Save additional user data in Firestore
      try {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
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

      // Clear form
      _clearForm();

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to login or home screen
        Navigator.pushNamedAndRemoveUntil(
            context, '/home',(route) => false); // Or '/home' depending on your flow
      }

      // Reset loading state
      state = SignUpState();
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
      _handleError(context, errorMessage);
    } catch (e) {
      _handleError(context, e.toString());
    }
  }

  // Handle errors
  void _handleError(BuildContext context, String errorMessage) {
    state = SignUpState(error: errorMessage);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Clear form
  void _clearForm() {
    email.clear();
    password.clear();
    firstName.clear();
    lastName.clear();
    phoneNumber.clear();
  }

  // Dispose controllers
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    super.dispose();
  }
}
