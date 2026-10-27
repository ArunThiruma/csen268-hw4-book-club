import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hw3_book_club/blocs/authentication/authentication_bloc.dart';
import 'package:hw3_book_club/data/sample_books.dart';
import 'package:hw3_book_club/main.dart';
import 'package:hw3_book_club/navigation/router.dart';
import 'package:hw3_book_club/pages/login/login_page.dart';
import 'package:hw3_book_club/utilities/stream_to_listenable.dart';
import 'package:hw3_book_club/widgets/book_details.dart';
import 'package:hw3_book_club/widgets/book_image.dart';

Future<GoRouter> openApp(WidgetTester tester, {bool login = true}) async {
  await tester.pumpWidget(const BookClubApp());
  await tester.pumpAndSettle();
  final router = GoRouter.of(tester.element(find.byType(LoginPage)));
  if (login) {
    await tester.tap(find.byKey(const Key('login-button')));
    await tester.pumpAndSettle();
  }
  return router;
}

String currentPath(GoRouter router) {
  return router.routeInformationProvider.value.uri.path;
}

void main() {
  test('all seven route names have the required paths', () async {
    final bloc = AuthenticationBloc();
    final listenable = StreamToListenable([bloc.stream]);
    final router = createRouter(bloc, listenable);
    final paths = {
      RouteName.home: '/',
      RouteName.byAuthor: '/byAuthor',
      RouteName.byAuthorDetail: '/byAuthor/detail',
      RouteName.byTitle: '/byTitle',
      RouteName.byTitleDetail: '/byTitle/detail',
      RouteName.profile: '/profile',
      RouteName.login: '/login',
    };
    for (final entry in paths.entries) {
      expect(router.namedLocation(entry.key), entry.value);
    }
    router.dispose();
    listenable.dispose();
    await bloc.close();
  });

  testWidgets(
    'protected paths redirect to login and login refreshes the router',
    (tester) async {
      final router = await openApp(tester, login: false);
      expect(currentPath(router), '/login');
      for (final path in [
        '/',
        '/byAuthor',
        '/byAuthor/detail?book=Memory',
        '/byTitle',
        '/byTitle/detail?book=Memory',
        '/profile',
        '/unknown',
        '/login/unexpected',
      ]) {
        router.go(path);
        await tester.pumpAndSettle();
        expect(currentPath(router), '/login');
        expect(find.byKey(const Key('login-button')), findsOneWidget);
        expect(find.byType(BookImage), findsNothing);
      }

      await tester.tap(find.byKey(const Key('login-button')));
      await tester.pumpAndSettle();
      expect(currentPath(router), '/byAuthor');
      expect(find.byType(BookImage), findsNWidgets(7));

      router.go('/login?source=profile');
      await tester.pumpAndSettle();
      expect(currentPath(router), '/byAuthor');
      expect(find.byType(LoginPage), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('profile icon, shell tabs, and logout work', (tester) async {
    final router = await openApp(tester);
    await tester.tap(find.byKey(const Key('profile-button')));
    await tester.pumpAndSettle();
    expect(currentPath(router), '/profile');
    expect(find.text('Book Club Member'), findsOneWidget);
    expect(
      tester
          .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
          .currentIndex,
      2,
    );

    await tester.tap(find.text('By title'));
    await tester.pumpAndSettle();
    expect(currentPath(router), '/byTitle');
    expect(
      tester.widget<ChoiceChip>(find.byKey(const Key('sort-title'))).selected,
      isTrue,
    );
    expect(
      tester
          .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
          .currentIndex,
      1,
    );

    await tester.tap(find.text('By author'));
    await tester.pumpAndSettle();
    expect(currentPath(router), '/byAuthor');
    expect(
      tester.widget<ChoiceChip>(find.byKey(const Key('sort-author'))).selected,
      isTrue,
    );

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('logout-button')));
    await tester.pumpAndSettle();
    expect(currentPath(router), '/login');
    expect(find.byType(BottomNavigationBar), findsNothing);
    expect(router.canPop(), isFalse);

    router.go('/profile');
    await tester.pumpAndSettle();
    expect(currentPath(router), '/login');
    await tester.tap(find.byKey(const Key('login-button')));
    await tester.pumpAndSettle();
    expect(currentPath(router), '/byAuthor');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'both detail routes resolve all seven books and preserve sort on back',
    (tester) async {
      final router = await openApp(tester);
      for (final detailRoute in [
        RouteName.byAuthorDetail,
        RouteName.byTitleDetail,
      ]) {
        final String listPath = detailRoute == RouteName.byAuthorDetail
            ? '/byAuthor'
            : '/byTitle';
        for (final book in sampleBooks) {
          router.goNamed(detailRoute, queryParameters: {'book': book.title});
          await tester.pumpAndSettle();
          expect(currentPath(router), '$listPath/detail');
          expect(
            tester.widget<BookDetails>(find.byType(BookDetails)).book,
            same(book),
          );
          expect(find.byType(BottomNavigationBar), findsNothing);

          await tester.tap(find.byKey(const Key('back-to-books')));
          await tester.pumpAndSettle();
          expect(currentPath(router), listPath);
          final chipKey = listPath == '/byAuthor'
              ? 'sort-author'
              : 'sort-title';
          expect(
            tester.widget<ChoiceChip>(find.byKey(Key(chipKey))).selected,
            isTrue,
          );
        }
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('system back returns from detail to the matching list', (
    tester,
  ) async {
    final router = await openApp(tester);
    await tester.tap(find.byKey(const Key('sort-title')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('book-A Clockwork Orange')));
    await tester.pumpAndSettle();
    expect(currentPath(router), '/byTitle/detail');
    expect(
      router.routeInformationProvider.value.uri.queryParameters['book'],
      'A Clockwork Orange',
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(currentPath(router), '/byTitle');
    expect(
      tester.widget<ChoiceChip>(find.byKey(const Key('sort-title'))).selected,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('missing books and unknown routes have a working way back', (
    tester,
  ) async {
    final router = await openApp(tester);
    for (final path in ['/byAuthor/detail', '/byTitle/detail?book=Unknown']) {
      router.go(path);
      await tester.pumpAndSettle();
      expect(
        find.text('Book not found. Use the back arrow to return.'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('back-to-books')));
      await tester.pumpAndSettle();
      expect(
        currentPath(router),
        path.startsWith('/byTitle') ? '/byTitle' : '/byAuthor',
      );
    }

    router.go('/unknown');
    await tester.pumpAndSettle();
    expect(find.text('Page not found'), findsOneWidget);
    await tester.tap(find.text('Back to books'));
    await tester.pumpAndSettle();
    expect(currentPath(router), '/');
    expect(find.byType(BookImage), findsNWidgets(7));

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(currentPath(router), '/login');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'an authenticated direct detail link builds the parent list for back',
    (tester) async {
      final bloc = AuthenticationBloc();
      bloc.add(AuthenticationLoginEvent());
      await tester.pump();
      expect(bloc.state, isA<AuthenticationAuthenticated>());
      final listenable = StreamToListenable([bloc.stream]);
      final router = createRouter(
        bloc,
        listenable,
        initialLocation: '/byTitle/detail?book=Carmer%20and%20Grit',
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();
      expect(currentPath(router), '/byTitle/detail');
      expect(
        tester.widget<BookDetails>(find.byType(BookDetails)).book.title,
        'Carmer and Grit',
      );
      await tester.tap(find.byKey(const Key('back-to-books')));
      await tester.pumpAndSettle();
      expect(currentPath(router), '/byTitle');
      expect(
        tester.widget<BookImage>(find.byType(BookImage).first).book.title,
        'A Clockwork Orange',
      );

      router.goNamed(
        RouteName.byAuthorDetail,
        queryParameters: {'book': 'Memory'},
      );
      await tester.pumpAndSettle();
      bloc.add(AuthenticationSignOutEvent());
      await tester.pumpAndSettle();
      expect(currentPath(router), '/login');
      expect(find.byType(BookDetails), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      router.dispose();
      listenable.dispose();
      await tester.runAsync(bloc.close);
      expect(tester.takeException(), isNull);
    },
  );
}
