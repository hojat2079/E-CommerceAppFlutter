import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/common/custom_error.dart';
import 'package:ecommerce_app/data/repository/auth_repository.dart';
import 'package:ecommerce_app/data/repository/cart_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final CartRepository cartRepository;
  bool isLoginMode;

  AuthBloc(this.authRepository, this.cartRepository, {this.isLoginMode = true})
      : super(AuthInitialState(isLoginMode)) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthStartedEvent) {
        } else if (event is AuthButtonIsClickedEvent) {
          emit(AuthLoadingState(isLoginMode));
          if (isLoginMode) {
            await authRepository.login(event.username, event.password);
            await cartRepository.getAllCountItem();
            emit(AuthSuccessState(isLoginMode));
          } else {
            await authRepository.register(event.username, event.password);
            // await cartRepository.getAllCountItem();
            emit(AuthSuccessState(isLoginMode));
          }
        } else if (event is AuthModeChangedIsClickedEvent) {
          isLoginMode = !isLoginMode;
          emit(AuthInitialState(isLoginMode));
        } else {
          throw CustomError(errorCode: 500, message: 'event is not valid!');
        }
      } catch (e) {
        emit(AuthErrorState(
          isLoginMode,
          e is CustomError
              ? e
              : e is DioError
                  ? CustomError(
                      errorCode: 500,
                      message:
                          (e.response!.data as Map<String, dynamic>)['message'])
                  : CustomError(errorCode: 500),
        ));
      }
    });
  }
}
