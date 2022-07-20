import 'package:ecommerce_app/data/entity/banner_entity.dart';
import 'package:ecommerce_app/data/entity/cart_item_entity.dart';
import 'package:ecommerce_app/data/entity/add_to_cart_response.dart';
import 'package:ecommerce_app/data/entity/cart_response.dart';
import 'package:ecommerce_app/data/entity/checkout_entity.dart';
import 'package:ecommerce_app/data/entity/comment_entity.dart';
import 'package:ecommerce_app/data/entity/create_order_params_entity.dart';
import 'package:ecommerce_app/data/entity/create_order_result_entity.dart';
import 'package:ecommerce_app/data/entity/history_order_entity.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/entity/sort_type.dart';
import 'package:ecommerce_app/data/entity/token_response_entity.dart';

abstract class ApiService {
  Future<List<ProductEntity>> getAllProduct(SortType sortType);

  Future<List<ProductEntity>> searchProduct(String searchWord);

  Future<List<BannerEntity>> getBanner();

  Future<List<CommentEntity>> getComment(String productId);

  Future<TokenResponseEntity> login(String username, String password);

  Future<TokenResponseEntity> register(String username, String password);

  Future<TokenResponseEntity> refreshToken(String token, String username);

  Future<AddToCartResponse> addItemToCart(int productId);

  Future<AddToCartResponse> changeCountItem(int count, int productId);

  Future<void> deleteItem(int productId);

  Future<CartResponse> getAllCart();

  Future<int> getAllCountItem();

  Future<CreateOrderResultEntity> submitOrder(CreateOrderParamsEntity params);

  Future<CheckoutEntity> checkout(int orderId);

  Future<List<OrderHistoryEntity>> getHistoryOrder();
}
