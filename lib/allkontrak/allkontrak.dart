import 'package:flutter/material.dart';
import 'package:listkontrakapp/allkontrak/blocshowall.dart';
import 'package:listkontrakapp/detailkontrak/detail_kontrak.dart';
import 'package:listkontrakapp/kontrakeditor/kontrakeditor.dart';
import 'package:listkontrakapp/main.dart';
import 'package:listkontrakapp/model/ConstantaApp.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:listkontrakapp/util/loadingnunggudatateko.dart';
import 'package:loading_animations/loading_animations.dart';

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

  final Color colorButton = Colors.cyan[600];
  final Color colorTextBtn = Colors.white;

  BlocShowAll _blocShowAll;

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
            _dtsKontrak = KontrakDataSourceTable(
                itemShowAll.listKontrak, _mapStream, _clickCell);
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
                                  bottom: 8.0, top: 8.0, right: 20, left: 10.0),
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
                        sortAscending: itemShowAll.asc,
                        sortColumnIndex: itemShowAll.sortIndex,
                        columnSpacing: 40,
                        source: _dtsKontrak,
                        header: Center(child: Text(DataTableConstants.dtTitle)),
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
                                onPressed: () {
                                  _blocShowAll.downloadCsv();
                                }),
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
                              _sort<String>((kontrak) => kontrak.nama, colIndex,
                                  asc, _dtsKontrak);
                            },
                          ),
                          DataColumn(label: Text(DataTableConstants.colNmUnit)),
                          DataColumn(label: Text(DataTableConstants.colStream)),
                          DataColumn(
                              label: Text(DataTableConstants.colNilai),
                              onSort: (colIndex, asc) {
                                print('nilai; $asc');
                                _sort<num>((kontrak) => kontrak.nilai, colIndex,
                                    asc, _dtsKontrak);
                              },
                              numeric: true),
                          DataColumn(
                            label: Text(DataTableConstants.colTglBerakhir),
                            onSort: (colIndex, asc) {
                              _sortDate(colIndex, asc, _dtsKontrak);
                            },
                          ),
                          DataColumn(label: Text(DataTableConstants.colDetail)),
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
    await openPage(context, KontrakEditor.baru());
  }

  void _clickCell(
      EnumCallBackClickCell enumCallBackClickCell, int index, Kontrak kontrak) {
    print('sampai kah');
    switch (enumCallBackClickCell) {
      case EnumCallBackClickCell.delete:
        this._handleDelete(index, kontrak);
        break;
      case EnumCallBackClickCell.edit:
        this._handleEdit(index, kontrak);
        break;
      case EnumCallBackClickCell.detail:
        this._handleViewDetail(index, kontrak);
        break;
      case EnumCallBackClickCell.nokontrak:
        this._handleShowDocument(index, kontrak);
        break;
    }
  }

  void _handleDelete(int index, Kontrak kontrak) async {
    await _showDialogConfirmDelete(context,kontrak);
  }

  void _handleEdit(int index, Kontrak kontrak) async{
    await openPage(context, KontrakEditor.editmode(kontrak));
  }

  void _handleViewDetail(int index, Kontrak kontrak)async {
    await openPage(context, DetailKontrak(kontrak));
  }

  void _handleShowDocument(int index, Kontrak kontrak) {}

  Future _showDialogConfirmDelete(BuildContext context,Kontrak kontrak) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: RichText(
                text: TextSpan(
                  text: 'Apakah anda yakin akan menghapus kontrak ',
                  style: TextStyle(fontSize: 14,color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: kontrak.noKontrak==null?'?\n':'${kontrak.noKontrak}?\n',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Menghapus kontrak artinya semua dokumen yang\n berhubungan dengan kontrak ini juga akan di hapus.'),
                  ],
                ),
              ),
              //             title: Text('Apakah anda yakin akan menghapus kontrak?\n Menghapus kontrak artinya semua dokumen yang\n berhubungan dengan kontrak ini juga akan di hapus.'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0, left: 16.0, bottom: 3.0),
                  child: RaisedButton(
                    color: colorButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Colors.cyan)),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _confirmedDelete(kontrak);
                    },
                    child: Text(
                      'Ya',
                      style: TextStyle(
                          color: colorTextBtn,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0, left: 16.0, bottom: 3.0),
                  child: RaisedButton(
                    color: colorButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Colors.cyan)),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: colorTextBtn,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ));
  }

  Future _loadingWaiting(BuildContext context,String text) {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SimpleDialog(
          title: RichText(
            text: TextSpan(
              text: '$text ',
              style: TextStyle(fontSize: 14,color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: '\n',),
              ],
            ),
          ),
          //             title: Text('Apakah anda yakin akan menghapus kontrak?\n Menghapus kontrak artinya semua dokumen yang\n berhubungan dengan kontrak ini juga akan di hapus.'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          children: <Widget>[
            LoadingBouncingLine.circle(backgroundColor: Colors.deepOrange),
          ],
        ));
  }

  void _confirmedDelete(kontrak){
    this._loadingWaiting(context, 'Sedang menghapus data...');
    _blocShowAll.deleteKontrak(kontrak).then((value) {
      if(value){
        Navigator.of(context).pop();
        _blocShowAll.reloadData();
      }
    });
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
    _blocShowAll.setSortIndex(colIndex, asc);
  }

  /// handle date null value
  void _sortDate(int colIndex, bool asc, KontrakDataSourceTable _src) {
    _src.sortDate(asc);
    _blocShowAll.setSortIndex(colIndex, asc);
  }
}

class KontrakDataSourceTable extends DataTableSource {
  List<Kontrak> lkontrak;
  final Map<String, String> mapStream;
  final Function clickCell;

  KontrakDataSourceTable(this.lkontrak, this.mapStream, this.clickCell);

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
            onPressed: () async {
              this._clickCell(EnumCallBackClickCell.delete, index, k);
            }),
      ),
      DataCell(Text(''), onTap: () {
        this._clickCell(EnumCallBackClickCell.edit, index, k);
      }, showEditIcon: true),
      DataCell(Text('${k.noKontrak == null ? '' : k.noKontrak}'), onTap: () {
        this._clickCell(EnumCallBackClickCell.nokontrak, index, k);
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
      DataCell(Text('Tampilkan Detail'), onTap: () {
        this._clickCell(EnumCallBackClickCell.detail, index, k);
      }),
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

  // karena tanggal ada kemungkinan null
  void sortDate(bool ascending) {
    lkontrak.sort((a, b) {
      final aValue =
          a.tglBerakhir == null ? DateTime(1980, 1, 1) : a.tglBerakhir;
      final bValue =
          b.tglBerakhir == null ? DateTime(1980, 1, 1) : b.tglBerakhir;
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    notifyListeners();
  }

  void _clickCell(
      EnumCallBackClickCell enumCallBackClickCell, int index, Kontrak kontrak) {
    clickCell(enumCallBackClickCell, index, kontrak);
  }
}

enum EnumCallBackClickCell { delete, edit, detail, nokontrak }
