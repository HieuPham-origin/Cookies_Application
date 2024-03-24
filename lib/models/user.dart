class User {
  final String userId;
  final String email;
  final String password;
  final String displayName;
  User(this.email, this.password, this.displayName, {required this.userId});
}
