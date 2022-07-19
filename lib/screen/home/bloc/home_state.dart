part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final CustomError error;

  const HomeError(this.error);

  @override
  List<Object> get props => [error];
}

class HomeSuccess extends HomeState {
  final List<BannerEntity> banners;
  final List<ProductEntity> latestProduct;
  final List<ProductEntity> popularProduct;

  const HomeSuccess(
      {required this.banners,
      required this.latestProduct,
      required this.popularProduct});
}
