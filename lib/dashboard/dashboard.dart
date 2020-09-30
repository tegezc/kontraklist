//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:listkontrakapp/allkontrak/allkontrak.dart';
import 'package:listkontrakapp/detailkontrak/detail_kontrak.dart';
import 'package:listkontrakapp/http/http_controller.dart';
import 'package:listkontrakapp/kontrakeditor/kontrakeditorcontroller.dart';
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
    await openPage(context, KontrakEditorController.baru(_callbackFromDetail,_callbackfinish));
  }

  void _clickTampilkansemua() async {
    await openPage(context, ShowAllKontrak());
  }

  void _callbackfinish() {
    print('masuk sini _callbackfinish');
    this._setupInit();
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

  _callbackFromDetail() {
    print('masuk sini _callbackFromDetail');
    this._setupInit();
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                   CardDashboard(
                            _callbackFromDetail,
                            EnumTypeDashboard.hari90,
                            entryAllKontrak.lkontrak90),
                    CardDashboard(
                            _callbackFromDetail,
                            EnumTypeDashboard.hari180,
                            entryAllKontrak.lKontrak180),
                    CardDashboard(
                            _callbackFromDetail,
                            EnumTypeDashboard.hari360,
                            entryAllKontrak.lKontrak360),
                  ],
                ),
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
      return LoadingNunggu('Sedang mengambil data...');
    } else {
     // if (_entryAllKontrak.isHasData()) {
        return _scaffoldPage(_entryAllKontrak);
      // } else {
      //   return BelumAdaData();
      // }
    }
  }
}

class CardDashboard extends StatefulWidget {
  final EnumTypeDashboard enumTypeDashboard;
  final List<Kontrak> lkontrak;
  final Function callbackFromDetail;

  CardDashboard(this.callbackFromDetail, this.enumTypeDashboard, this.lkontrak,
      {Key key})
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
  int _page = 1;

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

  _callbackFromDetail() {
    widget.callbackFromDetail();
  }

  List<DataColumn> _headerTable() {
    List<DataColumn> ldc = new List();
    ldc.add(DataColumn(
        label: Center(
            child: Text(
      'No Kontrak',
      style: _titleStyle,
    ))));

    ldc.add(DataColumn(
        label: Center(
            child: Text(
      'Nama Kontrak',
      style: _titleStyle,
    ))));

    ldc.add(DataColumn(
        label: Center(
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
    ))));
    return ldc;
  }

  DataRow _contentTable(Kontrak kontrak) {
    return DataRow(
      onSelectChanged: (bool selected) async {
        if (selected) {
          await openPage(context, DetailKontrak(_callbackFromDetail, kontrak));
        }
      },
      cells: <DataCell>[
        DataCell(_textNoDanTanggal(kontrak.noKontrak, kontrak)),
        DataCell(_textContentJudul(kontrak.nama, kontrak)),
        DataCell(_textNoDanTanggal(kontrak.strTglBerakhir, kontrak)),
      ],
    );
  }

  Widget _textContentJudul(String text, Kontrak kontrak) {
    String tmpText = text == null ? '' : text;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(tmpText, style: _titleStyleContent),
    );
  }

  Widget _textNoDanTanggal(String text, Kontrak kontrak) {
    String tmpText = text == null ? '' : text;
    return Center(child: Text(tmpText, style: _titleStyleContent));
  }

  List<DataRow> _table(List<Kontrak> lk) {
    List<DataRow> lrow = new List();
    int estimateRowCount = _page * 10;
    int rowCount = estimateRowCount > lk.length ? lk.length : estimateRowCount;
    for (int i = 0; i < rowCount; i++) {
      Kontrak k = lk[i];
      if (k.flagberakhir == 0) {
        lrow.add(this._contentTable(lk[i]));
      }
    }
    return lrow;
  }

  Widget _cardKontrak(List<Kontrak> lkon, double width) {
    bool ismorevisible = false;
    if (lkon.length > _page * 10) {
      ismorevisible = true;
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
              SizedBox(
                height: 5,
              ),
              DataTable(
                showCheckboxColumn: false,
                columns: this._headerTable(),
                rows: this._table(lkon),
              ),
              ismorevisible
                  ? SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            _page++;
                          });
                        },
                        child: Text('more...'),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = (mediaQueryData.size.width - 120) / 3;
    if (width < 400) {
      width = 400;
    }
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
