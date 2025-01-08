import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/features/auth/data/models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  AuthService(
      {required FirebaseFirestore firestore,
      required FirebaseAuth firebaseAuth})
      : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  late UserModel _userModel;
  CollectionReference get _users => _firestore.collection('users');

  Stream<User?>get authStateChange => _firebaseAuth.authStateChanges();
  
   
}
