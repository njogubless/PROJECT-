import 'dart:convert';

class UserModel {
  final String uid;
  final bool isAuthenticated;
  final String userName;
  final String userEmail;
  final bool isAdmin;
  final String? firstName;
  final String? lastName;

  const UserModel({
    required this.uid,
    required this.isAuthenticated,
    required this.userEmail,
    required this.userName,
    this.isAdmin = false,
    this.firstName,
    this.lastName,
  });

  String get displayName {
    if (firstName != null && firstName!.isNotEmpty) {
      if (lastName != null && lastName!.isNotEmpty) {
        return '$firstName $lastName';
      } else {
        return firstName!;
      }
    } else if (lastName != null && lastName!.isNotEmpty) {
      return lastName!;
    } else if (userName.isNotEmpty && userName != 'No name') {
      return userName;
    } else {
   
      if (userEmail.contains('@')) {
        return userEmail.split('@')[0];
      } else {
        return 'User';
      }
    }
  }

  UserModel copyWith({
    String? uid,
    bool? isAuthenticated,
    String? userName,
    String? userEmail,
    bool? isAdmin,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      isAdmin: isAdmin ?? this.isAdmin,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'userName': userName,
      'userEmail': userEmail,
      'isAdmin': isAdmin,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: (map['uid'] as String?) ?? '',
      isAuthenticated: (map['isAuthenticated'] as bool?) ?? false,
      userName: (map['userName'] as String?) ?? 'No name',
      userEmail: (map['userEmail'] as String?) ??
          (map['email'] as String?) ??
          'No email',
      isAdmin: (map['isAdmin'] as bool?) ?? false,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
    );
  }


  factory UserModel.fromFirestore(Map<String, dynamic> firestoreData) {
    return UserModel(
      uid: firestoreData['uid'] ?? '',
      isAuthenticated: true,
      userEmail: firestoreData['email'] ?? 'No email',
      userName: firestoreData['displayName'] ?? 'No name',
      isAdmin: firestoreData['isAdmin'] ?? false,
      firstName: firestoreData['firstName'],
      lastName: firestoreData['lastName'],
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, isAuthenticated: $isAuthenticated, userName: $userName, userEmail: $userEmail, isAdmin: $isAdmin, firstName: $firstName, lastName: $lastName)';
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        other.userName == userName &&
        other.userEmail == userEmail &&
        other.isAdmin == isAdmin &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        isAuthenticated.hashCode ^
        userName.hashCode ^
        userEmail.hashCode ^
        isAdmin.hashCode ^
        (firstName?.hashCode ?? 0) ^
        (lastName?.hashCode ?? 0);
  }
}
