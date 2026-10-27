import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../model/book.dart';
import '../../../widgets/book_details.dart';

class BookDetailView extends StatelessWidget {
  const BookDetailView({super.key, required this.book});

  final Book? book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Detail'),
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
        leading: IconButton(
          key: const Key('back-to-books'),
          tooltip: 'Back to books',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          key: const Key('book-detail-scroll'),
          child: book == null
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Book not found. Use the back arrow to return.'),
                )
              : BookDetails(book: book!),
        ),
      ),
    );
  }
}
