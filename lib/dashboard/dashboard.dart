import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:listkontrakapp/allkontrak/allkontrak.dart';
import 'package:listkontrakapp/detailkontrak/detail_kontrak.dart';
import 'package:listkontrakapp/http/http_controller.dart';
import 'package:listkontrakapp/kontrakeditor/kontrakeditor.dart';
import 'package:listkontrakapp/main.dart';
import 'package:listkontrakapp/model/enum_app.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:listkontrakapp/util/loadingnunggudatateko.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextStyle _styleButton = new TextStyle(
      fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.0);
  EntryAllKontrak _entryAllKontrak;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    this._setupInit();
    super.initState();
  }

  void _setupInit() async {
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response = await httpAction.getDashboardData();

    List<dynamic> data90 = response['1'];
    List<dynamic> data180 = response['2'];
    List<dynamic> data360 = response['3'];

    List<Kontrak> lkontrak90 = List();
    List<Kontrak> lkontrak180 = List();
    List<Kontrak> lkontrak360 = List();

    lkontrak90.addAll(this._listKontrak(data90));
    lkontrak180.addAll(this._listKontrak(data180));
    lkontrak360.addAll(this._listKontrak(data360));
    setState(() {
      _entryAllKontrak = EntryAllKontrak(lkontrak90, lkontrak180, lkontrak360);
    });
  }

  List<Kontrak> _listKontrak(List<dynamic> ljson) {
    List<Kontrak> lkon = new List();
    if (ljson != null) {
      ljson.forEach((element) {
        Kontrak kontrak = Kontrak.fromJson(element);
        lkon.add(kontrak);
      });
    }

    return lkon;
  }

  Widget _button(String text, Function clickAction) {
    return RaisedButton(
      color: Colors.cyan[600],
      child: Text(text, style: _styleButton),
      onPressed: clickAction,
    );
  }

  void _clickKontrakBaru() async {
    await openPage(context, KontrakEditor(EnumStateEditor.baru));
  }

  void _clickTampilkansemua() async {
    await openPage(context, ShowAllKontrak());
  }

  // Future<String> _saveSetting() async {
  //   String data =
  //       await DefaultAssetBundle.of(context).loadString("assets/settings.json");
  //   final jsonResult = json.decode(data);
  //   String result = jsonResult['host'];
  //   if (result == null) {
  //     return result;
  //   } else {
  //     // obtain shared preferences
  //     final prefs = await SharedPreferences.getInstance();
  //     // set value
  //     prefs.setString('host', result);
  //     return result;
  //   }
  // }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }

  Widget _scaffoldPage(EntryAllKontrak entryAllKontrak) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
              Wrap(
                direction: Axis.horizontal,
                children: [
                  entryAllKontrak.lkontrak90.isNotEmpty
                      ? CardDashboard(
                          EnumTypeDashboard.hari90, entryAllKontrak.lkontrak90)
                      : Container(),
                  entryAllKontrak.lKontrak180.isNotEmpty
                      ? CardDashboard(
                          EnumTypeDashboard.hari180, entryAllKontrak.lKontrak180)
                      : Container(),
                  entryAllKontrak.lKontrak360.isNotEmpty
                      ? CardDashboard(
                          EnumTypeDashboard.hari360, entryAllKontrak.lKontrak360)
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_entryAllKontrak == null) {
      return LoadingNungguData();
    } else {
      if (_entryAllKontrak.isHasData()) {
        return _scaffoldPage(_entryAllKontrak);
      } else {
        return BelumAdaData();
      }
    }
  }
}

class CardDashboard extends StatefulWidget {
  final EnumTypeDashboard enumTypeDashboard;
  final List<Kontrak> lkontrak;

  CardDashboard(this.enumTypeDashboard, this.lkontrak, {Key key})
      : super(key: key);

  @override
  _CardDashboardState createState() => _CardDashboardState();
}

class _CardDashboardState extends State<CardDashboard> {
  final TextStyle _titleStyle =
      new TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
  final TextStyle _titleStyleContent = new TextStyle(
    fontSize: 10,
  );
  Color _color;
  String _textHeader;

  @override
  void initState() {
    switch (widget.enumTypeDashboard) {
      case EnumTypeDashboard.hari90:
        {
          _color = Colors.red;
          _textHeader = '0 - 90 Hari';
        }
        break;
      case EnumTypeDashboard.hari180:
        {
          _color = Colors.yellow;
          _textHeader = '91 - 180 Hari';
        }
        break;
      case EnumTypeDashboard.hari360:
        {
          _color = Colors.green;
          _textHeader = '181 - 360 Hari';
        }
        break;
    }
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
    String tmpText = text==null?'':text;
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(tmpText, style: _titleStyleContent),
      ),
    );
  }

  Widget _textNoDanTanggal(String text, Kontrak kontrak) {
    String tmpText = text==null?'':text;
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: InkWell(
          onTap: () async {
            await openPage(context, DetailKontrak(kontrak));
          },
          child: Center(child: Text(tmpText, style: _titleStyleContent))),
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

  // List<Kontrak> _createDummyKontrak() {
  //   List<Kontrak> lk = new List();
  //   lk.add(new Kontrak(
  //       'RR2015/12/20',
  //       'Pengadaan komputer dan Printer divisi IT Pertamina',
  //       DateTime(2019, 12, 20)));
  //   lk.add(new Kontrak(
  //       'RR2016/12/20',
  //       'Pengadaan komputer dan Printer divisi IT Pertamina',
  //       DateTime(2020, 12, 20)));
  //   lk.add(new Kontrak(
  //       'RR2016/12/20',
  //       'Pengadaan komputer dan Printer divisi IT Pertamina',
  //       DateTime(2021, 12, 20)));
  //   lk.add(new Kontrak(
  //       'RR2016/12/20',
  //       'Pengadaan komputer dan Printer divisi IT Pertamina',
  //       DateTime(2022, 12, 20)));
  //   return lk;
  // }

  Widget _cardKontrak(List<Kontrak> lkon, double width) {
    return Card(
      child: Container(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: _color,
              height: 50,
              width: width,
              child: Center(
                child: Text(
                  _textHeader,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
              },
              children: this._table(lkon),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = (mediaQueryData.size.width - 120) / 3;
    List<Kontrak> lkontrak = widget.lkontrak;
    return _cardKontrak(lkontrak, width);
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }
}

class EntryAllKontrak {
  List<Kontrak> lkontrak90;
  List<Kontrak> lKontrak180;
  List<Kontrak> lKontrak360;

  EntryAllKontrak(this.lkontrak90, this.lKontrak180, this.lKontrak360);

  bool isHasData() {
    if (lkontrak90.isEmpty && lKontrak180.isEmpty && lKontrak360.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
