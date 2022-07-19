import 'package:ecommerce_app/data/api_service/api_service.dart';
import 'package:ecommerce_app/data/entity/add_to_cart_response.dart';
import 'package:ecommerce_app/data/entity/cart_response.dart';

abstract class CartRemoteDataSource {
  Future<AddToCartResponse> addItemToCart(int productId);

  Future<AddToCartResponse> changeCountItem(int count, int productId);

  Future<void> deleteItem(int productId);

  Future<int> getAllCountItem();

  Future<CartResponse> getAllCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiService apiService;

  CartRemoteDataSourceImpl(this.apiService);

  @override
  Future<AddToCartResponse> addItemToCart(int productId) {
    return apiService.addItemToCart(productId);
  }

  @override
  Future<AddToCartResponse> changeCountItem(int count, int productId) {
    return apiService.changeCountItem(count, productId);
  }

  @override
  Future<void> deleteItem(int productId) {
    return apiService.deleteItem(productId);
  }

  @override
  Future<CartResponse> getAllCart() {
    return apiService.getAllCart();
  }

  @override
  Future<int> getAllCountItem() {
    return apiService.getAllCountItem();
  }
}
