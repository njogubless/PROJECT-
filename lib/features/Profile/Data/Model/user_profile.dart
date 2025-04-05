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
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      displayName: data['displayName'] ?? 'User',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'],
      bio: data['bio'],
      favoriteGenres: List<String>.from(data['favoriteGenres'] ?? []),
      playlistCount: data['playlistCount'] ?? 0,
      followersCount: data['followersCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
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
    );
  }
}