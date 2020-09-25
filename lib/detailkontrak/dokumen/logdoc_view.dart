import 'package:flutter/material.dart';
import 'package:listkontrakapp/detailkontrak/blocdetailkontrak.dart';
import 'package:listkontrakapp/detailkontrak/dokumen/logdoceditor.dart';
import 'package:listkontrakapp/main.dart';
import 'package:listkontrakapp/model/ConstantaApp.dart';
import 'package:listkontrakapp/model/enum_app.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:listkontrakapp/util/loadingnunggudatateko.dart';
import 'package:loading_animations/loading_animations.dart';

class Expansionpanel extends StatefulWidget {
  final double width;
  final ItemDetailKontrak itemDetailKontrak;

  Expansionpanel(this.width, this.itemDetailKontrak);

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
  ItemDetailKontrak _itemDetailKontrak;

  @override
  void initState() {
    _itemDetailKontrak = widget.itemDetailKontrak;

    _items = <NewItem>[
      NewItem(
          false, // isExpanded ?
          'PE - Paket Enginering', // header
          Padding(
              padding: EdgeInsets.all(20.0),
              child: LogDokView(_itemDetailKontrak.kontrak.realID,JenisDokumen.tagPe,_itemDetailKontrak.lpe, widget.width)), // body
          null // iconPic
      ),
      NewItem(
          false, // isExpanded ?
          'TOR - Term Of Reference', // header
          Padding(
              padding: EdgeInsets.all(20.0),
              child: LogDokView(_itemDetailKontrak.kontrak.realID,JenisDokumen.tagTor,_itemDetailKontrak.ltor, widget.width)), // body
          null // iconPic
      ),
      NewItem(
          false, // isExpanded ?
          'Spec Teknis', // header
          Padding(
              padding: EdgeInsets.all(20.0),
              child: LogDokView(_itemDetailKontrak.kontrak.realID,JenisDokumen.tagSt,_itemDetailKontrak.lst, widget.width)), // body
          null // iconPic
      ),
      NewItem(
          false, // isExpanded ?
          'OE / HPS', // header
          Padding(
              padding: EdgeInsets.all(20.0),
              child: LogDokView(_itemDetailKontrak.kontrak.realID,JenisDokumen.tagHps,_itemDetailKontrak.lhps, widget.width)), // body
          null // iconPic
      ),
      NewItem(
          false, // isExpanded ?
          'SP - Surat Perjanjian', // header
          Padding(
              padding: EdgeInsets.all(20.0),
              child: LogDokView(_itemDetailKontrak.kontrak.realID,JenisDokumen.tagSp,_itemDetailKontrak.lsp, widget.width)), // body
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
  final int idkontrak;
  final String jnsdok;
  final List<LogDokumen> ldoc;
  final double width;

  LogDokView(this.idkontrak,this.jnsdok,this.ldoc, this.width);

  @override
  _LogDokViewState createState() => _LogDokViewState();
}

class _LogDokViewState extends State<LogDokView> {
  List<LogDokumen> _ldocument;
  final TextStyle _styleHeader = new TextStyle(fontWeight: FontWeight.bold);
  final Color colorButton = Colors.cyan[600];
  final Color colorTextBtn = Colors.white;
  @override
  void initState() {
    _ldocument = widget.ldoc;
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
            child: SelectableText(textContent),
          ),
        ));
  }

  Widget _valueLabelType1(String textContent) {
    return TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectableText(textContent),
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
              onPressed: () {
                this._handleDeleteDokumen(element);
              },
            )),
        TableCell(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                this._handleEditDocumen(element);
              },
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
                OutlineButton(
                  onPressed: () {
                    this._handleViewDoc(EnumFileDokumen.pdf, element);
                  },
                  child: Text('view PDF'),
                ),
                OutlineButton(
                  onPressed: () {
                    this._handleViewDoc(EnumFileDokumen.doc,element);
                  },
                  child: Text('view Doc'),
                ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RaisedButton(
            child: Text('Tambah Log Dokumen'),
            color: Colors.cyan[600],
            textColor: Colors.white,
            onPressed: () {
              _handleDokumenBaru(widget.idkontrak,widget.jnsdok);
            },
          ),
          _ldocument.isNotEmpty
              ? Table(
            columnWidths: {
              0: FixedColumnWidth(50.0),
              1: FixedColumnWidth(50.0),
              2: FixedColumnWidth(300.0),
              3: FixedColumnWidth(250.0),
              4: FixedColumnWidth(150.0),
              5: FixedColumnWidth(50),
              6: FixedColumnWidth(150.0),
            },
            border: TableBorder.all(
                color: Colors.black26,
                width: 1,
                style: BorderStyle.solid),
            children: _setupContentTable(_ldocument),
          )
              : BelumAdaDataContainer(),
        ],
      ),
    );
  }
  
  void _handleEditDocumen(LogDokumen logDokumen){}
  
  void _handleDeleteDokumen(LogDokumen logDokumen)async{
    await _showDialogConfirmDelete(context,logDokumen);
  }

  void _handleViewDoc(EnumFileDokumen fileDokumen, LogDokumen kontrak) {}

  void _handleDokumenBaru(int idkontrak,String jnsdok) async {
    await openPage(context, LogDocEditor.baru(idkontrak, jnsdok));
  }

  Future _showDialogConfirmDelete(BuildContext context,LogDokumen logDokumen) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: RichText(
            text: TextSpan(
              text: 'Apakah anda yakin akan menghapus Dokumen? ',
              style: TextStyle(fontSize: 14,color: Colors.black),
              children: <TextSpan>[
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
                  _confirmedDelete(logDokumen);
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

  void _confirmedDelete(LogDokumen logDokumen){
   // this._loadingWaiting(context, 'Sedang menghapus data...');

  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
  }
}

