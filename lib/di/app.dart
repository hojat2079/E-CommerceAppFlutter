import 'package:dio/dio.dart';
import 'package:ecommerce_app/common/constant.dart';
import 'package:ecommerce_app/data/api_service/api_service.dart';
import 'package:ecommerce_app/data/api_service/dio_api_service.dart';
import 'package:ecommerce_app/data/repository/auth_repository.dart';
import 'package:ecommerce_app/data/repository/banner_repository.dart';
import 'package:ecommerce_app/data/repository/cart_repository.dart';
import 'package:ecommerce_app/data/repository/comment_repository.dart';
import 'package:ecommerce_app/data/repository/order_repository.dart';
import 'package:ecommerce_app/data/repository/product_repository.dart';
import 'package:ecommerce_app/data/source/auth_local_datasource.dart';
import 'package:ecommerce_app/data/source/auth_remote_datasource.dart';
import 'package:ecommerce_app/data/source/banner_datasource.dart';
import 'package:ecommerce_app/data/source/cart_datasource.dart';
import 'package:ecommerce_app/data/source/comment_datasource.dart';
import 'package:ecommerce_app/data/source/order_datasource.dart';
import 'package:ecommerce_app/data/source/product_datasource.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providesList = [
  Provider.value(
    value: Dio(
      BaseOptions(baseUrl: Constant.baseUrl),
    )..interceptors.add(
        InterceptorsWrapper(
          onRequest: ((options, handler) async {
            final tokenResponse = AuthRepositoryImpl.authChangeNotifier.value;
            if (tokenResponse != null && tokenResponse.accessToken.isNotEmpty) {
              options.headers['Authorization'] =
                  'Bearer ${tokenResponse.accessToken}';
            }
            handler.next(options);
          }),
          onError: ((error, handler) async {
            if ((error.response?.statusCode == 401 ||
                    error.response?.statusCode == 403) &&
                AuthRepositoryImpl.authChangeNotifier.value != null &&
                AuthRepositoryImpl
                    .authChangeNotifier.value!.accessToken.isNotEmpty) {
              //todo await refresh token method call!!
              //todo retry method call!!
            }
            // handler.next(error);
          }),
        ),
      ),
  ),
  ProxyProvider<Dio, ApiService>(
      update: (context, dio, api) => DioApiService(dio)),
  ProxyProvider<ApiService, BannerDataSource>(
    update: (context, api, bannerDataSource) => BannerRemoteDataSource(api),
  ),
  ProxyProvider<BannerDataSource, BannerRepository>(
    update: (context, bannerDataSource, bannerRepository) =>
        BannerRepositoryImpl(bannerDataSource),
  ),
  ProxyProvider<ApiService, ProductDataSource>(
    update: (context, api, productDataSource) => ProductRemoteDataSource(api),
  ),
  ProxyProvider<ProductDataSource, ProductRepository>(
    update: (context, productDataSource, productRepository) =>
        ProductRepositoryImpl(productDataSource),
  ),
  ProxyProvider<ApiService, OrderDataSource>(
    update: (context, api, orderDataSource) => OrderRemoteDataSource(api),
  ),
  ProxyProvider<OrderDataSource, OrderRepository>(
    update: (context, orderDatasource, orderRepository) =>
        OrderRepositoryImpl(orderDatasource),
  ),
  ProxyProvider<ApiService, CommentDataSource>(
    update: (context, api, commentDataSource) => CommentRemoteDataSource(api),
  ),
  ProxyProvider<CommentDataSource, CommentRepository>(
    update: (context, commentDatasource, commentRepository) =>
        CommentRepositoryImpl(commentDatasource),
  ),
  ProxyProvider<ApiService, CartRemoteDataSource>(
    update: (context, api, commentDataSource) => CartRemoteDataSourceImpl(api),
  ),
  ProxyProvider<CartRemoteDataSource, CartRepository>(
    update: (context, cartRemoteDataSource, cartRepository) =>
        CartRepositoryImpl(cartRemoteDataSource),
  ),
  ProxyProvider<ApiService, AuthRemoteDataSource>(
    update: (context, api, authDataSource) => AuthRemoteDataSourceImpl(api),
  ),
  Provider<AuthLocalDataSource>(
    create: (context) => AuthSharedPreferencesDataSource(),
  ),
  ProxyProvider2<AuthRemoteDataSource, AuthLocalDataSource, AuthRepository>(
    update: (
      context,
      authRemoteDatasource,
      authLocalDatasource,
      authRepository,
    ) =>
        AuthRepositoryImpl(authRemoteDatasource, authLocalDatasource),
  ),
];
