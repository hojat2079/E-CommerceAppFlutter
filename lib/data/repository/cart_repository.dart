import 'package:ecommerce_app/data/entity/add_to_cart_response.dart';
import 'package:ecommerce_app/data/entity/cart_item_entity.dart';
import 'package:ecommerce_app/data/entity/cart_response.dart';
import 'package:ecommerce_app/data/source/cart_datasource.dart';
import 'package:flutter/cupertino.dart';

abstract class CartRepository {
  Future<AddToCartResponse> addItemToCart(int productId);

  Future<AddToCartResponse> changeCountItem(int count, int productId);

  Future<void> deleteItem(int productId);

  Future<int> getAllCountItem();

  Future<CartResponse> getAllCart();
}

class CartRepositoryImpl implements CartRepository {
  static ValueNotifier<int> countItemNotifier = ValueNotifier(0);

  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<AddToCartResponse> addItemToCart(int productId) {
    return remoteDataSource.addItemToCart(productId);
  }

  @override
  Future<AddToCartResponse> changeCountItem(int count, int productId) {
    return remoteDataSource.changeCountItem(count, productId);
  }

  @override
  Future<void> deleteItem(int productId) {
    return remoteDataSource.deleteItem(productId);
  }

  @override
  Future<CartResponse> getAllCart() {
    return remoteDataSource.getAllCart();
  }

  @override
  Future<int> getAllCountItem() async {
    int value = await remoteDataSource.getAllCountItem();
    countItemNotifier.value = value;
    return value;
  }
}
