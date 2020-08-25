import 'dart:convert';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    MediaQueryData md = MediaQuery.of(context);
    if (_listKontrak == null) {
      return LoadingNungguData();
    } else if (_listKontrak.isEmpty) {
      return BelumAdaData();
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: FlatButton.icon(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.keyboard_backspace), label: Text('Kemabli')),
              ),
              PaginatedDataTable(
                columnSpacing: 40,
                source: _dtsKontrak,
                columns: [
                  DataColumn(
                    label: Text(DataTableConstants.colAction),
                  ),
                  DataColumn(label: Text(DataTableConstants.colNoKontrak)),
                  DataColumn(
                    label: Text(DataTableConstants.colNmKontrak),
                    onSort: (colIndex, asc) {
                      _sort<String>(
                          (kontrak) => kontrak.nama, colIndex, asc, _dtsKontrak);
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
                      _sort<DateTime>((kontrak) => kontrak.tglBerakhir, colIndex,
                          asc, _dtsKontrak);
                    },
                  ),
                  DataColumn(label: Text(DataTableConstants.colDetail)),
                ],
                header: Center(child: Text(DataTableConstants.dtTitle)),
                onRowsPerPageChanged: (r) {
                  setState(() {
                    _rowPerPage = r;
                  });
                },
                rowsPerPage: _rowPerPage,
              ),
            ],
          ),
        ),
      );
    }
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
      DataCell(Text('Action delete / Edit'), showEditIcon: true),
      DataCell(Text('${k.noKontrak}')),
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
