import 'package:ecommerce_app/common/tuple2.dart';
import 'package:ecommerce_app/data/entity/token_response_entity.dart';
import 'package:ecommerce_app/data/source/auth_local_datasource.dart';
import 'package:ecommerce_app/data/source/auth_remote_datasource.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthRepository {
  Future<void> login(String username, String password);

  Future<void> register(String username, String password);

  Future<void> refreshToken();

  Future<void> saveTokenToDb(TokenResponseEntity token);

  Future<void> loadTokenFromDb();

  Future<void> signOut();
}

class AuthRepositoryImpl implements AuthRepository {
  static final ValueNotifier<TokenResponseEntity?> authChangeNotifier =
      ValueNotifier(null);
  final AuthRemoteDataSource authDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl(this.authDataSource, this.authLocalDataSource);

  @override
  Future<void> login(String username, String password) async {
    final tokenResponse = await authDataSource.login(username, password);
    debugPrint('token -> ${tokenResponse.accessToken}');
    await saveTokenToDb(tokenResponse);
  }

  @override
  Future<void> refreshToken() async {
    if (AuthRepositoryImpl.authChangeNotifier.value != null) {
      final tokenResponse = await authDataSource.refreshToken(
          AuthRepositoryImpl.authChangeNotifier.value!.refreshToken);
      debugPrint(
          'refresh Token is called!! new refresh token is : \n ${tokenResponse.refreshToken}');
      saveTokenToDb(tokenResponse);
    }
  }

  @override
  Future<void> register(String username, String password) async {
    final tokenResponse = await authDataSource.register(username, password);
    saveTokenToDb(tokenResponse);
  }

  @override
  Future<void> loadTokenFromDb() async {
    final TokenResponseEntity? tokenRes =
        await authLocalDataSource.loadTokenFromDb();
    if (tokenRes != null) {
      if (tokenRes.accessToken.isNotEmpty && tokenRes.refreshToken.isNotEmpty) {
        authChangeNotifier.value = tokenRes;
        debugPrint('load token from sharedPreferences!!');
      }
    }
  }

  @override
  Future<void> saveTokenToDb(TokenResponseEntity token) async {
    final resultSaveTokenToDb = await authLocalDataSource.saveTokenToDb(token);
    if (resultSaveTokenToDb) {
      debugPrint('save token to sharedPreferences!!');
      await loadTokenFromDb();
    }
  }

  @override
  Future<void> signOut() async {
    await authLocalDataSource.signOut();
    authChangeNotifier.value = null;
  }
}
