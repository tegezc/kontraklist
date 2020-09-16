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

class LoadingMenyimpan extends StatelessWidget {
  final String contentText;
  LoadingMenyimpan(this.contentText);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(child: Card(
        child: FractionallySizedBox(
          heightFactor: 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoadingBouncingLine.circle(backgroundColor: Colors.deepOrange),
              Padding(
                padding: const EdgeInsets.only(left:30.0,right: 30.0),
                child: Text(contentText, style: TextStyle(fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),),
    );
  }
}
