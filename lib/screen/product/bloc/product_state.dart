part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductAddItemToCartButtonLoading extends ProductState {}

class ProductAddItemToCartButtonSuccess extends ProductState {}

class ProductAddItemToCartButtonError extends ProductState {
  final CustomError customError;

  const ProductAddItemToCartButtonError(this.customError);

  @override
  List<Object> get props => [customError];
}
