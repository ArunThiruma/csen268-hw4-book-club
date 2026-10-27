part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {}

class AuthenticationLoginEvent extends AuthenticationEvent {}

class AuthenticationSignOutEvent extends AuthenticationEvent {}
