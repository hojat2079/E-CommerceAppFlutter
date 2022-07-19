part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class AddCartButtonClicked extends ProductEvent {
  final int productId;

  const AddCartButtonClicked(this.productId);
}
