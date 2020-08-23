import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listkontrakapp/model/ConstantaApp.dart';
import 'package:listkontrakapp/model/kontrak.dart';

final double widthCell = 200.0;
class DetailKontrak extends StatefulWidget {
  final Kontrak kontrak;

  DetailKontrak(this.kontrak);

  @override
  _DetailKontrakState createState() => _DetailKontrakState();
}

class _DetailKontrakState extends State<DetailKontrak> {


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 20;
    double widthtable = width * 19;
    return Scaffold(
      appBar: AppBar(
        title: Text("Avengers DataTable"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Table2column(null, widthtable),
                      Table5column(null, widthtable),
                      SizedBox(height: 20,),
                      CardPICKontrak(null,widthtable),
                      SizedBox(height: 16,),
                     CardVendor(null,widthtable),
                    ],
                  ),
                ),
              ),

              Expansionpanel(),
              SizedBox(
                height: 400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogDocumentView extends StatefulWidget {
  @override
  _LogDocumentViewState createState() => _LogDocumentViewState();
}

class _LogDocumentViewState extends State<LogDocumentView> {
  List<Avengers> avengers;
  List<Avengers> selectedAvengers;
  bool sort;



  @override
  void initState() {
    sort = false;
    selectedAvengers = [];
    avengers = Avengers.getAvengers();
    super.initState();
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        avengers.sort((a, b) => a.name.compareTo(b.name));
      } else {
        avengers.sort((a, b) => b.name.compareTo(a.name));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: DataTable(
        sortAscending: sort,
        sortColumnIndex: 0,
        columns: [
          DataColumn(
              label: Text("Name", style: TextStyle(fontSize: 16)),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sort;
                });
                onSortColum(columnIndex, ascending);
              }),
          DataColumn(
            label: Text("Weapons", style: TextStyle(fontSize: 16)),
            numeric: false,
          ),
        ],
        rows: avengers
            .map(
              (avenger) => DataRow(
              selected: selectedAvengers.contains(avenger),
              cells: [
                DataCell(
                  Text(avenger.name),
                  onTap: () {
                    print('Selected ${avenger.name}');
                  },
                ),
                DataCell(
                  Text(avenger.weapon),
                ),
              ]),
        )
            .toList(),
      ),
    );
  }
}


class Avengers {
  String name;
  String weapon;

  Avengers({this.name, this.weapon});

  static List<Avengers> getAvengers() {
    return <Avengers>[
      Avengers(name: "Captain America", weapon: "Shield"),
      Avengers(name: "Thor", weapon: "Mjolnir"),
      Avengers(name: "Spiderman", weapon: "Web Shooters"),
      Avengers(name: "Doctor Strange ", weapon: "Eye Of Agamotto"),
    ];
  }
}

class CardVendor extends StatefulWidget {
  final Kontrak kontrak;
  final double width;

  CardVendor(this.kontrak, this.width);

  @override
  _CardVendorState createState() => _CardVendorState();
}

class _CardVendorState extends State<CardVendor> {
  Kontrak _kontrak;
  double _widthPoint;
  final TextStyle _txtStyleLabel = new TextStyle(color: Colors.grey);
  final TextStyle _txtStyValue = new TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() {
    _widthPoint = widget.width / 20;
    if (widget.kontrak == null) {
      Map<String, dynamic> strjson = json.decode(dummykontrak);
      _kontrak = Kontrak.fromJson(strjson);
    }
    super.initState();
  }

  @override
  void disopose() {
    super.dispose();
  }

  Widget _cellLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        text,
        style: _txtStyleLabel,
      ),
    );
  }

  Widget _valueLabel(String textLabel, String textContent) {
    return TableCell(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cellLabel(textLabel),
        SizedBox(
          height: 4,
        ),
        Container(
            decoration: BoxDecoration(
                //  color: Colors.red,
//                    border: Border.all(color: Colors.black26),
//                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              textContent,
              style: _txtStyValue,
            )),
      ],
    ));
  }

  TableRow _forPadding(double height) {
    return TableRow(children: [
      TableCell(
        child: SizedBox(
          height: height,
        ),
      ),
      TableCell(
        child: SizedBox(
          height: height,
        ),
      ),
      TableCell(
        child: SizedBox(
          height: height,
        ),
      ),
      TableCell(
        child: SizedBox(
          height: height,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double widthcol = widthCell;
    if (_widthPoint * 5 < widthCell) {
      widthcol = _widthPoint * 5;
    }
    return Table(
      columnWidths: {
        0: FixedColumnWidth(widthcol),
        1: FixedColumnWidth(widthcol),
        2: FixedColumnWidth(widthcol),
        3: FixedColumnWidth(widthcol),
      },
//          defaultColumnWidth:
//              FixedColumnWidth(MediaQuery.of(context).size.width / 3),
//          border: TableBorder.all(
//              color: Colors.black26, width: 1, style: BorderStyle.none),
      children: [
        TableRow(children: [
          _valueLabel('Pemenang:', _kontrak.nmVendor),
          _valueLabel(
              DataTableConstants.colNmPicVendor, _kontrak.nmPICVendor),
          _valueLabel(
              DataTableConstants.colNoHpPicVendor, _kontrak.noHpPICVendor),
          _valueLabel(
              DataTableConstants.colEmailPicVendor, _kontrak.emailPICVendor)
        ]),
        _forPadding(16.0),
      ],
    );
  }
}

class CardPICKontrak extends StatefulWidget {
  final Kontrak kontrak;
  final double width;

  CardPICKontrak(this.kontrak, this.width);

  @override
  _CardPICKontrakState createState() => _CardPICKontrakState();
}

class _CardPICKontrakState extends State<CardPICKontrak> {
  Kontrak _kontrak;
  double _widthPoint;
  final TextStyle _txtStyleLabel = new TextStyle(color: Colors.grey);
  final TextStyle _txtStyValue = new TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() {
    _widthPoint = widget.width / 20;
    if (widget.kontrak == null) {
      Map<String, dynamic> strjson = json.decode(dummykontrak);
      _kontrak = Kontrak.fromJson(strjson);
    }
    super.initState();
  }

  @override
  void disopose() {
    super.dispose();
  }

  Widget _cellLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        text,
        style: _txtStyleLabel,
      ),
    );
  }

  Widget _valueLabel(String textLabel, String textContent) {
    return TableCell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cellLabel(textLabel),
            SizedBox(
              height: 4,
            ),
            Container(
                decoration: BoxDecoration(
                  //  color: Colors.red,
//                    border: Border.all(color: Colors.black26),
//                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  textContent,
                  style: _txtStyValue,
                )),
          ],
        ));
  }

  TableRow _forPadding(double height) {
    return TableRow(children: [
      TableCell(
        child: SizedBox(
          height: height,
        ),
      ),
      TableCell(
        child: SizedBox(
          height: height,
        ),
      ),
      TableCell(
        child: SizedBox(
          height: height,
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double widthcol = widthCell;
    if (_widthPoint * 6 < widthCell) {
      widthcol = _widthPoint * 6;
    }
    return Table(
      columnWidths: {
        0: FixedColumnWidth(widthcol),
        1: FixedColumnWidth(widthcol),
        2: FixedColumnWidth(widthcol)
      },
//          defaultColumnWidth:
//              FixedColumnWidth(MediaQuery.of(context).size.width / 3),
//          border: TableBorder.all(
//              color: Colors.black26, width: 1, style: BorderStyle.none),
      children: [
        TableRow(children: [
          _valueLabel(
              DataTableConstants.colNmPicKontrak, _kontrak.nmPICKontrak),
          _valueLabel(
              DataTableConstants.colNoHpPicKontrak, _kontrak.noHpPICKontrak),
          _valueLabel(
              DataTableConstants.colEmailPicKontrak, _kontrak.emailPICKontrak)
        ]),
        _forPadding(16.0),
      ],
    );
  }
}

class Table5column extends StatefulWidget {
  final Kontrak kontrak;
  final double width;

  Table5column(this.kontrak, this.width);

  @override
  _Table5columnState createState() => _Table5columnState();
}

class _Table5columnState extends State<Table5column> {
  Kontrak _kontrak;
  double _widthPoint;
  final TextStyle _txtStyleLabel = new TextStyle(color: Colors.grey);
  final TextStyle _txtStyValue = new TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() {
    _widthPoint = widget.width / 20;
    if (widget.kontrak == null) {
      Map<String, dynamic> strjson = json.decode(dummykontrak);
      _kontrak = Kontrak.fromJson(strjson);
    }
    super.initState();
  }

  @override
  void disopose() {
    super.dispose();
  }

  Widget _cellLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        text,
        style: _txtStyleLabel,
      ),
    );
  }

  Widget _valueLabel(String textLabel, String textContent) {
    return TableCell(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cellLabel(textLabel),
        SizedBox(
          height: 4,
        ),
        Container(
            decoration: BoxDecoration(
                //  color: Colors.red,
//                    border: Border.all(color: Colors.black26),
//                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              textContent,
              style: _txtStyValue,
            )),
      ],
    ));
  }

  TableRow _forPadding(double height) {
    return TableRow(children: [
      TableCell(
        child: SizedBox(
          height: height,
        ),
      ),
      TableCell(
        child: SizedBox(
          height: height,
        ),
      ),
      TableCell(
        child: SizedBox(
          height: height,
        ),
      ),
      TableCell(
        child: SizedBox(
          height: height,
        ),
      ),
      TableCell(
        child: SizedBox(
          height: height,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double widthcol = widthCell;
    if (_widthPoint * 6 < widthCell) {
      widthcol = _widthPoint * 6;
    }
    return Table(
      columnWidths: {
        0: FixedColumnWidth(widthcol),
        1: FixedColumnWidth(widthcol),
        2: FixedColumnWidth(widthcol),
        3: FixedColumnWidth(widthcol),
        4: FixedColumnWidth(widthcol),
      },
//          defaultColumnWidth:
//              FixedColumnWidth(MediaQuery.of(context).size.width / 3),
//          border: TableBorder.all(
//              color: Colors.black26, width: 1, style: BorderStyle.none),
      children: [
        TableRow(children: [
          _valueLabel(DataTableConstants.colNmUnit, _kontrak.namaUnit),
          _valueLabel(DataTableConstants.colRegion, _kontrak.region),
          _valueLabel(DataTableConstants.colStream, _kontrak.stream),
          _valueLabel(DataTableConstants.colDurasi, '${_kontrak.durasi}'),
          _valueLabel(DataTableConstants.colNilai, '${_kontrak.nilai}'),
        ]),
        _forPadding(16.0),
        TableRow(children: [
          _valueLabel(DataTableConstants.colDireksi, _kontrak.direksi),
          _valueLabel(
              DataTableConstants.colPenandatangan, _kontrak.penandatangan),
          _valueLabel(DataTableConstants.colTglMulai, _kontrak.strTglMulai),
          _valueLabel(
              DataTableConstants.colTglBerakhir, _kontrak.strTglBerakhir),
          _valueLabel('Kontrak Awal', 'Kosong'),
        ]),
        _forPadding(12.0),
      ],
    );
  }
}

class Table2column extends StatefulWidget {
  final Kontrak kontrak;
  final double width;

  Table2column(this.kontrak, this.width);

  @override
  _Table2columnState createState() => _Table2columnState();
}

class _Table2columnState extends State<Table2column> {
  Kontrak _kontrak;
  double _widthPoint;

  @override
  void initState() {
    _widthPoint = widget.width / 20;
    if (widget.kontrak == null) {
      Map<String, dynamic> strjson = json.decode(dummykontrak);
      _kontrak = Kontrak.fromJson(strjson);
    }
    super.initState();
  }

  @override
  void disopose() {
    super.dispose();
  }

  Widget _cellLabel(String text) {
    return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text),
        ));
  }

  Widget _valueLabel(String text) {
    return TableCell(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            //  color: Colors.red,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double widthcol1 = 130;
    if (_widthPoint * 5 < 150) {
      widthcol1 = _widthPoint * 5;
    }
    return Table(
      columnWidths: {
        0: FixedColumnWidth(widthcol1),
        1: FixedColumnWidth(_widthPoint * 14)
      },
//          defaultColumnWidth:
//              FixedColumnWidth(MediaQuery.of(context).size.width / 3),
//          border: TableBorder.all(
//              color: Colors.black26, width: 1, style: BorderStyle.none),
      children: [
        TableRow(children: [
          _cellLabel(DataTableConstants.colNoKontrak),
          _valueLabel(_kontrak.noKontrak),
        ]),
        TableRow(children: [
          _cellLabel(DataTableConstants.colNmKontrak),
          _valueLabel(_kontrak.nama),
        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colNmUnit),
//          _valueLabel(_kontrak.namaUnit),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colRegion),
//          _valueLabel(_kontrak.region),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colStream),
//          _valueLabel(_kontrak.stream)
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colDurasi),
//          _valueLabel('${_kontrak.durasi}'),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colNilai),
//          _valueLabel('${_kontrak.nilai}'),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colTglMulai),
//          _valueLabel(_kontrak.strTglMulai),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colTglBerakhir),
//          _valueLabel(_kontrak.strTglBerakhir),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colNmPicKontrak),
//          _valueLabel(_kontrak.nmPICKontrak),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colNoHpPicKontrak),
//          _valueLabel(_kontrak.noHpPICKontrak),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colEmailPicKontrak),
//          _valueLabel(_kontrak.emailPICKontrak),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colNmVendor),
//          _valueLabel(_kontrak.nmVendor),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colNmPicVendor),
//          _valueLabel(_kontrak.nmPICVendor),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colNoHpPicVendor),
//          _valueLabel(_kontrak.noHpPICVendor),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colEmailPicVendor),
//          _valueLabel(_kontrak.emailPICVendor),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colDireksi),
//          _valueLabel(_kontrak.direksi),
//        ]),
//        TableRow(children: [
//          _cellLabel(DataTableConstants.colPenandatangan),
//          _valueLabel(_kontrak.penandatangan),
//        ]),
      ],
    );
  }
}

class Expansionpanel extends StatefulWidget {
  Expansionpaneltate createState() => Expansionpaneltate();
}

class NewItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;

  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}

class Expansionpaneltate extends State<Expansionpanel> {
  List<NewItem> items = <NewItem>[
    NewItem(
        false, // isExpanded ?
        'Header', // header
        Padding(
            padding: EdgeInsets.all(20.0),
            child: LogDocumentView()), // body
        Icon(Icons.image) // iconPic
        ),
  ];

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            items[index].isExpanded = !items[index].isExpanded;
          });
        },
        children: items.map((NewItem item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                  leading: item.iconpic,
                  title: Text(
                    item.header,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ));
            },
            isExpanded: item.isExpanded,
            body: item.body,
          );
        }).toList(),
      ),
    );
  }
}

final dummykontrak =
    "{\"id\":111111111111,\"nokontrak\":\"nokontrak1\",\"namakontrak\":\"anamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"anamaunit1\",\"region\":\"region1\",\"stream\":\"st2\",\"durasi\":24,\"nilai\":1100000000,\"tglmulai\":\"1-01-2014\",\"tglberakhir\":\"1-01-2016\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"}";
