class User {
  final String userHandle;
  final String userName;
  final String displayName;
  final String? token;

  User(
      {required this.userHandle,
      required this.userName,
      required this.displayName,
      this.token});

  @override
  String toString() {
    return 'User{userHandle: $userHandle, userName: $userName, displayName: $displayName}';
  }
}
