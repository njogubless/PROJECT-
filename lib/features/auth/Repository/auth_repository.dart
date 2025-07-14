import 'package:devotion/core/failure.dart';
import 'package:devotion/core/type_defs.dart';
import 'package:devotion/features/auth/data/models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<User?> get authStateChange => _auth.authStateChanges();

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

        late UserModel userModel;

     
        if (userCredential.additionalUserInfo!.isNewUser) {
          userModel = UserModel(
            uid: userCredential.user!.uid,
            userName: userCredential.user!.displayName ?? 'No name',
            userEmail: userCredential.user!.email ?? 'No email',
            isAuthenticated: true,
            isAdmin: false,
          );
          await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        } else {
          userModel = await getUserData(userCredential.user!.uid).first;
        }

        return right(userModel);
      }
      return left(Failure('Google sign-in failed.'));
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? 'Firestore error occurred'));
    } catch (e) {
      return left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  FutureEither<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      late UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          isAdmin: false,
          userEmail: userCredential.user!.email ?? 'No email',
          userName: userCredential.user!.displayName ?? 'No name',
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Authentication error occurred'));
    } catch (e) {
      return left(Failure('Unexpected error: ${e.toString()}'));
    }
  }


  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) {
      final data = event.data() as Map<String, dynamic>?;
      if (data != null) {
        return UserModel.fromMap(data);
      } else {
        throw Exception('User data not found');
      }
    });
  }

  Future<void> signOutUser() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
