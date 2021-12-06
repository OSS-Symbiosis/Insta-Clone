import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/repositories/repositories.dart';
import 'cubit/signup_cubit.dart';

class SignupScreen extends StatelessWidget {
  static const String routename = '/signup';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routename),
      builder: (context) => BlocProvider<SignupCubit>(
        child: SignupScreen(),
        create: (_) =>
            SignupCubit(authRepository: context.read<AuthRepository>()),
      ),
    );
  }

  SignupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                context: (context),
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.failure.message),
                ),
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
                                const InputDecoration(hintText: 'Username'),
                            onChanged: (value) => context
                                .read<SignupCubit>()
                                .usernameChanged(value),
                            validator: (value) => value.trim().isEmpty
                                ? 'Please Enter a username'
                                : null,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(hintText: 'Email'),
                            onChanged: (value) =>
                                context.read<SignupCubit>().emailChanged(value),
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
                                .read<SignupCubit>()
                                .passwordChanged(value),
                            validator: (value) => value.length < 6
                                ? 'Must Be atleast 6 characters'
                                : null,
                          ),
                          const SizedBox(
                            height: 28.0,
                          ),
                          RaisedButton(
                            elevation: 1.0,
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () => _submitForm(context,
                                state.status == SignupStatus.submitting),
                            child: const Text('Sign Up'),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          RaisedButton(
                            elevation: 1.0,
                            color: Colors.grey[200],
                            textColor: Colors.black,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Back to Login'),
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
      context.read<SignupCubit>().signupWithCredential();
    }
  }
}
