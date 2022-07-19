import 'package:ecommerce_app/data/api_service/api_service.dart';
import 'package:ecommerce_app/data/entity/token_response_entity.dart';

abstract class AuthRemoteDataSource {
  Future<TokenResponseEntity> login(String username, String password);
  Future<TokenResponseEntity> register(String username, String password);
  Future<TokenResponseEntity> refreshToken(String token, String username);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl(this.apiService);

  @override
  Future<TokenResponseEntity> login(String username, String password) {
    return apiService.login(username, password);
  }

  @override
  Future<TokenResponseEntity> refreshToken(String token, String username) {
    return apiService.refreshToken(token, username);
  }

  @override
  Future<TokenResponseEntity> register(String username, String password) {
    return apiService.register(username, password);
  }
}
