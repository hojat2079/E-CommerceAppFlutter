import 'package:ecommerce_app/common/tuple2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/token_response_entity.dart';

abstract class AuthLocalDataSource {
  Future<bool> saveTokenToDb(TokenResponseEntity token);

  Future<TokenResponseEntity?> loadTokenFromDb();

  Future<void> signOut();
}

class AuthSharedPreferencesDataSource implements AuthLocalDataSource {
  @override
  Future<TokenResponseEntity?> loadTokenFromDb() async {
    final shP = await SharedPreferences.getInstance();
    final accessToken = shP.getString('access_token');
    final refreshToken = shP.getString('refresh_token');
    final tokenType = shP.getString('token_type');
    final expiresIn = shP.getInt('expires_in');
    if (accessToken != null && refreshToken != null && tokenType != null) {
      return TokenResponseEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: tokenType,
        expiresIn: expiresIn!,
      );
    }
    return null;
  }

  @override
  Future<bool> saveTokenToDb(TokenResponseEntity token) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final resultToken =
        await sharedPreferences.setString('access_token', token.accessToken);
    final resultRefreshToken =
        await sharedPreferences.setString('refresh_token', token.refreshToken);
    final resultTokenType =
        await sharedPreferences.setString('token_type', token.tokenType);
    final resultExpiresIn =
        await sharedPreferences.setInt('expires_in', token.expiresIn);
    return resultToken &&
        resultRefreshToken &&
        resultTokenType &&
        resultExpiresIn;
  }

  @override
  Future<void> signOut() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}
