import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_app/blocs/blocs.dart';
import 'package:instagram_app/models/models.dart';
import 'package:instagram_app/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;

  ProfileBloc(
      {@required UserRepository userRepository, @required AuthBloc authBloc})
      : _userRepository = userRepository,
        _authBloc = authBloc,
        super(ProfileState.intiial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    {
      if (event is ProfileLoadUser) {
        yield* _mapProfileLoadedUserToState(event);
      }
    }
  }

  Stream<ProfileState> _mapProfileLoadedUserToState(
      ProfileLoadUser event) async* {
    yield state.copyWith(status: ProfileStatus.loading);
    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
      final isCurrentUser = _authBloc.state.user.uid == user.id;
      yield state.copyWith(
        user: user,
        isCurrentUser: isCurrentUser,
        status: ProfileStatus.loaded,
      );
    } catch (err) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: const Failure(message: 'We were unable to load the profile'),
      );
    }
  }
}
