import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_app/models/failure_model.dart';
import 'package:instagram_app/repositories/auth/auth_repository.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }

  void loginWithCredential() async {
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      _authRepository.loginWithEmailAndPassword(
          email: state.email, password: state.password);
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }
}
