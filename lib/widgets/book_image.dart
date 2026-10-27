import 'package:flutter/material.dart';

import '../model/book.dart';

class BookImage extends StatelessWidget {
  const BookImage({super.key, required this.book, this.width = 100});

  final Book book;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      book.imagePath,
      width: width,
      height: width * 5 / 3,
      fit: BoxFit.cover,
      semanticLabel: '${book.title} by ${book.author}',
    );
  }
}
