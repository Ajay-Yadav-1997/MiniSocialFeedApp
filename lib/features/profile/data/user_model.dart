class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photo;
  final String bio;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photo,
    required this.bio,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      name: data['displayName'],
      email: data['email'],
      photo: data['photoUrl'],
      bio: data['bio'],
    );
  }
}
