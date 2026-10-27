import 'package:flutter_test/flutter_test.dart';
import 'package:hw3_book_club/data/sample_books.dart';
import 'package:hw3_book_club/pages/home/cubit/home_cubit.dart';

const authorOrder = [
  'Memory',
  'A Clockwork Orange',
  'The Big Deal',
  "Don't Look Back",
  'Little Gods',
  'James and the Giant Peach',
  'Carmer and Grit',
];

const titleOrder = [
  'A Clockwork Orange',
  'Carmer and Grit',
  "Don't Look Back",
  'James and the Giant Peach',
  'Little Gods',
  'Memory',
  'The Big Deal',
];

void main() {
  late HomeCubit cubit;

  setUp(() {
    cubit = HomeCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  test('the book list is initially empty', () {
    expect(cubit.bookList, isEmpty);
    expect(cubit.state, isA<HomeInitial>());
  });

  test('init populates seven books and sorts by author', () {
    cubit.init();

    expect(cubit.bookList.length, 7);
    expect(cubit.sortType, SortType.author);
    expect(cubit.bookList.map((book) => book.title), authorOrder);
    expect(cubit.state, isA<HomeBookList>());
  });

  test('sorting by title and back by author changes the same list', () {
    cubit.init();
    final originalList = cubit.bookList;

    cubit.sortBooks(SortType.title);
    expect(cubit.bookList.map((book) => book.title), titleOrder);
    expect(cubit.sortType, SortType.title);

    cubit.sortBooks(SortType.author);
    expect(cubit.bookList.map((book) => book.title), authorOrder);
    expect(identical(cubit.bookList, originalList), isTrue);
  });

  test(
    'repeated list states are emitted, including the same sort choice',
    () async {
      final emissions = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<HomeBookList>(),
          isA<HomeBookList>(),
          isA<HomeBookList>(),
        ]),
      );

      cubit.init();
      cubit.sortBooks(SortType.title);
      cubit.sortBooks(SortType.title);

      await emissions;
    },
  );

  test('sorting keeps the sample catalog unchanged', () {
    final originalCatalog = sampleBooks.toList();
    cubit.init();
    cubit.sortBooks(SortType.title);

    expect(sampleBooks, orderedEquals(originalCatalog));
    expect(cubit.bookList, isNot(same(sampleBooks)));
    expect(cubit.bookList.map((book) => book.title), titleOrder);
  });

  test('calling init again does not duplicate the books', () {
    cubit.init();
    cubit.init();
    expect(cubit.bookList.length, 7);
    expect(cubit.bookList.map((book) => book.title), authorOrder);
  });
}
