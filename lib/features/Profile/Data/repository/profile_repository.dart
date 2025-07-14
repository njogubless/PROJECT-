import 'dart:io';
import 'package:devotion/features/Profile/Data/Model/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';


final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    storage: FirebaseStorage.instance,
  );
});

class ProfileRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  ProfileRepository({
    required this.firestore,
    required this.auth,
    required this.storage,
  });

  Stream<UserProfile?> getUserProfile() {
    final user = auth.currentUser;
    if (user == null) return Stream.value(null);
    
    return firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) => snapshot.exists 
            ? UserProfile.fromFirestore(snapshot) 
            : null);
  }

  Future<void> updateProfile({
    required String bio,
    required List<String> favoriteGenres,
  }) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'bio': bio,
      'favoriteGenres': favoriteGenres,
    });
  }

  Future<void> updateDisplayName(String displayName) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await Future.wait([
      firestore
          .collection('users')
          .doc(user.uid)
          .update({'displayName': displayName}),
      user.updateDisplayName(displayName),
    ]);
  }

  Future<String> uploadProfilePicture(XFile imageFile) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final File file = File(imageFile.path);
    final storageRef = storage
        .ref('user_avatars/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    await storageRef.putFile(file);
    final downloadUrl = await storageRef.getDownloadURL();

    await Future.wait([
      firestore
          .collection('users')
          .doc(user.uid)
          .update({'avatarUrl': downloadUrl}),
      user.updatePhotoURL(downloadUrl),
    ]);

    return downloadUrl;
  }

  Future<void> incrementPlaylistCount() async {
    final user = auth.currentUser;
    if (user == null) return;

    await firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'playlistCount': FieldValue.increment(1)
    });
  }

  Future<void> decrementPlaylistCount() async {
    final user = auth.currentUser;
    if (user == null) return;

  
    final doc = await firestore.collection('users').doc(user.uid).get();
    final data = doc.data() as Map<String, dynamic>?;
    final currentCount = data?['playlistCount'] ?? 0;

    if (currentCount > 0) {
      await firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'playlistCount': FieldValue.increment(-1)
      });
    }
  }
}