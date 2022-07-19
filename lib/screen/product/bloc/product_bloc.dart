import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/common/custom_error.dart';
import 'package:ecommerce_app/data/repository/cart_repository.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final CartRepository cartRepository;

  ProductBloc(this.cartRepository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is AddCartButtonClicked) {
        emit(ProductAddItemToCartButtonLoading());
        await Future.delayed(const Duration(seconds: 2));
        try {
          await cartRepository.addItemToCart(event.productId);
          await cartRepository.getAllCountItem();
          emit(ProductAddItemToCartButtonSuccess());
        } catch (ex) {
          emit(ProductAddItemToCartButtonError(
            ex is CustomError ? ex : CustomError(errorCode: 500),
          ));
        }
      }
    });
  }
}
