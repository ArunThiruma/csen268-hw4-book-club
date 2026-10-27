part of 'home_cubit.dart';

// Each transition creates a fresh object; these states do not use Equatable.
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeBookList extends HomeState {}
