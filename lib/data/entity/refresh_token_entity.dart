import 'package:ecommerce_app/common/constant.dart';

class RefreshTokenPostEntity {
  final String token;
  final String grantType = Constant.grantTypeRefreshToken;
  final String clientSecret = Constant.clientSecret;
  final int clientId = Constant.clientId;

  RefreshTokenPostEntity({
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'grant_type': grantType,
      'refresh_token': token,
      'client_id': clientId,
      'client_secret': clientSecret,
    };
  }
}
