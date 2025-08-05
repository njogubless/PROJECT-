import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final List<String> favoriteGenres;
  final int playlistCount;
  final int followersCount;
  final int followingCount;
  final String? firstName;
  final String? lastName;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.favoriteGenres = const [],
    this.playlistCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.firstName,
    this.lastName,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
 
    final firstName = data['firstName'] as String?;
    final lastName = data['lastName'] as String?;
    

    String displayName;
    if (firstName != null && firstName.isNotEmpty) {
      if (lastName != null && lastName.isNotEmpty) {
        displayName = '$firstName $lastName';
      } else {
        displayName = firstName;
      }
    } else if (lastName != null && lastName.isNotEmpty) {
      displayName = lastName;
    } else {

      final email = data['email'] as String?;
      if (email != null && email.contains('@')) {
        displayName = email.split('@')[0];
      } else {
        displayName = 'User';
      }
    }
    
    return UserProfile(
      uid: doc.id,
      displayName: displayName,
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'],
      bio: data['bio'],
      favoriteGenres: List<String>.from(data['favoriteGenres'] ?? []),
      playlistCount: data['playlistCount'] ?? 0,
      followersCount: data['followersCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'favoriteGenres': favoriteGenres,
      'playlistCount': playlistCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }

  UserProfile copyWith({
    String? displayName,
    String? email,
    String? avatarUrl,
    String? bio,
    List<String>? favoriteGenres,
    int? playlistCount,
    int? followersCount,
    int? followingCount,
    String? firstName,
    String? lastName,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      playlistCount: playlistCount ?? this.playlistCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}