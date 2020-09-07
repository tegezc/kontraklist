import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listkontrakapp/dashboard/dashboard.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Opensans',
      ),
      title: _title,
//      home: DKontrak(null),
      home: Dashboard(),
      //  home:FileUploadApp(),
      navigatorObservers: <NavigatorObserver>[
        SwipeBackObserver(),
      ],
    );
  }
}

class SwipeBackObserver extends NavigatorObserver {
  static Completer promise;

  @override
  void didStartUserGesture(Route route, Route previousRoute) {
    // make a new promise
    promise = Completer();
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    // resolve the promise
    promise.complete();
  }
}
