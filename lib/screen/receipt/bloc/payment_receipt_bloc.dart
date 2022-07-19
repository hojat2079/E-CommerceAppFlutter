import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/common/custom_error.dart';
import 'package:ecommerce_app/data/entity/checkout_entity.dart';
import 'package:ecommerce_app/data/repository/order_repository.dart';
import 'package:equatable/equatable.dart';

part 'payment_receipt_event.dart';

part 'payment_receipt_state.dart';

class PaymentReceiptBloc
    extends Bloc<PaymentReceiptEvent, PaymentReceiptState> {
  final OrderRepository orderRepository;

  PaymentReceiptBloc(this.orderRepository) : super(PaymentReceiptLoading()) {
    on<PaymentReceiptEvent>((event, emit) async {
      if (event is PaymentReceiptStarted) {
        try {
          emit(PaymentReceiptLoading());
          final checkout = await orderRepository.checkout(event.orderId);
          emit(PaymentReceiptSuccess(checkout));
        } catch (ex) {
          emit(PaymentReceiptError(
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
          ));
        }
      }
    });
  }
}
