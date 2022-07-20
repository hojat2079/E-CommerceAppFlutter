part of 'order_history_bloc.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();
}

class OrderHistoryInitial extends OrderHistoryState {
  @override
  List<Object> get props => [];
}
