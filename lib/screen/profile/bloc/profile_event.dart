part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileStarted extends ProfileEvent {
  final TokenResponseEntity? tokenResponse;

  const ProfileStarted(this.tokenResponse);

  @override
  List<Object?> get props => [tokenResponse];
}

class ProfileSignOut extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class ProfileAuthChanged extends ProfileEvent {
  final TokenResponseEntity? tokenResponse;

  const ProfileAuthChanged(this.tokenResponse);

  @override
  List<Object?> get props => [tokenResponse];
}
