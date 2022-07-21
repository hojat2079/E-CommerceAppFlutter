import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/common/custom_error.dart';
import 'package:ecommerce_app/data/entity/banner_entity.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/entity/sort_type.dart';
import 'package:ecommerce_app/data/repository/banner_repository.dart';
import 'package:ecommerce_app/data/repository/product_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository productRepository;
  final BannerRepository bannerRepository;
  late List<BannerEntity> banners;
  late List<ProductEntity> latestProducts;
  late List<ProductEntity> popularProducts;

  HomeBloc({required this.productRepository, required this.bannerRepository})
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
        try {
          emit(HomeLoading());
          banners = await bannerRepository.getAllBanner();
          popularProducts =
              await productRepository.getAllApi(sort: SortType.priceHighToLow);
          latestProducts =
              await productRepository.getAllApi(sort: SortType.latest);
          final favoriteProducts = await productRepository.getAllDatabase();
          emit(HomeSuccess(
            popularProduct: popularProducts,
            latestProduct: latestProducts,
            banners: banners,
            favoriteList: favoriteProducts,
          ));
        } catch (ex) {
          emit(HomeError(ex is CustomError ? ex : CustomError(errorCode: 500)));
        }
      } else if (event is HomeClickLikeButton) {
        if (productRepository.isExist(event.product)) {
          productRepository.delete(event.product);
        } else {
          productRepository.createOrUpdate(event.product);
        }
        final favoriteProducts = await productRepository.getAllDatabase();
        emit(HomeSuccess(
          popularProduct: popularProducts,
          latestProduct: latestProducts,
          banners: banners,
          favoriteList: favoriteProducts,
        ));
      }
    });
  }
}
