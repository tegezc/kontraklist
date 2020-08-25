import 'package:flutter/material.dart';
import 'package:listkontrakapp/model/kontrak.dart';

class Expansionpanel extends StatefulWidget {
  final double width;

  Expansionpanel(this.width);

  _Expansionpaneltate createState() => _Expansionpaneltate();
}

class NewItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;

  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}

class _Expansionpaneltate extends State<Expansionpanel> {
  List<NewItem> _items;

  @override
  void initState() {
    _items = <NewItem>[
      NewItem(
          false, // isExpanded ?
          'PE - Paket Enginering', // header
          Padding(
              padding: EdgeInsets.all(20.0),
              child: LogDokView(null, widget.width)), // body
          null // iconPic
          ),
      NewItem(
          false, // isExpanded ?
          'TOR - Term Of Reference', // header
          Padding(
              padding: EdgeInsets.all(20.0),
              child: LogDokView(null, widget.width)), // body
          null // iconPic
      ),
      NewItem(
          false, // isExpanded ?
          'Spec Teknis', // header
          Padding(
              padding: EdgeInsets.all(20.0),
              child: LogDokView(null, widget.width)), // body
          null // iconPic
      ),
      NewItem(
          false, // isExpanded ?
          'OE / HPS', // header
          Padding(
              padding: EdgeInsets.all(20.0),
              child: LogDokView(null, widget.width)), // body
          null // iconPic
      ),
      NewItem(
          false, // isExpanded ?
          'SP - Surat Perjanjian', // header
          Padding(
              padding: EdgeInsets.all(20.0),
              child: LogDokView(null, widget.width)), // body
          null // iconPic
      )
    ];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          _items[index].isExpanded = !_items[index].isExpanded;
          print('isexpanded: ${_items[index].isExpanded}');
          setState(() {});
        },
        children: _items.map((NewItem item) {
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

class LogDokView extends StatefulWidget {
  final List<LogDokumen> ldoc;
  final double width;

  LogDokView(this.ldoc, this.width);

  @override
  _LogDokViewState createState() => _LogDokViewState();
}

class _LogDokViewState extends State<LogDokView> {
  List<LogDokumen> ldocument;
  final TextStyle _styleHeader = new TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() {
    if (widget.ldoc == null) {
      ldocument = LogDokumen.getDummyLog();
      print(ldocument.length.toString());
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _valueLabelType2(String textContent) {
    return TableCell(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectableText(
              textContent
            ),
          ),
        ));
  }

  Widget _valueLabelType1(String textContent) {
    return TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectableText(
              textContent
          ),
        ));
  }

  Widget _cellHeader(String textContent) {
    return TableCell(
        child: Container(
          height: 40,
          child: Align(
            alignment: Alignment.center,
            child: Text(
      textContent,
      style: _styleHeader,
    ),
          ),
        ));
  }

//  TableRow _forPadding(double height) {
//    return TableRow(children: [
//      TableCell(
//        child: SizedBox(
//          height: height,
//        ),
//      ),
//      TableCell(
//        child: SizedBox(
//          height: height,
//        ),
//      ),
//      TableCell(
//        child: SizedBox(
//          height: height,
//        ),
//      ),
//      TableCell(
//        child: SizedBox(
//          height: height,
//        ),
//      ),
//      TableCell(
//        child: SizedBox(
//          height: height,
//        ),
//      ),
//      TableCell(
//        child: SizedBox(
//          height: height,
//        ),
//      ),
//    ]);
//  }

  TableRow _forHeader() {
    return TableRow(children: [
      _cellHeader(''),
      _cellHeader('Keterangan'),
      _cellHeader('Nama Reviewer'),
      _cellHeader('Tanggal'),
      _cellHeader('Versi'),
      _cellHeader('Dokumen'),
    ]);
  }

  List<TableRow> _setupContentTable(List<LogDokumen> llog) {
    List<TableRow> ltr = new List();
    ltr.add(_forHeader());
    llog.forEach((element) {
      ltr.add(TableRow(children: [
        TableCell(
            child: IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () {},
        )),
        _valueLabelType1(element.keterangan),
        _valueLabelType1(element.namaReviewer),
        _valueLabelType2(element.strTanggal),
        _valueLabelType2(element.versi.toString()),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                OutlinedButton(onPressed: () {  }, child: Text('view PDF'),),
                OutlinedButton(onPressed: () {  }, child: Text('view Doc'),),
              ],
            ),
          ),
        ),
      ]));
    });
    return ltr;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(50.0),
          1: FixedColumnWidth(300.0),
          2: FixedColumnWidth(250.0),
          3: FixedColumnWidth(150.0),
          4: FixedColumnWidth(50),
          5: FixedColumnWidth(150.0),
        },
        border: TableBorder.all(
            color: Colors.black26, width: 1, style: BorderStyle.solid),
        children: _setupContentTable(ldocument),
      ),
    );
  }
}
