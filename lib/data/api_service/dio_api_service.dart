import 'package:dio/dio.dart';
import 'package:ecommerce_app/data/api_service/api_service.dart';
import 'package:ecommerce_app/data/common/http_response_validator.dart';
import 'package:ecommerce_app/data/entity/banner_entity.dart';
import 'package:ecommerce_app/data/entity/cart_item_entity.dart';
import 'package:ecommerce_app/data/entity/add_to_cart_response.dart';
import 'package:ecommerce_app/data/entity/cart_response.dart';
import 'package:ecommerce_app/data/entity/checkout_entity.dart';
import 'package:ecommerce_app/data/entity/comment_entity.dart';
import 'package:ecommerce_app/data/entity/create_order_params_entity.dart';
import 'package:ecommerce_app/data/entity/create_order_result_entity.dart';
import 'package:ecommerce_app/data/entity/login_post_entity.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/entity/refresh_token_entity.dart';
import 'package:ecommerce_app/data/entity/register_entity.dart';
import 'package:ecommerce_app/data/entity/sort_type.dart';
import 'package:ecommerce_app/data/entity/token_response_entity.dart';

class DioApiService with HttpResponseValidator implements ApiService {
  final Dio httpClient;

  DioApiService(this.httpClient);

  @override
  Future<List<BannerEntity>> getBanner() async {
    final response = await httpClient.get('banner/slider');
    final List<BannerEntity> bannerList = [];
    validateResponse(response);
    for (var element in (response.data as List)) {
      bannerList.add(BannerEntity.fromJson(element));
    }
    return bannerList;
  }

  @override
  Future<List<ProductEntity>> getAllProduct(SortType sortType) async {
    final response =
        await httpClient.get('product/list?sort=${sortType.index}');
    final List<ProductEntity> productList = [];
    validateResponse(response);
    for (var element in (response.data as List)) {
      productList.add(ProductEntity.fromJson(element));
    }
    return productList;
  }

  @override
  Future<List<ProductEntity>> searchProduct(String searchWord) async {
    final response = await httpClient.get('search?q=$searchWord');
    final List<ProductEntity> products = [];
    validateResponse(response);
    for (var element in (response.data as List)) {
      products.add(ProductEntity.fromJson(element));
    }
    return products;
  }

  @override
  Future<List<CommentEntity>> getComment(String productId) async {
    final response = await httpClient.get('comment/list?product_id=$productId');
    final List<CommentEntity> comments = [];
    validateResponse(response);
    for (var element in (response.data as List)) {
      comments.add(CommentEntity.fromJson(element));
    }
    return comments;
  }

  @override
  Future<TokenResponseEntity> login(String username, String password) async {
    final response = await httpClient.post('auth/token',
        data: LoginPostEntity(username: username, password: password).toJson());
    validateResponse(response);
    return TokenResponseEntity.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TokenResponseEntity> refreshToken(String token) async {
    final response = await httpClient.post('auth/token',
        data: RefreshTokenPostEntity(token: token).toJson());
    validateResponse(response);
    return TokenResponseEntity.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TokenResponseEntity> register(String username, String password) async {
    final response = await httpClient.post('user/register',
        data: RegisterEntity(username: username, password: password).toJson());
    validateResponse(response);
    return login(username, password);
  }

  @override
  Future<AddToCartResponse> addItemToCart(int productId) async {
    final response = await httpClient.post(
      'cart/add',
      data: {'product_id': productId},
    );
    validateResponse(response);
    return AddToCartResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AddToCartResponse> changeCountItem(int count, int productId) async {
    final response = await httpClient.post(
      'cart/changeCount',
      data: {
        'cart_item_id': productId,
        "count": count,
      },
    );
    validateResponse(response);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteItem(int productId) async {
    final response = await httpClient.post(
      'cart/remove',
      data: {'cart_item_id': productId},
    );
    validateResponse(response);
  }

  @override
  Future<CartResponse> getAllCart() async {
    final response = await httpClient.get(
      'cart/list',
    );
    validateResponse(response);
    return CartResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<int> getAllCountItem() async {
    final response = await httpClient.get(
      'cart/count',
    );
    validateResponse(response);
    return response.data['count'];
  }

  @override
  Future<CreateOrderResultEntity> submitOrder(
      CreateOrderParamsEntity params) async {
    final response = await httpClient.post(
      'order/submit',
      data: params.toJson(),
    );
    validateResponse(response);
    return CreateOrderResultEntity.fromJson(response.data);
  }

  @override
  Future<CheckoutEntity> checkout(int orderId) async {
    final response = await httpClient.get('order/checkout?order_id=$orderId');
    validateResponse(response);
    return CheckoutEntity.fromJson(response.data);
  }
}
