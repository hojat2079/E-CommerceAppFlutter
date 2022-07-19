import 'package:dio/dio.dart';
import 'package:ecommerce_app/common/custom_error.dart';
import 'package:ecommerce_app/data/repository/auth_repository.dart';

class HttpResponseValidator {
  bool validateResponse(Response response) {
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else if ((response.statusCode == 401 || response.statusCode == 403) &&
        AuthRepositoryImpl.authChangeNotifier.value != null &&
        AuthRepositoryImpl.authChangeNotifier.value!.accessToken.isNotEmpty) {
      //refresh token
    } else {
      throw CustomError(
        errorCode: response.statusCode ?? 500,
        message: (response.data as Map<String, dynamic>)['message'] ??
            response.statusMessage ??
            'خطای نامشخص',
      );
    }
    return false;
  }
}
