import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'navigation/router.dart';
import 'utilities/stream_to_listenable.dart';

void main() {
  runApp(const BookClubApp());
}

class BookClubApp extends StatelessWidget {
  const BookClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(),
      child: const _BookClubRouterApp(),
    );
  }
}

class _BookClubRouterApp extends StatefulWidget {
  const _BookClubRouterApp();

  @override
  State<_BookClubRouterApp> createState() => _BookClubRouterAppState();
}

class _BookClubRouterAppState extends State<_BookClubRouterApp> {
  late final StreamToListenable authenticationListenable;
  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    authenticationListenable = StreamToListenable([authenticationBloc.stream]);
    router = createRouter(authenticationBloc, authenticationListenable);
  }

  @override
  void dispose() {
    router.dispose();
    authenticationListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Book Club',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: const Color(0xFFE8E1EB),
          side: const BorderSide(color: Color(0xFFCAC4D0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          labelStyle: const TextStyle(
            color: Color(0xFF49454F),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
      routerConfig: router,
    );
  }
}
