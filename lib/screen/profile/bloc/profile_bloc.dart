import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/data/entity/token_response_entity.dart';
import 'package:ecommerce_app/data/repository/auth_repository.dart';
import 'package:ecommerce_app/data/repository/cart_repository.dart';
import 'package:ecommerce_app/screen/product/bloc/product_bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;

  ProfileBloc(this.authRepository) : super(ProfileGuestState()) {
    on<ProfileEvent>((event, emit) async {
      if (event is ProfileStarted) {
        final TokenResponseEntity? tokenResponse = event.tokenResponse;
        if (tokenResponse == null || tokenResponse.accessToken.isEmpty) {
          emit(ProfileGuestState());
        } else {
          emit(ProfileUserState(event.tokenResponse!.username));
        }
      } else if (event is ProfileAuthChanged) {
        final TokenResponseEntity? tokenResponse = event.tokenResponse;
        if (tokenResponse == null || tokenResponse.accessToken.isEmpty) {
          emit(ProfileGuestState());
        } else {
          if (state is ProfileGuestState) {
            emit(ProfileUserState(event.tokenResponse!.username));
          }
        }
      } else if (event is ProfileSignOut) {
        await authRepository.signOut();
        CartRepositoryImpl.countItemNotifier.value = 0;
        emit(ProfileGuestState());
      }
    });
  }
}
