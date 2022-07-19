part of 'cart_bloc.dart';

abstract class CartState {
  const CartState();
}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final CartResponse cartResponse;

  const CartSuccess(this.cartResponse);
}

class CartError extends CartState {
  final CustomError customError;

  const CartError(this.customError);
}

class CartAuthRequired extends CartState {}

class CartEmptyState extends CartState {}

class CartRemoveItemFailed extends CartState {
  String message;

  CartRemoveItemFailed({this.message = 'مشکلی در حذف آیتم بوجود آمد'});
}

class CartChangeItemFailed extends CartState {
  String message;

  CartChangeItemFailed({this.message = 'مشکلی در تغییر تعداد آیتم بوجود آمد'});
}
