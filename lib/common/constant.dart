import 'package:ecommerce_app/data/source/product_local_datasource.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

class Constant {
  static const String baseUrl = 'http://expertdevelopers.ir/api/v1/';
  static const String grantTypeLogin = 'password';
  static const String grantTypeRefreshToken = 'refresh_token';
  static const int clientId = 2;
  static const clientSecret = 'kyj1c9sVcksqGU4scMX7nLDalkjp2WoqQEf8PKAC';

  static const defaultScrollPhysic = BouncingScrollPhysics();

  static const favoriteBox = 'product';
}
