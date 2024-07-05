import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository{
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;


  AuthRepository({required FirebaseFirestore firestore, required FirebaseFirestore auth, required GoogleSignin googleSignIn,})
  : _auth =auth,
  _firestore=firestore,
  _googleSignIn = googleSignIn,
  
  

}