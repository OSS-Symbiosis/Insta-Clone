import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/blocs/blocs.dart';
import 'package:instagram_app/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  static const String routename = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routename),
      builder: (_) => const SplashScreen(),
    );
  }

  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This will not allow the user to back,
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        //To prevent bloc from updating when the state don't change
        listenWhen: (prevState, state) => prevState.status != state.status,
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            //Go to login screen
            Navigator.of(context).pushNamed(LoginScreen.routename);
          } else if (state.status == AuthStatus.authenticated) {
            //Go to navigation screen
            Navigator.of(context).pushNamed(NavScreen.routename);
          }
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
