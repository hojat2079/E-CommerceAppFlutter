part of 'cart_bloc.dart';

abstract class CartEvent {
  const CartEvent();
}

class CartStarted extends CartEvent {
  final TokenResponseEntity? tokenResponse;
  final bool isRefreshed;

  const CartStarted(this.tokenResponse, {this.isRefreshed = false});
}

class CartAuthChanged extends CartEvent {
  final TokenResponseEntity? tokenResponse;

  const CartAuthChanged(this.tokenResponse);
}

class CartDeleteButtonClicked extends CartEvent {
  final int cartItemId;

  const CartDeleteButtonClicked(this.cartItemId);
}

class CartIncreaseCountItemButtonClicked extends CartEvent {
  final int cartItemId;
  const CartIncreaseCountItemButtonClicked(this.cartItemId);
}

class CartDecreaseCountItemButtonClicked extends CartEvent {
  final int cartItemId;
  const CartDecreaseCountItemButtonClicked(this.cartItemId);
}
