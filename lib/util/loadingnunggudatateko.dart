import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';


class LoadingNunggu extends StatelessWidget {
  final String strContent;

  LoadingNunggu(this.strContent);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        body: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
         // color: Colors.cyan[600],
          child: Center(child: Column(
            children: [
              LoadingBouncingLine.circle(backgroundColor: Colors.deepOrange),
              Text(strContent, style: TextStyle(fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
            ],
          )),
        ));
  }
}


class BelumAdaData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text('Belum ada data kontrak.')));
  }
}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text('Terjadi Kesalahan')));
  }
}
