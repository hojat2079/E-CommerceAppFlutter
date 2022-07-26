class TokenResponseEntity {
  String accessToken;
  String refreshToken;
  String tokenType;
  int expiresIn;
  String username = "";

  TokenResponseEntity({
    required this.username,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  TokenResponseEntity.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        refreshToken = json['refresh_token'],
        tokenType = json['token_type'],
        expiresIn = json['expires_in'];

  void setUsername(String username) {
    this.username = username;
  }
}
