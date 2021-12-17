import 'dart:async';

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
  final PostRepository _postRepository;
  StreamSubscription<List<Future<Post>>> _postSubscription;

  ProfileBloc(
      {@required UserRepository userRepository,
      @required AuthBloc authBloc,
      @required PostRepository postRepository})
      : _userRepository = userRepository,
        _authBloc = authBloc,
        _postRepository = postRepository,
        super(ProfileState.initial());

  @override
  Future<void> close() {
    _postSubscription.cancel();
    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    {
      if (event is ProfileLoadUser) {
        yield* _mapProfileLoadedUserToState(event);
      } else if (event is ProfileToggleGridView) {
        yield* _mapProfileToggleGridViewToState(event);
      } else if (event is ProfileUpdatePosts) {
        yield* _mapProfileUpdatePostsToState(event);
      }
    }
  }

  Stream<ProfileState> _mapProfileLoadedUserToState(
      ProfileLoadUser event) async* {
    yield state.copyWith(status: ProfileStatus.loading);
    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
      final isCurrentUser = _authBloc.state.user.uid == user.id;

      _postSubscription?.cancel();
      _postSubscription = _postRepository
          .getUserPosts(userId: event.userId)
          .listen((posts) async {
        final allPosts = await Future.wait(posts);
        add(ProfileUpdatePosts(posts: allPosts));
      });

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

  Stream<ProfileState> _mapProfileToggleGridViewToState(
      ProfileToggleGridView event) async* {
    yield state.copyWith(isGridView: event.isGridView);
  }

  Stream<ProfileState> _mapProfileUpdatePostsToState(
      ProfileUpdatePosts event) async* {
    yield state.copyWith(posts: event.posts);
  }
}
