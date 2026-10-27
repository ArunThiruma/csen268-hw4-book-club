import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../data/sample_books.dart';
import '../model/book.dart';
import '../pages/home/cubit/home_cubit.dart';
import '../pages/home/home_page.dart';
import '../pages/home/views/book_detail_view.dart';
import '../pages/login/login_page.dart';
import '../pages/profile/profile_page.dart';
import '../widgets/scaffold_with_nav_bar.dart';

class RouteName {
  static const home = 'home';
  static const byAuthor = 'byAuthor';
  static const byAuthorDetail = 'byAuthorDetail';
  static const byTitle = 'byTitle';
  static const byTitleDetail = 'byTitleDetail';
  static const profile = 'profile';
  static const login = 'login';
}

GoRouter createRouter(
  AuthenticationBloc authenticationBloc,
  Listenable refreshListenable, {
  String? initialLocation,
}) {
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root');
  final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Shell');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final bool loggedIn =
          authenticationBloc.state is AuthenticationAuthenticated;
      final bool goingToLogin = state.uri.path == '/login';

      if (!loggedIn && !goingToLogin) {
        return '/login';
      }
      if (loggedIn && goingToLogin) {
        return '/byAuthor';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: RouteName.login,
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/',
        name: RouteName.home,
        builder: (context, state) {
          return const HomePage(sortType: SortType.author);
        },
        routes: [
          ShellRoute(
            navigatorKey: shellNavigatorKey,
            builder: (context, state, child) {
              return ScaffoldWithNavBar(child: child);
            },
            routes: [
              GoRoute(
                path: 'byAuthor',
                name: RouteName.byAuthor,
                builder: (context, state) {
                  return const HomePage(sortType: SortType.author);
                },
                routes: [
                  GoRoute(
                    path: 'detail',
                    name: RouteName.byAuthorDetail,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      return BookDetailView(
                        book: _findBook(state.uri.queryParameters['book']),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'byTitle',
                name: RouteName.byTitle,
                builder: (context, state) {
                  return const HomePage(sortType: SortType.title);
                },
                routes: [
                  GoRoute(
                    path: 'detail',
                    name: RouteName.byTitleDetail,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      return BookDetailView(
                        book: _findBook(state.uri.queryParameters['book']),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'profile',
                name: RouteName.profile,
                builder: (context, state) {
                  return const ProfilePage();
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Club')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Page not found'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  context.goNamed(RouteName.home);
                },
                child: const Text('Back to books'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Book? _findBook(String? title) {
  for (final book in sampleBooks) {
    if (book.title == title) {
      return book;
    }
  }
  return null;
}
