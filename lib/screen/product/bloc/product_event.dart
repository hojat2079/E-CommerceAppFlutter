part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class AddCartButtonClicked extends ProductEvent {
  final int productId;

  const AddCartButtonClicked(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductClickLikeButton extends ProductEvent {
  final ProductEntity product;

  const ProductClickLikeButton(this.product);

  @override
  List<Object?> get props => [product];
}
