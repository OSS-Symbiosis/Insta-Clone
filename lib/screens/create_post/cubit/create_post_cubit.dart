import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_app/blocs/auth/auth_bloc.dart';
import 'package:instagram_app/models/models.dart';
import 'package:instagram_app/repositories/repositories.dart';
part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;

  CreatePostCubit({
    @required PostRepository postRepository,
    @required StorageRepository storageRepository,
    @required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _authBloc = authBloc,
        super(CreatePostState.initial());

  void postImageChanged(File file) {
    emit(state.copyWith(postImage: file, status: CreatePostStatus.initial));
  }

  void captionChanged(String caption) {
    emit(state.copyWith(caption: caption, status: CreatePostStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      final author = User.empty.copyWith(id: _authBloc.state.user.uid);
      final postImageUrl =
          await _storageRepository.uploadPostImage(image: state.postImage);
      final post = Post(
        author: author,
        imageUrl: postImageUrl,
        caption: state.caption,
        likes: 0,
        date: DateTime.now(),
      );
      await _postRepository.createPost(post: post);
      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (err) {
      emit(
        state.copyWith(
          status: CreatePostStatus.error,
          failure: Failure(message: err.toString()),
        ),
      );
    }
  }

  void reset() {
    emit(CreatePostState.initial());
  }
}
