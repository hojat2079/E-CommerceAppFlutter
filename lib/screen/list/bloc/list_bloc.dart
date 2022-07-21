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

  ListBloc(this.productRepository) : super(ListLoading()) {
    on<ListEvent>((event, emit) async {
      if (event is ListStarted) {
        try {
          emit(ListLoading());
          final product = await productRepository.getAllApi(sort: event.sortType);
          emit(ListSuccess(
              event.sortType, product, sortTypeList(), event.viewType));
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
    });
  }
}
