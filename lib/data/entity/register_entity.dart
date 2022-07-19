class RegisterEntity {
  final String username;
  final String password;

  RegisterEntity({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'email': username, 'password': password};
  }
}
