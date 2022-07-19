part of 'shipping_bloc.dart';

abstract class ShippingState extends Equatable {
  const ShippingState();

  @override
  List<Object> get props => [];
}

class ShippingInitial extends ShippingState {}

class ShippingLoading extends ShippingState {}

class ShippingSuccess extends ShippingState {
  final CreateOrderResultEntity createOrderResult;

  const ShippingSuccess(this.createOrderResult);

  @override
  List<Object> get props => [createOrderResult];
}

class ShippingError extends ShippingState {
  final CustomError customError;

  const ShippingError(this.customError);

  @override
  List<Object> get props => [customError];
}
