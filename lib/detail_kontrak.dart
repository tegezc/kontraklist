import 'package:flutter/material.dart';

class DetailKontrak extends StatefulWidget {
  @override
  _DetailKontrakState createState() => _DetailKontrakState();
}

class _DetailKontrakState extends State<DetailKontrak> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Scaffold(
  //    appBar: AppBar(),
      body: Container(
        height: mediaQueryData.size.height,
        child: SingleChildScrollView(

        ),
      ),
    );
  }
}
