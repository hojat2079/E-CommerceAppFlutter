import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/common/custom_error.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/entity/sort_type.dart';
import 'package:ecommerce_app/data/entity/view_type.dart';
import 'package:ecommerce_app/data/repository/product_repository.dart';
import 'package:equatable/equatable.dart';

part 'list_event.dart';

part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final ProductRepository productRepository;
  late List<ProductEntity> products;
  late SortType sortType;
  late ViewType viewType;

  ListBloc(this.productRepository) : super(ListLoading()) {
    on<ListEvent>((event, emit) async {
      if (event is ListStarted) {
        try {
          emit(ListLoading());
          sortType = event.sortType;
          viewType = event.viewType;
          products = await productRepository.getAllApi(sort: sortType);
          final favorites = await productRepository.getAllDatabase();
          emit(ListSuccess(
            sortType,
            products,
            sortTypeList(),
            viewType,
            favorites.map((e) => e.id).toList(),
          ));
        } catch (ex) {
          emit(
            ListError(
              ex is CustomError
                  ? ex
                  : CustomError(
                      errorCode:
                          ex is DioError ? ex.response?.statusCode ?? 500 : 500,
                      message: ex is DioError
                          ? ex.response?.data['message'] ??
                              ex.response?.statusMessage ??
                              'خطای نامشخص'
                          : 'خطای نامشخص'),
            ),
          );
        }
      }
      if (event is ListClickLikeButton) {
        try {
          if (productRepository.isExist(event.product)) {
            productRepository.delete(event.product);
          } else {
            productRepository.createOrUpdate(event.product);
          }
          final favorites = await productRepository.getAllDatabase();
          emit(ListSuccess(
            sortType,
            products,
            sortTypeList(),
            viewType,
            favorites.map((e) => e.id).toList(),
          ));
        } catch (ex) {
          emit(ListError(ex is CustomError ? ex : CustomError(errorCode: 500)));
        }
      }
    });
  }
}
