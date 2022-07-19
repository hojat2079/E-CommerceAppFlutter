import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/common/custom_error.dart';
import 'package:ecommerce_app/data/entity/create_order_params_entity.dart';
import 'package:ecommerce_app/data/entity/create_order_result_entity.dart';
import 'package:ecommerce_app/data/repository/order_repository.dart';
import 'package:equatable/equatable.dart';

part 'shipping_event.dart';

part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final OrderRepository orderRepository;

  ShippingBloc(this.orderRepository) : super(ShippingInitial()) {
    on<ShippingEvent>((event, emit) async {
      if (event is ShippingCreateOrder) {
        try {
          emit(ShippingLoading());
          final CreateOrderResultEntity result =
              await orderRepository.submitOrder(event.params);
          emit(ShippingSuccess(result));
        } catch (ex) {
          emit(
            ShippingError(
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
