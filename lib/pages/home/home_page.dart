import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/home_cubit.dart';
import 'views/book_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.sortType});

  final SortType sortType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) {
        final HomeCubit cubit = HomeCubit();
        cubit.init();
        if (sortType == SortType.title) {
          cubit.sortBooks(SortType.title);
        }
        return cubit;
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final HomeCubit cubit = BlocProvider.of<HomeCubit>(context);

          if (state is HomeBookList) {
            return BookListView(
              books: cubit.bookList,
              sortType: cubit.sortType,
            );
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
