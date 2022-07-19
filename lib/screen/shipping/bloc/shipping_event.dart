part of 'shipping_bloc.dart';

abstract class ShippingEvent extends Equatable {
  const ShippingEvent();
  @override
  List<Object?> get props => [];
}

class ShippingCreateOrder extends ShippingEvent {
  final CreateOrderParamsEntity params;

  const ShippingCreateOrder(this.params);

  @override
  List<Object?> get props => [params];
}
