import 'package:flutter/material.dart';
import 'package:instagram_app/screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case SplashScreen.routename:
        return SplashScreen.route();
      case LoginScreen.routename:
        return LoginScreen.route();
      case NavScreen.routename:
        return NavScreen.route();
      case SignupScreen.routename:
        return SignupScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    switch (settings.name) {
      case ProfileScreen.routeName:
        return ProfileScreen.route(args: settings.arguments);
      case EditProfileScreen.routename:
        return EditProfileScreen.route(args: settings.arguments);
      case CommentsScreen.routeName:
        return CommentsScreen.route(args: settings.arguments);
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong'),
        ),
      ),
    );
  }
}
