import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';


class LoadingNungguData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: LoadingBouncingLine.circle(backgroundColor: Colors.deepOrange)));
  }
}


class BelumAdaData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text('Belum ada data kontrak.')));
  }
}
