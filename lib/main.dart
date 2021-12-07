import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/blocs/simple_bloc_observer.dart';
import 'package:instagram_app/config/custom_router.dart';
import 'package:instagram_app/repositories/auth/auth_repository.dart';
import 'package:instagram_app/screens/screens.dart';
import 'blocs/auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  EquatableConfig.stringify = kDebugMode;
  //this is a strigify which is set to true whenver we debug and otherwise false
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Instagram',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[50],
            appBarTheme: const AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              textTheme: TextTheme(
                headline6: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
          ),
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: SplashScreen.routename,
        ),
      ),
    );
  }
}
