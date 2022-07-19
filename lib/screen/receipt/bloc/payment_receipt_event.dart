part of 'payment_receipt_bloc.dart';

abstract class PaymentReceiptEvent extends Equatable {
  const PaymentReceiptEvent();
}

class PaymentReceiptStarted extends PaymentReceiptEvent {
  final int orderId;

  const PaymentReceiptStarted(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
