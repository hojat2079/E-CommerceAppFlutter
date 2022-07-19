part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileGuestState extends ProfileState {}

class ProfileUserState extends ProfileState {
  final String username;

  const ProfileUserState(this.username);
  @override
  List<Object> get props => [username];
}
