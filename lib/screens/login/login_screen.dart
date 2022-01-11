import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/repositories/repositories.dart';
import 'package:instagram_app/screens/login/cubit/login_cubit.dart';
import 'package:instagram_app/screens/signup/signup_screen.dart';
import 'package:instagram_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routename = '/login';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Route route() {
    //This will make the screen on the top of splash screen
    return PageRouteBuilder(
      settings: const RouteSettings(name: routename),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        child: LoginScreen(),
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
      ),
    );
  }

  LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: (context),
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) => Scaffold(
            resizeToAvoidBottomInset:
                false, //this will prevent the form to resize when the height changes due to keyboard
            //But due this keyboard won't go down when we tap on screen so use gesture detector
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Instagram',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(hintText: 'Email'),
                            onChanged: (value) =>
                                context.read<LoginCubit>().emailChanged(value),
                            validator: (value) => !value.contains('@')
                                ? 'Please Enter a valid email'
                                : null,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(hintText: 'Password'),
                            obscureText: true,
                            onChanged: (value) => context
                                .read<LoginCubit>()
                                .passwordChanged(value),
                            validator: (value) => value.length < 6
                                ? 'Must Be atleast 6 characters'
                                : null,
                          ),
                          const SizedBox(
                            height: 28.0,
                          ),
                          FlatButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () => _submitForm(context,
                                state.status == LoginStatus.submitting),
                            child: const Text('Log In'),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          RaisedButton(
                            elevation: 1.0,
                            color: Colors.grey[200],
                            textColor: Colors.black,
                            onPressed: () => Navigator.of(context)
                                .pushNamed(SignupScreen.routename),
                            child: const Text('No account ? Sign up'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate()) {
      context.read<LoginCubit>().loginWithCredential();
    }
  }
}
