import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/sample_books.dart';
import '../../../model/book.dart';

part 'home_state.dart';

enum SortType { author, title }

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final List<Book> bookList = [];
  SortType sortType = SortType.author;

  void init() {
    // Clearing first prevents duplicates if init() is called again.
    bookList.clear();
    bookList.addAll(sampleBooks);
    sortBooks(SortType.author);
  }

  void sortBooks(SortType selectedSort) {
    sortType = selectedSort;

    if (sortType == SortType.author) {
      bookList.sort((Book first, Book second) {
        final String firstAuthor = first.author.toLowerCase();
        final String secondAuthor = second.author.toLowerCase();
        final int result = firstAuthor.compareTo(secondAuthor);

        // If the authors match, compare the titles to break the tie.
        if (result == 0) {
          return first.title.toLowerCase().compareTo(
            second.title.toLowerCase(),
          );
        }

        return result;
      });
    } else {
      bookList.sort((Book first, Book second) {
        final String firstTitle = first.title.toLowerCase();
        final String secondTitle = second.title.toLowerCase();
        return firstTitle.compareTo(secondTitle);
      });
    }

    emit(HomeBookList());
  }
}
