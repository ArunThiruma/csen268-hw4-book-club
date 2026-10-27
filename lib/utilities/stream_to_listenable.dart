import 'dart:async';

import 'package:flutter/foundation.dart';

class StreamToListenable extends ChangeNotifier {
  StreamToListenable(List<Stream<dynamic>> streams) {
    for (final stream in streams) {
      final subscription = stream.listen((event) {
        notifyListeners();
      });
      subscriptions.add(subscription);
    }
  }

  final List<StreamSubscription<dynamic>> subscriptions = [];

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
