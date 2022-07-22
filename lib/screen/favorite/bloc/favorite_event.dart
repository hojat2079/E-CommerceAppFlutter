part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class FavoriteStarted extends FavoriteEvent {}

class FavoriteDeleteItem extends FavoriteEvent {
  final ProductEntity productEntity;

  const FavoriteDeleteItem(this.productEntity);

  @override
  List<Object?> get props => [productEntity];
}
