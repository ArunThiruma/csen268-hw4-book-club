import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../model/book.dart';
import '../../../navigation/router.dart';
import '../../../widgets/book_image.dart';
import '../cubit/home_cubit.dart';

class BookListView extends StatelessWidget {
  const BookListView({super.key, required this.books, required this.sortType});

  final List<Book> books;
  final SortType sortType;

  @override
  Widget build(BuildContext context) {
    final List<Widget> bookWidgets = [];

    for (int index = 0; index < books.length; index++) {
      final Book book = books[index];

      if (index > 0) {
        bookWidgets.add(const SizedBox(width: 10));
      }

      bookWidgets.add(
        Tooltip(
          message: '${book.title} by ${book.author}',
          child: InkWell(
            key: ValueKey('book-${book.title}'),
            onTap: () {
              String detailRoute = RouteName.byAuthorDetail;
              if (sortType == SortType.title) {
                detailRoute = RouteName.byTitleDetail;
              }
              context.goNamed(
                detailRoute,
                queryParameters: {'book': book.title},
              );
            },
            child: BookImage(book: book),
          ),
        ),
      );
    }

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Book Club', style: TextStyle(fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.goNamed(RouteName.home);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.goNamed(RouteName.profile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
                onTap: () {
                  Navigator.of(context).pop();
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationSignOutEvent());
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Book Club Home'),
        centerTitle: true,
        toolbarHeight: 64,
        backgroundColor: const Color(0xFFFEF7FF),
        foregroundColor: const Color(0xFF1D1B20),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: const TextStyle(
          color: Color(0xFF1D1B20),
          fontFamily: 'Roboto',
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
        actions: [
          IconButton(
            key: const Key('profile-button'),
            tooltip: 'Profile',
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              context.goNamed(RouteName.profile);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    const Text(
                      'Sort by',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ChoiceChip(
                      key: const Key('sort-author'),
                      label: const Text('Author'),
                      selected: sortType == SortType.author,
                      showCheckmark: false,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onSelected: (bool selected) {
                        context.goNamed(RouteName.byAuthor);
                      },
                    ),
                    ChoiceChip(
                      key: const Key('sort-title'),
                      label: const Text('Title'),
                      selected: sortType == SortType.title,
                      showCheckmark: false,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onSelected: (bool selected) {
                        context.goNamed(RouteName.byTitle);
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Books',
                  style: TextStyle(fontSize: 28, height: 36 / 28),
                ),
              ),
              // Allow dragging the shelf with a mouse or touch input.
              ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.stylus,
                    PointerDeviceKind.invertedStylus,
                    PointerDeviceKind.trackpad,
                  },
                  scrollbars: false,
                ),
                child: SingleChildScrollView(
                  key: const Key('book-shelf'),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: bookWidgets),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
