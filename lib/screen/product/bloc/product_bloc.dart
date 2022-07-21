import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/common/custom_error.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/repository/cart_repository.dart';
import 'package:ecommerce_app/data/repository/product_repository.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final CartRepository cartRepository;
  final ProductRepository productRepository;
  final bool isFavorite;

  ProductBloc(this.cartRepository, this.productRepository, this.isFavorite)
      : super(ProductInitial(isFavorite)) {
    on<ProductEvent>((event, emit) async {
      if (event is AddCartButtonClicked) {
        emit(ProductAddItemToCartButtonLoading(isFavorite));
        await Future.delayed(const Duration(seconds: 2));
        try {
          await cartRepository.addItemToCart(event.productId);
          await cartRepository.getAllCountItem();
          emit(ProductAddItemToCartButtonSuccess(isFavorite));
        } catch (ex) {
          emit(ProductAddItemToCartButtonError(
              ex is CustomError ? ex : CustomError(errorCode: 500),
              isFavorite));
        }
      } else if (event is ProductClickLikeButton) {
        if (productRepository.isExist(event.product)) {
          productRepository.delete(event.product);
        } else {
          productRepository.createOrUpdate(event.product);
        }
        emit(ProductInitial(!state.isFavorite));
      }
    });
  }
}
