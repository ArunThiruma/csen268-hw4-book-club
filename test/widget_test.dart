import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hw3_book_club/main.dart';
import 'package:hw3_book_club/widgets/book_details.dart';
import 'package:hw3_book_club/widgets/book_image.dart';

void main() {
  testWidgets('sort chips, book selection, and AppBar back work together', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BookClubApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('login-button')));
    await tester.pumpAndSettle();

    List<String> shelfTitles() => tester
        .widgetList<BookImage>(find.byType(BookImage))
        .map((image) => image.book.title)
        .toList();

    expect(find.text('Book Club Home'), findsOneWidget);
    expect(shelfTitles().first, 'Memory');
    expect(
      tester.widget<ChoiceChip>(find.byKey(const Key('sort-author'))).selected,
      isTrue,
    );

    await tester.tap(find.byKey(const Key('sort-title')));
    await tester.pumpAndSettle();
    expect(shelfTitles(), [
      'A Clockwork Orange',
      'Carmer and Grit',
      "Don't Look Back",
      'James and the Giant Peach',
      'Little Gods',
      'Memory',
      'The Big Deal',
    ]);

    // Repeat the same sort choice to exercise the repeated-state case.
    await tester.tap(find.byKey(const Key('sort-title')));
    await tester.pumpAndSettle();
    expect(shelfTitles().first, 'A Clockwork Orange');

    await tester.tap(find.byKey(const ValueKey('book-A Clockwork Orange')));
    await tester.pumpAndSettle();
    expect(find.text('Book Detail'), findsOneWidget);
    expect(find.text('A Clockwork Orange'), findsOneWidget);
    expect(find.text('Anthony Burgess'), findsOneWidget);
    final details = tester.widget<BookDetails>(find.byType(BookDetails));
    expect(find.text(details.book.description), findsOneWidget);
    expect(find.byType(BookImage), findsOneWidget);

    await tester.tap(find.byKey(const Key('back-to-books')));
    await tester.pumpAndSettle();
    expect(find.text('Book Club Home'), findsOneWidget);
    expect(shelfTitles().first, 'A Clockwork Orange');
    expect(
      tester.widget<ChoiceChip>(find.byKey(const Key('sort-title'))).selected,
      isTrue,
    );

    await tester.tap(find.byKey(const Key('sort-author')));
    await tester.pumpAndSettle();
    expect(shelfTitles().first, 'Memory');

    await tester.tap(find.byKey(const Key('sort-author')));
    await tester.pumpAndSettle();
    expect(shelfTitles().first, 'Memory');
    expect(
      tester.widget<ChoiceChip>(find.byKey(const Key('sort-author'))).selected,
      isTrue,
    );

    // Open a different book after returning to the author-sorted shelf.
    await tester.tap(find.byKey(const ValueKey('book-Memory')));
    await tester.pumpAndSettle();
    expect(find.text('Memory'), findsOneWidget);
    expect(find.text('Angelina Aludo'), findsOneWidget);
    final memoryDetails = tester.widget<BookDetails>(find.byType(BookDetails));
    expect(find.text(memoryDetails.book.description), findsOneWidget);

    await tester.tap(find.byKey(const Key('back-to-books')));
    await tester.pumpAndSettle();
    expect(shelfTitles().first, 'Memory');
    expect(
      tester.widget<ChoiceChip>(find.byKey(const Key('sort-author'))).selected,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('a small screen can reach the last cover and scroll details', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BookClubApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('login-button')));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const Key('book-shelf')),
      const Offset(-650, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('book-Carmer and Grit')));
    await tester.pumpAndSettle();
    expect(find.text('Carmer and Grit'), findsOneWidget);
    expect(find.text('Sarah Jean Horwitz'), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('book-detail-scroll')),
      const Offset(0, -350),
    );
    await tester.pumpAndSettle();
    final scrollable = tester.state<ScrollableState>(
      find.descendant(
        of: find.byKey(const Key('book-detail-scroll')),
        matching: find.byType(Scrollable),
      ),
    );
    expect(scrollable.position.pixels, greaterThan(0));
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('back-to-books')));
    await tester.pumpAndSettle();
    expect(find.text('Book Club Home'), findsOneWidget);
  });
}
