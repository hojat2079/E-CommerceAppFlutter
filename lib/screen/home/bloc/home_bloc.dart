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

  HomeBloc({required this.productRepository, required this.bannerRepository})
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
        try {
          emit(HomeLoading());
          final banners = await bannerRepository.getAllBanner();
          final popularProducts =
              await productRepository.getAll(sort: SortType.priceHighToLow);
          final latestProducts =
              await productRepository.getAll(sort: SortType.latest);
          emit(HomeSuccess(
              popularProduct: popularProducts,
              latestProduct: latestProducts,
              banners: banners));
        } catch (ex) {
          emit(HomeError(ex is CustomError ? ex : CustomError(errorCode: 500)));
        }
      }
    });
  }
}
