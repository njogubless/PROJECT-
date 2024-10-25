import 'package:devotion/features/auth/presentation/screen/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signUpWithEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Store the user in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'uid': userCredential.user!.uid,
        });

        // Send email verification
        await userCredential.user!.sendEmailVerification();

        // Navigate to email verification page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>VerificationScreen(verificationType: '',)),
        );
      } catch (e) {
        print('Error during sign up: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during sign up: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUpWithEmail,
                child: Text('Sign Up'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _signUpWithGoogle, // Google sign-in logic
                child: Text('Sign Up with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUpWithGoogle() async {
    // Add Google sign-in logic here
  }
}
