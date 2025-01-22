import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider for SignUpController
final signUpControllerProvider = Provider((ref) => SignUpController());

class SignUpController {
  //variables
  final email = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();

  GlobalKey<FormState> signupformKey = GlobalKey<FormState>();

  Future<void> signUp() async {
    try {
      //start loading

      //check connectivity

      //form validation

      //Register user in firebase and save user data in firestore
      

      //save authenticated user in firestore

      //show success message
    } catch (e) {
      // handle error
    }
  }
}
