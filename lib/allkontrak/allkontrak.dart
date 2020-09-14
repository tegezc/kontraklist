import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:listkontrakapp/model/enum_app.dart';
import 'package:listkontrakapp/kontrakeditor/kontrakeditor.dart';
import 'package:listkontrakapp/main.dart';
import 'package:listkontrakapp/model/ConstantaApp.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:listkontrakapp/util/loadingnunggudatateko.dart';

class ShowAllKontrak extends StatefulWidget {
  @override
  _ShowAllKontrakState createState() => _ShowAllKontrakState();
}

class _ShowAllKontrakState extends State<ShowAllKontrak> {
  List<Kontrak> _listKontrak;
  KontrakDataSourceTable _dtsKontrak;
  int _rowPerPage;
  List _streams = ["Semua", "Stream1", "Stream2", "Stream3", "Stream4"];
  List<DropdownMenuItem<String>> _dropDownStream;
  String _currentStream;

  List _types = ["Semua", "Baru", "Existing", "Amandemen"];
  List<DropdownMenuItem<String>> _dropDownTypes;
  String _currentType;

  final TextStyle _styleCombobox =
      new TextStyle(fontSize: 12, color: Colors.black);
  final TextStyle _styleLabelCombo =
      new TextStyle(fontSize: 12, color: Colors.blue);

  @override
  void initState() {
    _dropDownStream = getDropDownMenuItems();
    _currentStream = _dropDownStream[0].value;

    _dropDownTypes = getDropDownTypeItems();
    _currentType = _dropDownTypes[0].value;

    _rowPerPage = PaginatedDataTable.defaultRowsPerPage;

    _ngolahData();
    super.initState();
  }

  _ngolahData() {
    _listKontrak = new List();
    List<dynamic> ljson = json.decode(DataJSONCons.dummyjsonkontrak);
    ljson.forEach((element) {
      Kontrak k = new Kontrak.fromJson(element);
      _listKontrak.add(k);
    });
    _dtsKontrak = new KontrakDataSourceTable(_listKontrak);
    setState(() {});
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String stream in _streams) {
      items.add(new DropdownMenuItem(
          value: stream,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              stream,
              style: _styleCombobox,
            ),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownTypeItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String type in _types) {
      items.add(new DropdownMenuItem(
          value: type,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              type,
              style: _styleCombobox,
            ),
          )));
    }
    return items;
  }

  Widget _combobox(
      List<DropdownMenuItem<String>> dropdown, String current, String label,Function onChagedCombo) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, right: 0, left: 0),
          child: Text(
            label,
            style: _styleLabelCombo,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: new DropdownButton(
            value: current,
            items: dropdown,
            onChanged: onChagedCombo,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
//    MediaQueryData md = MediaQuery.of(context);
    if (_listKontrak == null) {
      return LoadingNunggu('Tunggu sebentar...');
    } else if (_listKontrak.isEmpty) {
      return BelumAdaData();
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 55.0, top: 15.0, bottom: 10.0),
                child: FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.keyboard_backspace),
                    label: Text('Kemabli')),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 55.0, right: 55.0, top: 15.0, bottom: 10.0),
                child: Container(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 55.0, right: 55.0, top: 15.0, bottom: 0.0),
                child: Card(
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      _combobox(_dropDownStream, _currentStream, 'Stream :',changedDropDownItem),
                      SizedBox(
                        width: 50,
                      ),
                      _combobox(_dropDownTypes, _currentType, 'Type :',changedDropDownItemType),
                      SizedBox(
                        width: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom:8.0,top: 8.0,right: 20,left: 10.0),
                        child: RaisedButton(
                          color: Colors.cyan[600],
                          textColor: Colors.white,
                          child: Text('Tampilkan'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 55.0, right: 55.0, top: 0.0, bottom: 10.0),
                child: PaginatedDataTable(
                  columnSpacing: 40,
                  source: _dtsKontrak,
                  actions: [
                    Tooltip(
                      padding: EdgeInsets.all(8.0),
                      message: 'Export ke CSV',
                      verticalOffset: 16,
                      height: 24,
                      child: IconButton(icon: Icon(Icons.system_update_alt), onPressed: (){}),
                    ),
                    Tooltip(
                      padding: EdgeInsets.all(8.0),
                      message: 'Tambah kontrak baru.',
                      verticalOffset: 16,
                      height: 24,
                      child: IconButton(icon: Icon(Icons.add), onPressed: (){
                        _clickKontrakBaru();
                      }),
                    ),
                  ],
                  columns: [
                    DataColumn(
                      label: Text(DataTableConstants.colAction),
                    ),
                    DataColumn(
                      label: Text(''),
                    ),
                    DataColumn(label: Text(DataTableConstants.colNoKontrak)),
                    DataColumn(
                      label: Text(DataTableConstants.colNmKontrak),
                      onSort: (colIndex, asc) {
                        _sort<String>((kontrak) => kontrak.nama, colIndex, asc,
                            _dtsKontrak);
                      },
                    ),
                    DataColumn(label: Text(DataTableConstants.colNmUnit)),
                    DataColumn(
                        label: Text(DataTableConstants.colNilai),
                        onSort: (colIndex, asc) {
                          _sortInt((kontrak) => kontrak.nilai, colIndex, asc,
                              _dtsKontrak);
                        },
                        numeric: true),
                    DataColumn(
                      label: Text(DataTableConstants.colTglBerakhir),
                      onSort: (colIndex, asc) {
                        _sort<DateTime>((kontrak) => kontrak.tglBerakhir,
                            colIndex, asc, _dtsKontrak);
                      },
                    ),
                    DataColumn(label: Text(DataTableConstants.colDetail)),
                  ],
                  header: Center(child: Text(DataTableConstants.dtTitle)),
//                header: Row(
//                  children: [
//                    Padding(
//                      padding:
//                      const EdgeInsets.only(top: 40.0, right: 24, left: 20),
//                      child: Text(
//                        'Stream:',
//                        style: TextStyle(color: Colors.blue, fontSize: 16),
//                      ),
//                    ),
//                    Padding(
//                      padding: const EdgeInsets.only(top: 24.0),
//                      child: new DropdownButton(
//                        value: _currentStream,
//                        items: _dropDownStream,
//                        onChanged: changedDropDownItem,
//                      ),
//                    ),
//                  ],
//                ),
                  onRowsPerPageChanged: (r) {
                    setState(() {
                      _rowPerPage = r;
                    });
                  },
                  rowsPerPage: _rowPerPage,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void changedDropDownItem(String selectedStream) {
    setState(() {
      _currentStream = selectedStream;
    });
  }

  void changedDropDownItemType(String selectedType) {
    setState(() {
      _currentType = selectedType;
    });
  }
  void _clickKontrakBaru() async {
    await openPage(context, KontrakEditor(EnumStateEditor.baru));
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }

  void _sort<T>(Comparable<T> Function(Kontrak kontrak) getField, int colIndex,
      bool asc, KontrakDataSourceTable _src) {
    _src.sort<T>(getField, asc);
  }

  void _sortInt(int Function(Kontrak kontrak) getField, int colIndex, bool asc,
      KontrakDataSourceTable _src) {
    _src.sortInt(getField, asc);
  }
}

class KontrakDataSourceTable extends DataTableSource {
  List<Kontrak> _lkontrak;

  KontrakDataSourceTable(this._lkontrak);

  Widget _contentNama(String text) {
    return SizedBox(
      width: 400,
      child: Text(text),
    );
  }

  @override
  DataRow getRow(int index) {
    Kontrak k = _lkontrak[index];

    return DataRow.byIndex(index: index, cells: [
//      DataCell(Text('Action delete / Edit'), showEditIcon: true,onTap: (){print('tap kolom action');}),
      DataCell(
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                print('icon delete di klik');
              }),
          onTap: () {}),
      DataCell(Text(''), onTap: () {
        print('edit');
      }, showEditIcon: true),
      DataCell(Text('${k.noKontrak}'), onTap: () {
        print('tap kolom no kontrak');
      }),
      DataCell(_contentNama(k.nama)),
      DataCell(Text('${k.namaUnit}')),
//     DataCell(Text('${k.region}')),
//     DataCell(Text('${k.stream}')),
//     DataCell(Text('${k.durasi}')),
      DataCell(Text('${k.nilai}')),
      //    DataCell(Text('${k.strTglMulai}')),
      DataCell(Text('${k.strTglBerakhir}')),
//     DataCell(Text('${k.nmPICKontrak}')),
//     DataCell(Text('${k.noHpPICKontrak}')),
//     DataCell(Text('${k.emailPICKontrak}')),
//     DataCell(Text('${k.nmVendor}')),
//     DataCell(Text('${k.nmPICVendor}')),
//     DataCell(Text('${k.noHpPICVendor}')),
//     DataCell(Text('${k.emailPICVendor}')),
//     DataCell(Text('${k.direksi}')),
//     DataCell(Text('${k.penandatangan}')),
//     DataCell(Text('${k.kontrakAwal}')),
      DataCell(Text('Tampilkan Detail')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _lkontrak.length;

  @override
  int get selectedRowCount => 0;

  void sort<T>(Comparable<T> Function(Kontrak d) getField, bool ascending) {
    _lkontrak.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    notifyListeners();
  }

  void sortInt(int Function(Kontrak d) getField, bool ascending) {
    _lkontrak.sort((a, b) {
      final int aValue = getField(a);
      final int bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    notifyListeners();
  }
}
