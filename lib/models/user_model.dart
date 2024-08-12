class UserModel {
  final String uid; // User ID
  final String email;
  final String? displayName; // Optional display name

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
  });

  // Converts a UserModel instance into a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
    };
  }

  // Creates a UserModel instance from a map (e.g., fetched from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
    );
  }
}
