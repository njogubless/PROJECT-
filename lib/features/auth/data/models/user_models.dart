import 'dart:convert';

class UserModel {
  final String uid;
  final bool isAuthenticated;
  final String userName;
  final String userEmail;

  bool isAdmin = false;

  UserModel({
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
  
    String? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
   
      isAdmin: isAdmin,
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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      userName: map['userName'] as String,
      userEmail: map['userEmail'] as String,
     
      isAdmin: map['isAdmin'] as bool,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, isAuthenticated: $isAuthenticated, userName: $userName, userEmail: $userEmail,)';
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.encode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        other.userName == userName;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ isAuthenticated.hashCode ^ userName.hashCode;
  }
}
