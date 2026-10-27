import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hw3_book_club/utilities/stream_to_listenable.dart';

void main() {
  test(
    'stream events notify listeners and disposal cancels subscriptions',
    () async {
      final firstStream = StreamController<void>.broadcast(sync: true);
      final secondStream = StreamController<void>.broadcast(sync: true);
      final listenable = StreamToListenable([
        firstStream.stream,
        secondStream.stream,
      ]);
      int notifications = 0;
      listenable.addListener(() {
        notifications++;
      });

      firstStream.add(null);
      secondStream.add(null);
      expect(notifications, 2);

      listenable.dispose();
      expect(firstStream.hasListener, isFalse);
      expect(secondStream.hasListener, isFalse);
      firstStream.add(null);
      expect(notifications, 2);

      await firstStream.close();
      await secondStream.close();
    },
  );
}
