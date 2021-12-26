import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/blocs/blocs.dart';
import 'package:instagram_app/cubits/cubits.dart';
import 'package:instagram_app/repositories/repositories.dart';
import 'package:instagram_app/screens/profile/widgets/widgets.dart';
import 'package:instagram_app/screens/screens.dart';
import 'package:instagram_app/widgets/widgets.dart';
import 'bloc/profile_bloc.dart';

class ProfileScreenArgs {
  final String userId;
  const ProfileScreenArgs({@required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  static Route route({@required ProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
          likedPostsCubit: context.read<LikedPostsCubit>(),
        )..add(
            ProfileLoadUser(userId: args.userId),
          ),
        child: const ProfileScreen(),
      ),
    );
  }

  const ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: (context),
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return state.user == null
            ? const CircularProgressIndicator()
            : Scaffold(
                appBar: AppBar(
                  title: Text(
                    state.user.username,
                    style: const TextStyle(color: Colors.black),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                        context.read<LikedPostsCubit>().clearAllLikedPosts();
                      },
                      icon: const Icon(Icons.exit_to_app),
                    ),
                  ],
                ),
                body: _buildBody(state),
              );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    switch (state.status) {
      case ProfileStatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<ProfileBloc>()
                .add(ProfileLoadUser(userId: state.user.id));
            return true;
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0),
                      child: Row(
                        children: [
                          UserProfileImage(
                            radius: 40.0,
                            profileImageUrl: state.user.profileImageUrl,
                          ),
                          ProfileStats(
                            isCurrentUser: state.isCurrentUser,
                            isFollowing: state.isFollowing,
                            posts: state.posts.length,
                            followers: state.user.followers,
                            following: state.user.following,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10.0),
                      child: ProfileInfo(
                        username: state.user.username,
                        bio: state.user.bio,
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.grid_on, size: 28.0),
                    ),
                    Tab(
                      icon: Icon(Icons.list, size: 28.0),
                    )
                  ],
                  indicatorWeight: 3.0,
                  onTap: (i) => context
                      .read<ProfileBloc>()
                      .add(ProfileToggleGridView(isGridView: i == 0)),
                ),
              ),
              state.isGridView
                  ? SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final post = state.posts[index];
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                            CommentsScreen.routeName,
                            arguments: CommentsScreenArgs(post: post),
                          ),
                          child: Image(
                            image: NetworkImage(post.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        );
                      }, childCount: state.posts.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = state.posts[index];
                          final likedPostsState =
                              context.watch<LikedPostsCubit>().state;
                          final isLiked =
                              likedPostsState.likedPostIds.contains(post.id);
                          final recentlyLiked = likedPostsState
                              .recentlyLikedPostIds
                              .contains(post.id);
                          return PostView(
                            post: post,
                            isLiked: isLiked,
                            recentlyLiked: recentlyLiked,
                            onLike: () {
                              if (isLiked) {
                                context
                                    .read<LikedPostsCubit>()
                                    .unlikedPost(post: post);
                              } else {
                                context
                                    .read<LikedPostsCubit>()
                                    .likedPost(post: post);
                              }
                            },
                          );
                        },
                        childCount: state.posts.length,
                      ),
                    ),
            ],
          ),
        );
    }
  }
}
