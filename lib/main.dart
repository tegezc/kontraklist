import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listkontrakapp/allkontrak.dart';
import 'package:listkontrakapp/detail_kontrak.dart';
import 'package:listkontrakapp/enum_app.dart';
import 'package:listkontrakapp/kontrakeditor.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:listkontrakapp/util/loadingnunggudatateko.dart';

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
    home: DetailKontrak(null),
      navigatorObservers: <NavigatorObserver>[
        SwipeBackObserver(),
      ],
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextStyle _styleButton = new TextStyle(
      fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.0);

  Widget _button(String text, Function clickAction) {
    return RaisedButton(
      color: Colors.cyan[600],
      child: Text(text, style: _styleButton),
      onPressed: clickAction,
    );
  }

  void _clickKontrakBaru() async{
    await openPage(context, KontrakEditor(EnumStateEditor.baru));
  }

  void _clickTampilkansemua()async{
    await openPage(context, ShowAllKontrak());
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SizedBox(
                  width: 60.0,
                ),
                _button('Buat Kontrak Baru', _clickKontrakBaru),
                SizedBox(
                  width: 12,
                ),
                _button('Tampilkan Semua Kontrak', () {
                  _clickTampilkansemua();
                })
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 55.0, right: 55.0, top: 15.0, bottom: 10.0),
              child: Container(
                height: 2,
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardDashboard(),
                CardDashboard(),
                CardDashboard(),
              ],
            ),
          ],
        ),
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
  final TextStyle _titleStyle =
      new TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
  final TextStyle _titleStyleContent = new TextStyle(
    fontSize: 10,
  );

  @override
  void initState() {
    super.initState();
  }

  TableRow _headerTable() {
    return TableRow(children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
              child: Text(
            'No Kontrak',
            style: _titleStyle,
          ))),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
              child: Text(
            'Nama Kontrak',
            style: _titleStyle,
          ))),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
              child: Column(
            children: [
              Text(
                'Tanggal',
                style: _titleStyle,
              ),
              Text(
                'Berakhir',
                style: _titleStyle,
              )
            ],
          ))),
    ]);
  }

  TableRow _contentTable(Kontrak kontrak) {
    return TableRow(children: [
      _textNoDanTanggal(kontrak.noKontrak, kontrak),
      _textContentJudul(kontrak.nama, kontrak),
      _textNoDanTanggal(kontrak.strTglBerakhir, kontrak),
    ]);
  }

  Widget _textContentJudul(String text, Kontrak kontrak) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: _titleStyleContent),
      ),
    );
  }

  Widget _textNoDanTanggal(String text, Kontrak kontrak) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: InkWell(
          onTap: () async {
            await openPage(context, DetailKontrak(kontrak));
          },
          child: Center(child: Text(text, style: _titleStyleContent))),
    );
  }

  List<TableRow> _table(List<Kontrak> lk) {
    List<TableRow> lrow = new List();
    lrow.add(this._headerTable());
    for (int i = 0; i < lk.length; i++) {
      lrow.add(this._contentTable(lk[i]));
    }
    return lrow;
  }

  List<Kontrak> _createDummyKontrak() {
    List<Kontrak> lk = new List();
    lk.add(new Kontrak(
        'RR2015/12/20',
        'Pengadaan komputer dan Printer divisi IT Pertamina',
        DateTime(2019, 12, 20)));
    lk.add(new Kontrak(
        'RR2016/12/20',
        'Pengadaan komputer dan Printer divisi IT Pertamina',
        DateTime(2020, 12, 20)));
    lk.add(new Kontrak(
        'RR2016/12/20',
        'Pengadaan komputer dan Printer divisi IT Pertamina',
        DateTime(2021, 12, 20)));
    lk.add(new Kontrak(
        'RR2016/12/20',
        'Pengadaan komputer dan Printer divisi IT Pertamina',
        DateTime(2022, 12, 20)));
    return lk;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = (mediaQueryData.size.width - 120) / 3;
    List<Kontrak> lkontrak = _createDummyKontrak();
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(1),
                // 0: FlexColumnWidth(4.501), // - is ok
                // 0: FlexColumnWidth(4.499), //- ok as well
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
              },
              children: this._table(lkontrak),
            ),
          ],
        ),
      ),
    );
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
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
