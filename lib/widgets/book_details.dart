import 'package:flutter/material.dart';

import '../model/book.dart';
import 'book_image.dart';

class BookDetails extends StatelessWidget {
  const BookDetails({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookImage(book: book, width: 200),
          const SizedBox(height: 15),
          Text(
            book.title,
            style: const TextStyle(fontSize: 28, height: 36 / 28),
          ),
          const SizedBox(height: 15),
          Text(
            book.author,
            style: const TextStyle(fontSize: 22, height: 28 / 22),
          ),
          const SizedBox(height: 15),
          Text(
            book.description,
            style: const TextStyle(
              fontSize: 14,
              height: 20 / 14,
              letterSpacing: 0.25,
            ),
          ),
        ],
      ),
    );
  }
}
