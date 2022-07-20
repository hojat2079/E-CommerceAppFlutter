import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/common/custom_error.dart';
import 'package:ecommerce_app/data/entity/history_order_entity.dart';
import 'package:ecommerce_app/data/repository/order_repository.dart';
import 'package:equatable/equatable.dart';

part 'order_history_event.dart';

part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderRepository orderRepository;

  OrderHistoryBloc(this.orderRepository) : super(OrderHistoryLoading()) {
    on<OrderHistoryEvent>((event, emit) async {
      if (event is OrderHistoryStarted) {
        try {
          emit(OrderHistoryLoading());
          await Future.delayed(const Duration(seconds: 2));
          final orders = await orderRepository.getHistoryOrder();
          emit(OrderHistorySuccess(orders));
        } catch (ex) {
          emit(OrderHistoryError(
            ex is CustomError
                ? ex
                : CustomError(
                    errorCode:
                        ex is DioError ? ex.response?.statusCode ?? 500 : 500,
                    message: ex is DioError
                        ? ex.response?.data['message'] ??
                            ex.response?.statusMessage ??
                            'خطای نامشخص'
                        : 'خطای نامشخص',
                  ),
          ));
        }
      }
    });
  }
}
