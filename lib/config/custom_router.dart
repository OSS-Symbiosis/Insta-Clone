import 'package:flutter/material.dart';
import 'package:instagram_app/screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print(settings.name);
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
