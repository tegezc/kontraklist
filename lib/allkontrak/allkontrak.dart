import 'package:flutter/material.dart';
import 'package:listkontrakapp/allkontrak/blocshowall.dart';
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
  KontrakDataSourceTable _dtsKontrak;
  Map<String, String> _mapStream;

  int _rowPerPage;
  List<DropdownMenuItem<int>> _dropDownStream;
  List<DropdownMenuItem<int>> _dropDownTypes;

  final TextStyle _styleCombobox =
      new TextStyle(fontSize: 12, color: Colors.black);
  final TextStyle _styleLabelCombo =
      new TextStyle(fontSize: 12, color: Colors.blue);

  BlocShowAll _blocShowAll;
  bool _ascnama = true;
  bool _ascnilai = true;
  bool _ascberakhir = true;

  @override
  void initState() {
    _blocShowAll = BlocShowAll();
    _rowPerPage = PaginatedDataTable.defaultRowsPerPage;

    super.initState();
    this._initialData();
  }

  @override
  void dispose() {
    _blocShowAll.dispose();
    super.dispose();
  }

  void _initialData() {
    _mapStream = Map();
    _blocShowAll.firstTime().then((itemShowAll) {
      itemShowAll.listStream.forEach((element) {
        _mapStream[element.realId] = element.nama;
      });
      _dropDownStream = getDropDownMenuItems(itemShowAll.listStream);
      _dropDownTypes = getDropDownTypeItems(itemShowAll.typeKontrak);
      Map<String,String> mp = Map();
      itemShowAll.listStream.forEach((element) {

        mp[element.realId] = element.nama;
      });
      _dtsKontrak = KontrakDataSourceTable(mp);
      _blocShowAll.reloadData();
    });
  }

  List<DropdownMenuItem<int>> getDropDownMenuItems(
      List<StreamKontrak> lstream) {
    List<DropdownMenuItem<int>> items = new List();
    for (int i = 0; i < lstream.length; i++) {
      StreamKontrak stream = lstream[i];
      items.add(new DropdownMenuItem(
          value: i,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              stream.nama,
              style: _styleCombobox,
            ),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<int>> getDropDownTypeItems(List<String> typeKontrak) {
    List<DropdownMenuItem<int>> items = new List();
    for (int i = 0; i < typeKontrak.length; i++) {
      String type = typeKontrak[i];
      items.add(new DropdownMenuItem(
          value: i,
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

  Widget _combobox(List<DropdownMenuItem<int>> dropdown, int current,
      String label, Function onChagedCombo) {
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
    return StreamBuilder(
        stream: _blocShowAll.itemkontrakeditorStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ItemShowAll itemShowAll = snapshot.data;
            if (itemShowAll.listKontrak.isEmpty) {
              return BelumAdaData();
            } else {
              _dtsKontrak.lkontrak = itemShowAll.listKontrak;
              return Scaffold(
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 55.0, top: 15.0, bottom: 10.0),
                        child: FlatButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.keyboard_backspace),
                            label: Text('Kembali')),
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
                              _combobox(
                                  _dropDownStream,
                                  itemShowAll.currentStream,
                                  'Stream :',
                                  changedDropDownItem),
                              SizedBox(
                                width: 50,
                              ),
                              _combobox(_dropDownTypes, itemShowAll.currentType,
                                  'Type :', changedDropDownItemType),
                              SizedBox(
                                width: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0,
                                    top: 8.0,
                                    right: 20,
                                    left: 10.0),
                                child: RaisedButton(
                                  color: Colors.cyan[600],
                                  textColor: Colors.white,
                                  child: Text('Tampilkan'),
                                  onPressed: () {
                                    _blocShowAll.filter();
                                  },
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
                          sortAscending: false,
                          sortColumnIndex: 6,
                          columnSpacing: 40,
                          source: _dtsKontrak,
                          header:
                              Center(child: Text(DataTableConstants.dtTitle)),
                          onRowsPerPageChanged: (r) {
                            setState(() {
                              _rowPerPage = r;
                            });
                          },
                          rowsPerPage: _rowPerPage,
                          actions: [
                            Tooltip(
                              padding: EdgeInsets.all(8.0),
                              message: 'Export ke CSV',
                              verticalOffset: 16,
                              height: 24,
                              child: IconButton(
                                  icon: Icon(Icons.system_update_alt),
                                  onPressed: () {}),
                            ),
                            Tooltip(
                              padding: EdgeInsets.all(8.0),
                              message: 'Tambah kontrak baru.',
                              verticalOffset: 16,
                              height: 24,
                              child: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
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
                            DataColumn(
                                label: Text(DataTableConstants.colNoKontrak)),
                            DataColumn(
                              label: Text(DataTableConstants.colNmKontrak),
                              onSort: (colIndex, asc) {
                                _sort<String>((kontrak) => kontrak.nama,
                                    colIndex, asc, _dtsKontrak);
                                _ascnama = !_ascnama;
                              },
                            ),
                            DataColumn(
                                label: Text(DataTableConstants.colNmUnit)),
                            DataColumn(
                                label: Text(DataTableConstants.colStream)),
                            DataColumn(
                                label: Text(DataTableConstants.colNilai),
                                onSort: (colIndex, asc) {
                                  print('nilai; $asc');
                                  _sort<num>((kontrak) => kontrak.nilai, colIndex,
                                      asc, _dtsKontrak);
                                  _ascnilai = !_ascnilai;
                                },
                                numeric: true),
                            DataColumn(
                              label: Text(DataTableConstants.colTglBerakhir),
                              onSort: (colIndex, asc) {
                                _sort<DateTime>(
                                    (kontrak) => kontrak.tglBerakhir,
                                    colIndex,
                                    asc,
                                    _dtsKontrak);
                                _ascberakhir = !_ascberakhir;
                              },
                            ),
                            DataColumn(
                                label: Text(DataTableConstants.colDetail)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                    ],
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return ErrorPage();
          } else {
            return LoadingNunggu('Tunggu sebentar...');
          }
        });
  }

  void changedDropDownItem(int selectedStream) {
    _blocShowAll.chageDropdownStream(selectedStream);
  }

  void changedDropDownItemType(int selectedType) {
    _blocShowAll.changeDropdownType(selectedType);
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

  // void _sortInt(int Function(Kontrak kontrak) getField, int colIndex, bool asc,
  //     KontrakDataSourceTable _src) {
  //   _src.sortInt(getField, asc);
  // }
}

class KontrakDataSourceTable extends DataTableSource {
  List<Kontrak> lkontrak;
  final Map<String, String> mapStream;

  KontrakDataSourceTable(this.mapStream);

  Widget _contentNama(String text) {
    return SizedBox(
      width: 400,
      child: Text(text),
    );
  }

  @override
  DataRow getRow(int index) {
    Kontrak k = lkontrak[index];

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
      DataCell(Text('${k.noKontrak == null ? '' : k.noKontrak}'), onTap: () {
        print('tap kolom no kontrak');
      }),
      DataCell(_contentNama(k.nama)),
      DataCell(Text('${k.namaUnit}')),
//     DataCell(Text('${k.region}')),
      DataCell(Text('${mapStream[k.stream]}')),
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
  int get rowCount => lkontrak.length;

  @override
  int get selectedRowCount => 0;

  void sort<T>(Comparable<T> Function(Kontrak d) getField, bool ascending) {
    lkontrak.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    notifyListeners();
  }


  // void sortInt(int Function(Kontrak d) getField, bool ascending) {
  //   lkontrak.sort((a, b) {
  //     final int aValue = getField(a);
  //     final int bValue = getField(b);
  //     return ascending
  //         ? Comparable.compare(aValue, bValue)
  //         : Comparable.compare(bValue, aValue);
  //   });
  //
  //   notifyListeners();
  // }
}
