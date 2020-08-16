// Flutter code sample for Card

// This sample shows creation of a [Card] widget that shows album information
// and two actions.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        // appBar: AppBar(title: const Text(_title)),
        body: Dashboard(),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CardDashboard(),
          CardDashboard(),
          CardDashboard(),
        ],
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class CardDashboard extends StatefulWidget {
  CardDashboard({Key key}) : super(key: key);

  @override
  _CardDashboardState createState() => _CardDashboardState();
}

class _CardDashboardState extends State<CardDashboard> {
  TableRow _headerTable() {
    return TableRow(children: [
      Center(child: Text('No Kontrak')),
      Center(child: Text('Nama Kontrak')),
      Center(child: Text('Tanggal Berakhir')),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = (mediaQueryData.size.width - 20) / 4;
    return Card(
      child: Container(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: Colors.red,
              height: 50,
              width: width,
              child: Center(
                child: Text(
                  '0 - 90 Hari',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
            ),
            Table(

              border: TableBorder.all(),
              children: [
                _headerTable(),
                TableRow(children: [
                  Icon(
                    Icons.cake,
                    size: 20,
                  ),
                  Icon(
                    Icons.voice_chat,
                    size: 20,
                  ),
                  Icon(
                    Icons.add_location,
                    size: 20,
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp1 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  double iconSize = 40;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Flutter Table - tutorialkart.com'),
          ),
          body: Center(
              child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: Table(
                border: TableBorder.all(),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Icon(
                        Icons.account_box,
                        size: iconSize,
                      ),
                      Text('My Account')
                    ]),
                    Column(children: [
                      Icon(
                        Icons.settings,
                        size: iconSize,
                      ),
                      Text('Settings')
                    ]),
                    Column(children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: iconSize,
                      ),
                      Text('Ideas')
                    ]),
                  ]),
                  TableRow(children: [
                    Icon(
                      Icons.cake,
                      size: iconSize,
                    ),
                    Icon(
                      Icons.voice_chat,
                      size: iconSize,
                    ),
                    Icon(
                      Icons.add_location,
                      size: iconSize,
                    ),
                  ]),
                ],
              ),
            ),
          ]))),
    );
  }
}
