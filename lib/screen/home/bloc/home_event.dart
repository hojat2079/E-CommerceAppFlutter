part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeStarted extends HomeEvent {}

class HomeRefresh extends HomeEvent {}

class HomeClickLikeButton extends HomeEvent {
  final ProductEntity product;

  const HomeClickLikeButton(this.product);

  @override
  List<Object> get props => [product];
}
