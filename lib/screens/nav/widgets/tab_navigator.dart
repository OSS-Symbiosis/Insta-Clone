import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/blocs/auth/auth_bloc.dart';
import 'package:instagram_app/config/custom_router.dart';
import 'package:instagram_app/cubits/cubits.dart';
import 'package:instagram_app/enums/bottom_nav_item.dart';
import 'package:instagram_app/repositories/notifications/notifications_repository.dart';
import 'package:instagram_app/repositories/repositories.dart';
import 'package:instagram_app/screens/create_post/cubit/create_post_cubit.dart';
import 'package:instagram_app/screens/feed/bloc/feed_bloc.dart';
import 'package:instagram_app/screens/notifications/bloc/notifications_bloc.dart';
import 'package:instagram_app/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_app/screens/screens.dart';
import 'package:instagram_app/screens/search/cubit/search_cubit.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  TabNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilder();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: const RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute](context),
          ),
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilder() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return BlocProvider<FeedBloc>(
          create: (context) => FeedBloc(
            postRepository: context.read<PostRepository>(),
            authBloc: context.read<AuthBloc>(),
            likedPostsCubit: context.read<LikedPostsCubit>(),
          )..add(FeedFetchPosts()),
          child: const FeedScreen(),
        );
      case BottomNavItem.search:
        return BlocProvider<SearchCubit>(
          create: (context) =>
              SearchCubit(userRepository: context.read<UserRepository>()),
          child: const SearchScreen(),
        );
      case BottomNavItem.create:
        return BlocProvider<CreatePostCubit>(
          create: (context) => CreatePostCubit(
            postRepository: context.read<PostRepository>(),
            storageRepository: context.read<StorageRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
          child: CreatePostScreen(),
        );
      case BottomNavItem.notifications:
        return BlocProvider<NotificationsBloc>(
          create: (context) => NotificationsBloc(
            notificationRepository: context.read<NotificationRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
          child: NotificationsScreen(),
        );
      case BottomNavItem.profile:
        return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
            authBloc: context.read<AuthBloc>(),
            likedPostsCubit: context.read<LikedPostsCubit>(),
          )..add(
              ProfileLoadUser(userId: context.read<AuthBloc>().state.user.uid)),
          child: const ProfileScreen(),
        );
      default:
        return const Scaffold();
    }
  }
}
