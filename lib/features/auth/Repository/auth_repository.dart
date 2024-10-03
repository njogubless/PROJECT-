import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/core/constants/firebase_constants.dart';
import 'package:devotion/core/providers/firebase_providers.dart';
import 'package:devotion/features/auth/data/models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final AuthRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      UserModel userModel;
      if(userCredential.additionalUserInfo!.isNewUser){
        userModel=UserModel(
        uid: userCredential.user!.uid,
        isAuthenticated: true,
        name: userCredential.user!.displayName ?? 'No name',
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      }
      

      //print(userCredential.user?.email);
    } catch (e) {
      print(e);
    }
  }
}
