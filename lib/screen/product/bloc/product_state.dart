part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  final bool isFavorite;

  const ProductState(this.isFavorite);

  @override
  List<Object> get props => [isFavorite];
}

class ProductInitial extends ProductState {
  const ProductInitial(bool isFavorite) : super(isFavorite);
}

class ProductAddItemToCartButtonLoading extends ProductState {
  const ProductAddItemToCartButtonLoading(bool isFavorite) : super(isFavorite);
}

class ProductAddItemToCartButtonSuccess extends ProductState {
  const ProductAddItemToCartButtonSuccess(bool isFavorite) : super(isFavorite);
}

class ProductAddItemToCartButtonError extends ProductState {
  final CustomError customError;

  const ProductAddItemToCartButtonError(this.customError, bool isFavorite)
      : super(isFavorite);

  @override
  List<Object> get props => [super.isFavorite, customError];
}
