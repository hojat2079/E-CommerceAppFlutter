part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
}

class FavoriteInitial extends FavoriteState {
  final ValueListenable<Box<ProductEntity>> listenable;

  const FavoriteInitial(this.listenable);

  @override
  List<Object> get props => [listenable];
}
