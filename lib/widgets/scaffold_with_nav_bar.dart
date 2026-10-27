import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    int selectedIndex = 0;
    if (location.startsWith('/byTitle')) {
      selectedIndex = 1;
    } else if (location.startsWith('/profile')) {
      selectedIndex = 2;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search),
            label: 'By author',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'By title',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 0) {
            context.goNamed(RouteName.byAuthor);
          } else if (index == 1) {
            context.goNamed(RouteName.byTitle);
          } else {
            context.goNamed(RouteName.profile);
          }
        },
      ),
    );
  }
}
