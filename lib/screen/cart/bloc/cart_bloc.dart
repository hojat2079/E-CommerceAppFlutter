import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/common/custom_error.dart';
import 'package:ecommerce_app/data/entity/cart_response.dart';
import 'package:ecommerce_app/data/entity/token_response_entity.dart';
import 'package:ecommerce_app/data/repository/cart_repository.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        final TokenResponseEntity? tokenResponse = event.tokenResponse;
        if (tokenResponse == null || tokenResponse.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItem(emit, event.isRefreshed);
        }
      } else if (event is CartAuthChanged) {
        final TokenResponseEntity? tokenResponse = event.tokenResponse;
        if (tokenResponse == null || tokenResponse.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            await loadCartItem(emit, false);
          }
        }
      } else if (event is CartDeleteButtonClicked) {
        try {
          if (state is CartSuccess) {
            final CartSuccess cartSuccessState = state as CartSuccess;
            //show Loading
            cartSuccessState.cartResponse.cartItems
                .firstWhere((element) => element.id == event.cartItemId)
                .showLoadingDelete = true;
            emit(CartSuccess(cartSuccessState.cartResponse));

            await Future.delayed(const Duration(seconds: 2));
            await cartRepository.deleteItem(event.cartItemId);
            await cartRepository.getAllCountItem();

            if (state is CartSuccess) {
              final CartSuccess cartSuccessState = state as CartSuccess;
              //success remove Item
              cartSuccessState.cartResponse.cartItems
                  .removeWhere((element) => element.id == event.cartItemId);
              if (cartSuccessState.cartResponse.cartItems.isNotEmpty) {
                emit(calculatePriceInfo(cartSuccessState.cartResponse));
              } else {
                emit(CartEmptyState());
              }
            }
          }
        } catch (ex) {
          emit(CartRemoveItemFailed());
        }
      } else if (event is CartIncreaseCountItemButtonClicked ||
          event is CartDecreaseCountItemButtonClicked) {
        int cartItemId = 0;
        try {
          if (event is CartIncreaseCountItemButtonClicked) {
            cartItemId = event.cartItemId;
          } else if (event is CartDecreaseCountItemButtonClicked) {
            cartItemId = event.cartItemId;
          }
          if (state is CartSuccess) {
            final CartSuccess cartSuccessState = state as CartSuccess;
            //show Loading
            final cartItemIndex = cartSuccessState.cartResponse.cartItems
                .indexWhere((element) => element.id == cartItemId);
            cartSuccessState.cartResponse.cartItems[cartItemIndex]
                .showLoadingChangeCount = true;
            emit(CartSuccess(cartSuccessState.cartResponse));

            await Future.delayed(const Duration(seconds: 2));

            //change count
            final int newCount = event is CartIncreaseCountItemButtonClicked
                ? ++cartSuccessState.cartResponse.cartItems[cartItemIndex].count
                : --cartSuccessState
                    .cartResponse.cartItems[cartItemIndex].count;

            await cartRepository.changeCountItem(
              newCount,
              cartItemId,
            );
            await cartRepository.getAllCountItem();

            if (state is CartSuccess) {
              final CartSuccess cartSuccessState = state as CartSuccess;
              //success change Item
              cartSuccessState.cartResponse.cartItems
                  .firstWhere((element) => element.id == cartItemId)
                ..showLoadingChangeCount = false
                ..count = newCount;
              emit(calculatePriceInfo(cartSuccessState.cartResponse));
            }
          }
        } catch (ex) {
          emit(CartChangeItemFailed());
        }
      }
    });
  }

  Future<void> loadCartItem(Emitter<CartState> emit, bool isRefreshed) async {
    try {
      if (!isRefreshed) emit(CartLoading());
      await Future.delayed(const Duration(seconds: 2));
      final cartResponse = await cartRepository.getAllCart();
      //empty state
      if (cartResponse.cartItems.isEmpty) {
        emit(CartEmptyState());
      } else {
        emit(CartSuccess(cartResponse));
      }
    } catch (ex) {
      if (!isRefreshed) {
        if (ex is CustomError && (ex.errorCode == 401 || ex.errorCode == 402)) {
          emit(CartAuthRequired());
        } else {
          emit(CartError(
            ex is CustomError ? ex : CustomError(errorCode: 500),
          ));
        }
      }
    }
  }

  CartSuccess calculatePriceInfo(CartResponse cartResponse) {
    int totalPrice = 0;
    int payablePrice = 0;
    int shippingCost = 0;

    for (var cartItem in cartResponse.cartItems) {
      totalPrice += cartItem.productEntity.previousPrice * cartItem.count;
      payablePrice += cartItem.productEntity.price * cartItem.count;
    }

    shippingCost = payablePrice > 250000 ? 0 : 30000;

    cartResponse.totalPrice = totalPrice;
    cartResponse.payablePrice = payablePrice;
    cartResponse.shippingCost = shippingCost;

    return CartSuccess(cartResponse);
  }
}
