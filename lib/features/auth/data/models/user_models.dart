 class UserModel {
 final String uid;
 final bool isAuthenticated;
 final String name;
 
  UserModel({
    required this.uid,
    required this.isAuthenticated,
    required this.name,
    
  });

  UserModel copyWith({
    String? uid,
    bool? isAuthenticated,
    String? name,
    
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      name: name ?? this.name,
     
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'name': name,
      
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      name: map['name'] as String,
      
    );
  }
  
  @override
  String toString() {
    return 'UserModel(uid: $uid, isAuthenticated: $isAuthenticated, name: $name, )';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.isAuthenticated == isAuthenticated &&
      other.name == name;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      isAuthenticated.hashCode ^
      name.hashCode ;
  }
}
 