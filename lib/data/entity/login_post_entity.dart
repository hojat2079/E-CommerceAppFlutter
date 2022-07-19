import 'package:ecommerce_app/common/constant.dart';

class LoginPostEntity {
  String username;
  String password;
  int clientId = Constant.clientId;
  String grantType = Constant.grantTypeLogin;
  String clientSecret = Constant.clientSecret;

  LoginPostEntity({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'grant_type': grantType,
      'client_id': clientId,
      'client_secret': clientSecret,
      'username': username,
      'password': password,
    };
  }
}
