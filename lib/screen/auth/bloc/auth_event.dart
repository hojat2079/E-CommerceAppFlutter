part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStartedEvent extends AuthEvent {}

class AuthButtonIsClickedEvent extends AuthEvent {
  final String username;
  final String password;

  const AuthButtonIsClickedEvent(this.username, this.password);
}

class AuthModeChangedIsClickedEvent extends AuthEvent {}
