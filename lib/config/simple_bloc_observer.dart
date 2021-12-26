import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  //When event is added to a bloc
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
  }

//When there is a change in state
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

//Whenever there is an error
  @override
  Future<void> onError(Cubit cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
  }
}
