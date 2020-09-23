import 'package:flutter/material.dart';
import 'package:listkontrakapp/detailkontrak/dokumen/blocdokeditor.dart';
import 'package:listkontrakapp/model/enum_app.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:listkontrakapp/util/loadingnunggudatateko.dart';
import 'package:listkontrakapp/util/process_string.dart';
import 'package:listkontrakapp/util/util_color.dart';

class LogDocEditor extends StatefulWidget {
  final int idkontrak;
  final String jnsdok;
  final EnumStateEditor enumStateEditor;

  LogDocEditor.baru(this.idkontrak, this.jnsdok,
      {this.enumStateEditor = EnumStateEditor.baru});

  LogDocEditor.edit(this.idkontrak, this.jnsdok,
      {this.enumStateEditor = EnumStateEditor.edit});

  @override
  _LogDocEditorState createState() => _LogDocEditorState();
}

class _LogDocEditorState extends State<LogDocEditor> {
  String _title;
  BlocDokumenEditor _blocDokumenEditor;

  @override
  void initState() {
    _blocDokumenEditor = new BlocDokumenEditor();
    widget.enumStateEditor == EnumStateEditor.baru
        ? _title = 'Dokumen Baru'
        : _title = 'Edit Dokumen';
    super.initState();
    setupFirstime();
  }

  void setupFirstime() {
    if (widget.enumStateEditor == EnumStateEditor.baru) {
      _blocDokumenEditor.firstimeBaru(widget.idkontrak, widget.jnsdok);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _blocDokumenEditor.itemdokumeneditorStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorPage();
          } else if (snapshot.hasData) {
            ItemDokumenEditor itemDokumenEditor = snapshot.data;
            return Scaffold(
//      appBar: AppBar(
//        title:Text(_title),
//        backgroundColor: Colors.cyan,
//      ),
              body: SingleChildScrollView(
                child: LogDocEditorForm(itemDokumenEditor.logDokumen,_title),
              ),
            );
          } else {
            return LoadingNunggu('Mohon tunggu...');
          }
        });
  }
}

class LogDocEditorForm extends StatefulWidget {
  final String title;
  final LogDokumen logDokumen;

  LogDocEditorForm(this.logDokumen, this.title);

  @override
  _LogDocEditorFormState createState() => _LogDocEditorFormState();
}

class _LogDocEditorFormState extends State<LogDocEditorForm> {
  final _keteranganTextController = TextEditingController();
  final _namaTextController = TextEditingController();
  final _versiController = TextEditingController();

  DateTime _tanggal;
  double _formProgress = 0;
  ProcessString _processString;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  @override
  void dispose() {
    _keteranganTextController.dispose();
    _namaTextController.dispose();
    _versiController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _processString = new ProcessString();
    this._setupInit();
    super.initState();
  }
  
  void _setupInit(){
    _tanggal = widget.logDokumen.tanggal;
    _keteranganTextController.text = widget.logDokumen.keterangan;
    _namaTextController.text = widget.logDokumen.namaReviewer;
    _versiController.text = '${widget.logDokumen.versi}';
  }

  Widget _shortField(
      String text,
      int maxline,
      EnumValidatorTextFieldForm enumValidat,
      TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            autovalidateMode: _autoValidate,
            validator: (value) {
              switch (enumValidat) {
                case EnumValidatorTextFieldForm.email:
                  {
                    return null;
                  }
                  break;
                case EnumValidatorTextFieldForm.phoneNumber:
                  {
                    return _validatorNoEmpty(value);
                  }
                  break;
                case EnumValidatorTextFieldForm.onlynumber:
                  {
                    return null;
                  }
                  break;
                case EnumValidatorTextFieldForm.bebas:
                  {
                    return null;
                  }
                  break;
                case EnumValidatorTextFieldForm.onlyText:
                  {
                    return null;
                  }
                  break;
              }
              return null;
            },
            maxLines: maxline,
            controller: controller,
            decoration: InputDecoration(
              hintText: text,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetLabelAndButtonVer(
      String txtLabel, String txtBtn, double width, Function actionBtnClick) {
    return Container(
      //    color: Colors.red,
      //    height: 120,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              txtLabel,
              style: TextStyle(color: HexColor('5a5a5a')),
            ),
            OutlineButton(
              onPressed: () {
                actionBtnClick();
              }, // actionBtnClick(),
              child: Text(txtBtn),
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetLabelAndButtonWajibVer(
      String txtLabel, String txtBtn, double width, Function actionBtnClick) {
    return Container(
      //    color: Colors.red,
      //    height: 120,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: txtLabel,
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: ' ( * Wajib )',
                      style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            OutlineButton(
              onPressed: () {
                actionBtnClick();
              }, // actionBtnClick(),
              child: Text(txtBtn),
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetLabelTextForm(
      String text, TextEditingController controller) {
   // controller.text = '$ver';
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            width: 40,
            child: TextFormField(
              enabled: false,
              controller: controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardInternalPerusahaan(double width) {
    String txtBerakhir = _processString.dateToStringDdMmmYyyyShort(widget.logDokumen.tanggal);
    double w = width / 20;
    return Container(
      width: width,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shortField('Keterangan', 5, EnumValidatorTextFieldForm.bebas,
                _keteranganTextController),
            _shortField('Nama Reviewer', 1, EnumValidatorTextFieldForm.bebas,
                _namaTextController),
            _widgetLabelTextForm(
                'Versi ( Angka otomatis, tidak dapat di rubah )',
                _versiController),
            SizedBox(
              height: 8,
            ),
            _widgetLabelAndButtonVer('Tanggal:', txtBerakhir, w * 9, () {
              _actionBtnTglAkhirKlik(context);
            }),
            _widgetLabelAndButtonWajibVer('Dokumen PDF ', 'Browser', w * 9, () {
              _actionBtnTglAkhirKlik(context);
            }),
            _widgetLabelAndButtonVer('Dokumen DOC:', 'Browser', w * 9, () {
              _actionBtnTglAkhirKlik(context);
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = mediaQueryData.size.width - 120;
    double widhtCardInternal = (width / 20) * 12;
    return Padding(
      padding: const EdgeInsets.only(left: 60.0, right: 60.0),
      child: Form(
        key: _formKey,
        child: Column(
          //  mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: _formProgress),
            Container(
              child: FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.keyboard_backspace),
                  label: Text('Kembali')),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 12.0),
                child: Text(widget.title,
                    style: Theme.of(context).textTheme.headline4),
              ),
            ),
            Center(child: _cardInternalPerusahaan(widhtCardInternal)),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Colors.cyan[600],
                  textColor: Colors.white,
                  onPressed: () {
                    _validateInputs();
                  },
                  child: Text('Simpan'),
                ),
                SizedBox(
                  width: 50.0,
                ),
                RaisedButton(
                  color: Colors.cyan[600],
                  textColor: Colors.white,
                  onPressed: () {},
                  child: Text('Batal'),
                ),
              ],
            ),
            SizedBox(
              height: 300,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isMulai) async {
    DateTime initialDate;

    initialDate = _tanggal;

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(initialDate.year - 5, 1),
        lastDate: DateTime(initialDate.year + 5, 1));
    if (picked != null) {
      _tanggal = picked;

      setState(() {});
    }
  }

  String _validatorNoEmpty(String value) {
    if (value.isEmpty) {
      return 'Field tidak boleh kosong.';
    }
    return null;
  }

  void _actionBtnTglAkhirKlik(BuildContext context) {
    _selectDate(context, false);
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = AutovalidateMode.onUserInteraction;
      });
    }
  }
}