import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationLoginEvent>((event, emit) {
      emit(AuthenticationAuthenticated());
    });

    on<AuthenticationSignOutEvent>((event, emit) {
      emit(AuthenticationInitial());
    });
  }
}
