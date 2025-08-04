import 'dart:convert';

class UserModel {
  final String uid;
  final bool isAuthenticated;
  final String userName;
  final String userEmail;
  final bool isAdmin;

  const UserModel({
    required this.uid,
    required this.isAuthenticated,
    required this.userEmail,
    required this.userName,
    this.isAdmin = false,
  });

  UserModel copyWith({
    String? uid,
    bool? isAuthenticated,
    String? userName,
    String? userEmail,
    bool? isAdmin,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'userName': userName,
      'userEmail': userEmail,
      'isAdmin': isAdmin,
    };
  }

  // Fixed fromMap method with null safety
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: (map['uid'] as String?) ?? '',
      isAuthenticated: (map['isAuthenticated'] as bool?) ?? false,
      userName: (map['userName'] as String?) ?? 'No name',
      userEmail: (map['userEmail'] as String?) ?? 'No email',
      isAdmin: (map['isAdmin'] as bool?) ?? false,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, isAuthenticated: $isAuthenticated, userName: $userName, userEmail: $userEmail, isAdmin: $isAdmin)';
  }

  String toJson() => json.encode(toMap());

  // Fixed fromJson method
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        other.userName == userName &&
        other.userEmail == userEmail &&
        other.isAdmin == isAdmin;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        isAuthenticated.hashCode ^
        userName.hashCode ^
        userEmail.hashCode ^
        isAdmin.hashCode;
  }
}