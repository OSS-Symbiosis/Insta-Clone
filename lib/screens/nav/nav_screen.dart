import 'package:flutter/material.dart';

class NavScreen extends StatelessWidget {
  static const String routename = '/nav';
  static Route route() {
    //This will make the screen on the top of splash screen
    return PageRouteBuilder(
      settings: const RouteSettings(name: routename),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => const NavScreen(),
    );
  }

  const NavScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Nav Screen'),
    );
  }
}
