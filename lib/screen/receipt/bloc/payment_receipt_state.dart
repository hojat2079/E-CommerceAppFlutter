part of 'payment_receipt_bloc.dart';

abstract class PaymentReceiptState extends Equatable {
  const PaymentReceiptState();

  @override
  List<Object> get props => [];
}

class PaymentReceiptLoading extends PaymentReceiptState {}

class PaymentReceiptError extends PaymentReceiptState {
  final CustomError customError;

  const PaymentReceiptError(this.customError);

  @override
  List<Object> get props => [customError];
}

class PaymentReceiptSuccess extends PaymentReceiptState {
  final CheckoutEntity checkout;

  const PaymentReceiptSuccess(this.checkout);

  @override
  List<Object> get props => [checkout];
}
