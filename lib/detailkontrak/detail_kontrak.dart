import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listkontrakapp/detailkontrak/blocdetailkontrak.dart';
import 'package:listkontrakapp/detailkontrak/dokumen/logdoc_view.dart';
import 'package:listkontrakapp/kontrakeditor/kontrakeditor.dart';
import 'package:listkontrakapp/main.dart';
import 'package:listkontrakapp/model/ConstantaApp.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:listkontrakapp/util/loadingnunggudatateko.dart';
import 'package:loading_animations/loading_animations.dart';

final double widthCell = 200.0;

class DetailKontrak extends StatefulWidget {
  final Kontrak kontrak;
  final Function callbackChangeFlagBerakhir;

  DetailKontrak(this.callbackChangeFlagBerakhir,this.kontrak);

  @override
  _DetailKontrakState createState() => _DetailKontrakState();
}

class _DetailKontrakState extends State<DetailKontrak> {
  final _scrollControllerUtama = ScrollController();
  final _scrollControllerTable = ScrollController();
  final Color colorButton = Colors.cyan[600];
  final Color colorTextBtn = Colors.white;
  BlocDetailKontrak _blocDetailKontrak;

  @override
  void initState() {
    _blocDetailKontrak = new BlocDetailKontrak();
    super.initState();
    _blocDetailKontrak.firstTime(widget.kontrak);
  }

  @override
  void dispose() {
    _blocDetailKontrak.dispose();
    _scrollControllerTable.dispose();
    _scrollControllerUtama.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _blocDetailKontrak.itemDetailkontrakStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorPage();
          } else if (snapshot.hasData) {
            ItemDetailKontrak itemDetailKontrak = snapshot.data;
            if (itemDetailKontrak.enumLoadingStateDetKon ==
                EnumLoadingStateDetKon.reload) {
              return LoadingNunggu('Sedang load data.');
            } else {
              double width = MediaQuery.of(context).size.width / 20;
              double widthtable = width * 19;
              double widhtLog = width * 16;

              Widget icon;
              if (itemDetailKontrak.kontrak.flagberakhir == 0) {
                icon = Icon(Icons.hourglass_empty_outlined);
              } else {
                icon = Icon(
                  Icons.hourglass_disabled_outlined,
                  color: Colors.red,
                );
              }
              return Scaffold(
                body: Scrollbar(
                  controller: _scrollControllerUtama,
                  isAlwaysShown: true,
                  child: SingleChildScrollView(
                    controller: _scrollControllerUtama,
                    scrollDirection: Axis.vertical,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40.0, top: 20),
                                child: FlatButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.keyboard_backspace),
                                    label: Text('Kembali')),
                              ),
                              Spacer(),
                            ],
                          ),
                          _header(),
                          Card(
                            child: Scrollbar(
                              isAlwaysShown: true,
                              controller: _scrollControllerTable,
                              child: SingleChildScrollView(
                                controller: _scrollControllerTable,
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: IconButton(
                                                  icon: icon,
                                                  onPressed: () async {
                                                    this._handleBerakhir(itemDetailKontrak.kontrak);
                                                  })),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: RaisedButton(
                                                onPressed: () {
                                                  _clickEditKontrak(
                                                      itemDetailKontrak
                                                          .kontrak);
                                                },
                                                color: Colors.cyan[600],
                                                textColor: Colors.white,
                                                child: Text('Edit'),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Table2column(widget.kontrak, widthtable),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Table5column(widget.kontrak, widthtable),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CardPICKontrak(
                                          widget.kontrak, widthtable),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      CardVendor(widget.kontrak, widthtable),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Expansionpanel(
                              widhtLog, itemDetailKontrak, _blocDetailKontrak),
                          SizedBox(
                            height: 400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return LoadingNunggu('Sedang load data.');
          }
        });
  }

  Widget _header() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
        child: Text(
          'Detail Kontrak',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
    );
  }

  void _clickEditKontrak(Kontrak kontrak) async {
    print('edit di klik');
    int result = await openPage(
        context,
        KontrakEditor.editmode(
          _callback,
          kontrak,
          isfromdetail: true,
        ));
    if ([1].contains(result)) {
      print('setelah di edit');
      _blocDetailKontrak.reloadFromInternet(null);
    }
  }

  void _handleBerakhir( Kontrak kontrak) async {
    bool isberakhir = false;
    if(kontrak.flagberakhir==1)isberakhir=true;
    await _showDialogConfirmBerakhir(context,kontrak,isberakhir);
  }

  Future _showDialogConfirmBerakhir(BuildContext context,Kontrak kontrak,bool isberakhir) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: RichText(
            text: TextSpan(
              text: 'Apakah anda yakin akan menandai kontrak  ',
              style: TextStyle(fontSize: 14,color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: kontrak.noKontrak==null?'':'${kontrak.noKontrak}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: isberakhir?' sebagai masih aktif?':' sebagai sudah berakhir?'),
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
                  int flagvalue;
                  isberakhir?flagvalue=0:flagvalue=1;
                  _confirmedBerakhir(kontrak,flagvalue);
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

  void _confirmedBerakhir(kontrak,int valueflag){
    this._loadingWaiting(context, 'Merubah status kontrak ...');
    _blocDetailKontrak.editflagberakhirKontrak(kontrak,valueflag).then((value) {
      Navigator.of(context).pop();
      if(value){
        _blocDetailKontrak.reloadDataLocal();
        widget.callbackChangeFlagBerakhir();
      }else{
        this._infoError(context, 'Terjadi kesalahan saat mengupdate data.');
      }
    });
  }

  Future _infoError(BuildContext context, String text) {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SimpleDialog(
          title: RichText(
            text: TextSpan(
              text: '$text ',
              style: TextStyle(fontSize: 14, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: '\n',
                ),
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
                },
                child: Text(
                  'Ok',
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
  void _callback(Kontrak kontrak) {
   // print('callback di detail kontrak: ${kontrak.toString()}');
  }

  Future openPage(context, Widget builder) async {
    // wait until animation finished
    await SwipeBackObserver.promise?.future;

    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => builder),
    );
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

  @override
  void initState() {
    _widthPoint = widget.width / 20;
    _kontrak = widget.kontrak;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//  Widget _valueLabel(String textLabel, String textContent) {
//    return TableCell(
//        child: LabelDetailKontrakType1(
//      textLabel: textLabel,
//      textContent: textContent,
//    ));
//  }

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
//        TableRow(children: [
//          _valueLabel('Pemenang:', _kontrak.nmVendor),
//          _valueLabel(DataTableConstants.colNmPicVendor, _kontrak.nmPICVendor),
//          _valueLabel(
//              DataTableConstants.colNoHpPicVendor, _kontrak.noHpPICVendor),
//          _valueLabel(
//              DataTableConstants.colEmailPicVendor, _kontrak.emailPICVendor)
//        ]),
        TableRow(children: [
          LabelDetailKontrakType2(textLabel: 'Pemenang:'),
          LabelDetailKontrakType2(textLabel: DataTableConstants.colNmPicVendor),
          LabelDetailKontrakType2(
              textLabel: DataTableConstants.colNoHpPicVendor),
          LabelDetailKontrakType2(
              textLabel: DataTableConstants.colEmailPicVendor)
        ]),
        TableRow(children: [
          LabelDetailKontrakType2(textContent: _kontrak.nmVendor),
          LabelDetailKontrakType2(textContent: _kontrak.nmPICVendor),
          LabelDetailKontrakType2(textContent: _kontrak.noHpPICVendor),
          LabelDetailKontrakType2(textContent: _kontrak.emailPICVendor)
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

  @override
  void initState() {
    _widthPoint = widget.width / 20;
    _kontrak = widget.kontrak;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//  Widget _valueLabel(String textLabel, String textContent) {
//    return TableCell(
//        child: LabelDetailKontrakType1(
//      textLabel: textLabel,
//      textContent: textContent,
//    ));
//  }

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
    if (_widthPoint * 5 < widthCell) {
      widthcol = _widthPoint * 5;
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
          LabelDetailKontrakType2(
              textLabel: DataTableConstants.colNmPicKontrak),
          LabelDetailKontrakType2(
              textLabel: DataTableConstants.colNoHpPicKontrak),
          LabelDetailKontrakType2(
              textLabel: DataTableConstants.colEmailPicKontrak)
        ]),
        TableRow(children: [
          LabelDetailKontrakType2(textContent: _kontrak.nmPICKontrak),
          LabelDetailKontrakType2(textContent: _kontrak.noHpPICKontrak),
          LabelDetailKontrakType2(textContent: _kontrak.emailPICKontrak)
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

  @override
  void initState() {
    _widthPoint = widget.width / 20;
    _kontrak = widget.kontrak;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//  Widget _valueLabel(String textLabel, String textContent) {
//    return TableCell(
//        child: LabelDetailKontrakType1(
//      textLabel: textLabel,
//      textContent: textContent,
//    ));
//  }
//
//  Widget _labelJudul(String textLabel) {
//    return TableCell(
//        child: LabelDetailKontrakType2(
//      textLabel: textLabel,
//    ));
//  }
//
//  Widget _labelContent(String textLabel) {
//    return TableCell(
//        child: LabelDetailKontrakType2(
//      textContent: textLabel,
//    ));
//  }

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
    if (_widthPoint * 5 < widthCell) {
      widthcol = _widthPoint * 5;
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
          LabelDetailKontrakType2(textLabel: DataTableConstants.colNmUnit),
          LabelDetailKontrakType2(textLabel: DataTableConstants.colRegion),
          LabelDetailKontrakType2(textLabel: DataTableConstants.colStream),
          LabelDetailKontrakType2(textLabel: DataTableConstants.colDurasi),
          LabelDetailKontrakType2(textLabel: DataTableConstants.colNilai),
        ]),
        TableRow(children: [
          LabelDetailKontrakType2(textContent: '${_kontrak.namaUnit}'),
          LabelDetailKontrakType2(textContent: _kontrak.region),
          LabelDetailKontrakType2(textContent: _kontrak.textStream),
          LabelDetailKontrakType2(textContent: '${_kontrak.durasi}'),
          LabelDetailKontrakType2(
              textContent: '${_kontrak.getFormatedNilai()}'),
        ]),
        _forPadding(30.0),
        TableRow(children: [
          LabelDetailKontrakType2(textLabel: DataTableConstants.colDireksi),
          LabelDetailKontrakType2(
              textLabel: DataTableConstants.colPenandatangan),
          LabelDetailKontrakType2(textLabel: DataTableConstants.colTglMulai),
          LabelDetailKontrakType2(textLabel: DataTableConstants.colTglBerakhir),
          LabelDetailKontrakType2(textLabel: 'Kontrak Awal'),
        ]),
        TableRow(children: [
          LabelDetailKontrakType2(textContent: _kontrak.direksi),
          LabelDetailKontrakType2(textContent: _kontrak.penandatangan),
          LabelDetailKontrakType2(textContent: _kontrak.strTglMulai),
          LabelDetailKontrakType2(textContent: _kontrak.strTglBerakhir),
          LabelDetailKontrakType2(textContent: 'Kosong'),
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
    _kontrak = widget.kontrak;
    super.initState();
  }

  @override
  void dispose() {
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
        child: SelectableText(text),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double widthcol1 = 130;
    if (_widthPoint * 5 < 130) {
      widthcol1 = _widthPoint * 5;
    }
    return Table(
      columnWidths: {
        0: FixedColumnWidth(widthcol1),
        1: FixedColumnWidth(_widthPoint * 10)
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

class LabelDetailKontrakType1 extends StatelessWidget {
  final String textContent;
  final String textLabel;

  LabelDetailKontrakType1({this.textLabel, this.textContent});

  final TextStyle _txtStyleLabel = const TextStyle(color: Colors.grey);
  final TextStyle _txtStyValue = new TextStyle(fontWeight: FontWeight.bold);

  Widget _cellLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        text,
        style: _txtStyleLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            child: SelectableText(
              textContent,
              style: _txtStyValue,
            )),
      ],
    );
  }
}

class LabelDetailKontrakType2 extends StatelessWidget {
  final String textContent;
  final String textLabel;

  LabelDetailKontrakType2({this.textLabel, this.textContent});

  final TextStyle _txtStyleLabel = const TextStyle(color: Colors.grey);
  final TextStyle _txtStyValue = new TextStyle(fontWeight: FontWeight.bold);

  Widget _cellLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        text,
        style: _txtStyleLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (textContent != null) {
      return TableCell(
        child: Container(
            padding: const EdgeInsets.only(left: 8.0),
            child: SelectableText(
              textContent,
              style: _txtStyValue,
            )),
      );
    } else {
      return TableCell(child: _cellLabel(textLabel));
    }
  }
}
