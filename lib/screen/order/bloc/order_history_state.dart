part of 'order_history_bloc.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistorySuccess extends OrderHistoryState {
  final List<OrderHistoryEntity> orders;

  const OrderHistorySuccess(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderHistoryEmpty extends OrderHistoryState {}

class OrderHistoryError extends OrderHistoryState {
  final CustomError customError;

  const OrderHistoryError(this.customError);

  @override
  List<Object> get props => [customError];
}
