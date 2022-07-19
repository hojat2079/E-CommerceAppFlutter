part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final bool isLoginMode;
  const AuthState({required this.isLoginMode});

  @override
  List<Object> get props => [isLoginMode];
}

class AuthInitialState extends AuthState {
  const AuthInitialState(bool isLoginMode) : super(isLoginMode: isLoginMode);
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState(bool isLoginMode) : super(isLoginMode: isLoginMode);
}

class AuthSuccessState extends AuthState {
  const AuthSuccessState(bool isLoginMode) : super(isLoginMode: isLoginMode);
}

class AuthErrorState extends AuthState {
  final CustomError error;

  const AuthErrorState(bool isLoginMode, this.error)
      : super(isLoginMode: isLoginMode);
}
