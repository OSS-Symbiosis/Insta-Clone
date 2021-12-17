part of 'profile_bloc.dart';

enum ProfileStatus { intital, loading, loaded, error }

class ProfileState extends Equatable {
  final User user;
  final List<Post> posts;
  final bool isCurrentUser;
  final bool isGridView;
  final bool isFollowing;
  final ProfileStatus status;
  final Failure failure;

  const ProfileState({
    @required this.user,
    @required this.posts,
    @required this.isCurrentUser,
    @required this.isGridView,
    @required this.isFollowing,
    @required this.status,
    @required this.failure,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      user: User.empty,
      isCurrentUser: false,
      posts: [],
      isGridView: true,
      isFollowing: false,
      status: ProfileStatus.intital,
      failure: Failure(),
    );
  }

  ProfileState copyWith({
    User user,
    bool isCurrentUser,
    List<Post> posts,
    bool isGridView,
    bool isFollowing,
    ProfileStatus status,
    Failure failure,
  }) {
    return ProfileState(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isGridView: isGridView ?? this.isGridView,
      isFollowing: isFollowing ?? this.isFollowing,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object> get props =>
      [user, isCurrentUser, isGridView, isFollowing, status, failure, posts];
}
