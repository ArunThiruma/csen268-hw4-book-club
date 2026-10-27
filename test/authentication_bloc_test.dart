import 'package:flutter_test/flutter_test.dart';
import 'package:hw3_book_club/blocs/authentication/authentication_bloc.dart';

void main() {
  late AuthenticationBloc bloc;

  setUp(() {
    bloc = AuthenticationBloc();
  });

  tearDown(() async {
    await bloc.close();
  });

  test('authentication starts logged out', () {
    expect(bloc.state, isA<AuthenticationInitial>());
  });

  test('a login event authenticates the demo account', () async {
    final result = expectLater(
      bloc.stream,
      emits(isA<AuthenticationAuthenticated>()),
    );
    bloc.add(AuthenticationLoginEvent());
    await result;
    expect(bloc.state, isA<AuthenticationAuthenticated>());
  });

  test('logout clears authentication and the user can log in again', () async {
    final result = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<AuthenticationAuthenticated>(),
        isA<AuthenticationInitial>(),
        isA<AuthenticationAuthenticated>(),
      ]),
    );
    bloc.add(AuthenticationLoginEvent());
    bloc.add(AuthenticationSignOutEvent());
    bloc.add(AuthenticationLoginEvent());
    await result;
  });
}
