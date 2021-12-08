part of 'profile_bloc.dart';

enum ProfileStatus { intital, loading, loaded, error }

class ProfileState extends Equatable {
  final User user;
  //final List<Post> post
  final bool isCurrentUser;
  final bool isGridView;
  final bool isFollowing;
  final ProfileStatus status;
  final Failure failure;

  const ProfileState({
    @required this.user,
    @required this.isCurrentUser,
    @required this.isGridView,
    @required this.isFollowing,
    @required this.status,
    @required this.failure,
  });

  factory ProfileState.intiial() {
    return const ProfileState(
      user: User.empty,
      isCurrentUser: false,
      isGridView: true,
      isFollowing: false,
      status: ProfileStatus.intital,
      failure: Failure(),
    );
  }

  ProfileState copyWith({
    User user,
    bool isCurrentUser,
    bool isGridView,
    bool isFollowing,
    ProfileStatus status,
    Failure failure,
  }) {
    return ProfileState(
      user: user,
      isCurrentUser: isCurrentUser,
      isGridView: isGridView,
      isFollowing: isFollowing,
      status: status,
      failure: failure,
    );
  }

  @override
  List<Object> get props =>
      [isCurrentUser, isGridView, isFollowing, status, failure];
}
