class UserModel {
  final String id;
  final String username;
  final String passwordHash;

  UserModel({
    required this.id,
    required this.username,
    required this.passwordHash,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'passwordHash': passwordHash,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> m) {
    return UserModel(
      id: m['id'],
      username: m['username'],
      passwordHash: m['passwordHash'],
    );
  }
}
