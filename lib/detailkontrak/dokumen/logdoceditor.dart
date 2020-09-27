import 'dart:convert';

//import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:listkontrakapp/detailkontrak/dokumen/blocdokeditor.dart';
import 'package:listkontrakapp/model/ConstantaApp.dart';
import 'package:listkontrakapp/model/enum_app.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:listkontrakapp/util/loadingnunggudatateko.dart';
import 'package:listkontrakapp/util/process_string.dart';
import 'package:listkontrakapp/util/util_color.dart';
import 'dart:html' as html;
import 'dart:async';

import 'package:listkontrakapp/util/validatortextfield.dart';
import 'package:loading_animations/loading_animations.dart';

class LogDocEditor extends StatefulWidget {
  final int idkontrak;
  final JenisDokumen jnsdok;
  final EnumStateEditor enumStateEditor;
  final LogDokumen logDokumen;

  LogDocEditor.baru(this.idkontrak, this.jnsdok,
      {this.enumStateEditor = EnumStateEditor.baru, this.logDokumen});

  LogDocEditor.edit(this.logDokumen,
      {this.enumStateEditor = EnumStateEditor.edit,
      this.jnsdok,
      this.idkontrak});

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
    } else {
      _blocDokumenEditor.firstimeEdit(widget.logDokumen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _blocDokumenEditor.itemdokumeneditorStream,
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.hasError) {
            return ErrorPage();
          } else if (snapshot.hasData) {
            ItemDokumenEditor itemDokumenEditor = snapshot.data;
            return Scaffold(
              body: SingleChildScrollView(
                child: LogDocEditorForm(
                    itemDokumenEditor, _title, _blocDokumenEditor),
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
  final ItemDokumenEditor itemDokumenEditor;
  final BlocDokumenEditor blocDokumenEditor;

  LogDocEditorForm(this.itemDokumenEditor, this.title, this.blocDokumenEditor);

  @override
  _LogDocEditorFormState createState() => _LogDocEditorFormState();
}

class _LogDocEditorFormState extends State<LogDocEditorForm> {
  final _keteranganTextController = TextEditingController();
  final _namaTextController = TextEditingController();
  final _versiController = TextEditingController();
  final Color colorButton = Colors.cyan[600];
  final Color colorTextBtn = Colors.white;
  final TextStyle _stylePeringatan =
      TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.red);

  List<int> _selectedFilePdf;
  List<int> _selectedFileDoc;

  DateTime _tanggal;
  double _formProgress = 0;
  ProcessString _processString;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  String _filenamepdf;
  String _filenamedoc;
  ValidatorTextField _validatorTextField;

  LogDokumen _logDokumen;

  @override
  void dispose() {
    _keteranganTextController.dispose();
    _namaTextController.dispose();
    _versiController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print(widget.itemDokumenEditor.enumStateEditor);
    _processString = new ProcessString();
    _validatorTextField = ValidatorTextField();
    this._setupInit();
    super.initState();
  }

  void _setupInit() {

    _logDokumen = widget.itemDokumenEditor.logDokumen;
    print(_logDokumen.toString());
    _tanggal = _logDokumen.tanggal;
    _keteranganTextController.text = _logDokumen.keterangan;
    _namaTextController.text = _logDokumen.namaReviewer;
    _versiController.text = '${_logDokumen.versi}';
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
              return this._controlvalidationfield(value, enumValidat);
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

  Widget _widgetLabelAndButtonVer(bool isEnable, String txtLabel, String txtBtn,
      double width, Function actionBtnClick) {
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
              onPressed: isEnable
                  ? () {
                      actionBtnClick();
                    }
                  : null, // actionBtnClick(),
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
            Wrap(
              spacing: 20.0,
              direction: Axis.horizontal,
              children: [
                _filenamepdf == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text('$_filenamepdf',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      ),
                OutlineButton(
                  onPressed: () {
                    actionBtnClick();
                  }, // actionBtnClick(),
                  child: Text(txtBtn),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetLabelTextForm(String text, TextEditingController controller) {
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

  Widget _cardDokumenBaru(double width) {
    String txtBerakhir =
        _processString.dateToStringDdMmmYyyyShort(_logDokumen.tanggal);
    double w = width / 20;
    return Container(
      width: width,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shortField('Keterangan', 5, EnumValidatorTextFieldForm.bebas,
                _keteranganTextController),
            _shortField('Nama Reviewer', 1, EnumValidatorTextFieldForm.onlyText,
                _namaTextController),
            _widgetLabelTextForm(
                'Versi ( Angka otomatis, tidak dapat di rubah )',
                _versiController),
            SizedBox(
              height: 8,
            ),
            _widgetLabelAndButtonVer(true, 'Tanggal:', txtBerakhir, w * 9, () {
              _actionBtnTglAkhirKlik(context);
            }),
            _widgetLabelAndButtonWajibVer('Dokumen PDF ', 'Browser', w * 9, () {
              _actionPickPdf(context);
            }),
            _widgetLabelAndButtonVer(true, 'Dokumen DOC:', 'Browser', w * 9,
                () {
              _actionPickDoc(context);
            }),
            _autoValidate == AutovalidateMode.onUserInteraction
                ? this._validateFilePdf()
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _cardDokumenEdit(double width) {
    String txtBerakhir =
        _processString.dateToStringDdMmmYyyyShort(_logDokumen.tanggal);
    double w = width / 20;
    return Container(
      width: width,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shortField('Keterangan', 5, EnumValidatorTextFieldForm.bebas,
                _keteranganTextController),
            _shortField('Nama Reviewer', 1, EnumValidatorTextFieldForm.onlyText,
                _namaTextController),
            _widgetLabelTextForm(
                'Versi ( Angka otomatis, tidak dapat di rubah )',
                _versiController),
            SizedBox(
              height: 8,
            ),
            _widgetLabelAndButtonVer(false, 'Tanggal:', txtBerakhir, w * 9, () {
              _actionBtnTglAkhirKlik(context);
            }),
            _widgetLabelAndButtonVer(true, 'Dokumen PDF ', 'Download', w * 9,
                () {
              _actionDownload(context, EnumFileDokumen.pdf);
            }),
            widget.itemDokumenEditor.logDokumen.extDoc == null
                ? Container()
                : _widgetLabelAndButtonVer(
                    true, 'Dokumen DOC:', 'Download', w * 9, () {
                    _actionDownload(context, EnumFileDokumen.doc);
                  }),
          ],
        ),
      ),
    );
  }

  /// untuk validasi field selain textfield (combobox dan tanggal)
  Widget _validateFilePdf() {
    /// validasi stream
    bool isDocPdfFilled = _selectedFilePdf != null;
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isDocPdfFilled
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Text('* Dokumen PDF wajib disertakan..',
                      style: _stylePeringatan),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = mediaQueryData.size.width - 120;
    double widhtCardInternal = (width / 20) * 12;
    String txtSubmit =
        widget.itemDokumenEditor.enumStateEditor == EnumStateEditor.edit
            ? 'Ubah'
            : 'Simpan';
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
            Center(
                child: widget.itemDokumenEditor.enumStateEditor ==
                        EnumStateEditor.baru
                    ? _cardDokumenBaru(widhtCardInternal)
                    : _cardDokumenEdit(widhtCardInternal)),
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
                  child: Text(txtSubmit),
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

  _startWebFilePicker(EnumFileDokumen enumFileDokumen) async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = false;
    if (enumFileDokumen == EnumFileDokumen.doc) {
      uploadInput.accept = '.docx,.doc';
    } else {
      uploadInput.accept = '.pdf';
    }

    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final List<html.File> lfile = uploadInput.files;
      final html.File file = lfile[0];

      final reader = new html.FileReader();

      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result, file);
      });
      reader.readAsDataUrl(file);
    });
  }

  void _handleResult(Object result, html.File file) {
    String tmp = file.name.split('.').last;

    if (tmp == 'pdf') {
      Uint8List _bytesData =
          Base64Decoder().convert(result.toString().split(",").last);
      _selectedFilePdf = _bytesData;
      setState(() {
        _filenamepdf = file.name;
      });
    } else if (tmp == 'doc' || tmp == 'docx') {
      Uint8List _bytesData =
          Base64Decoder().convert(result.toString().split(",").last);
      _selectedFileDoc = _bytesData;
      setState(() {
        _filenamedoc = file.name;
      });
    }
  }

  void _actionBtnTglAkhirKlik(BuildContext context) {
    _selectDate(context, false);
  }

  void _actionPickPdf(BuildContext context) {
    _startWebFilePicker(EnumFileDokumen.pdf);
  }

  void _actionPickDoc(BuildContext context) {
    _startWebFilePicker(EnumFileDokumen.doc);
  }

  _actionDownload(BuildContext context, EnumFileDokumen enumFileDokumen) {
    widget.blocDokumenEditor.downloadDokumen(
        widget.itemDokumenEditor.logDokumen.realId, enumFileDokumen);
  }

  void _textFieldOnSave() {
    _logDokumen.namaReviewer = _namaTextController.text;
    _logDokumen.keterangan = _keteranganTextController.text;
    _logDokumen.tanggal = _tanggal;
  }

  String _controlvalidationfield(
      String value, EnumValidatorTextFieldForm enumValidat) {
    if (value.length == 0) {
      return '*Field tidak boleh kosong.';
    } else {
      return _validatorTextField.validator(enumValidat, value);
    }
  }

  void _validateInputs() {
    if (widget.itemDokumenEditor.enumStateEditor == EnumStateEditor.baru) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        this._textFieldOnSave();
        this._loadingWaiting(context, 'Sedang menyimpan data.');
        if (_selectedFilePdf != null) {
          String docext = '';
          if (_selectedFileDoc != null) {
            docext = _filenamedoc.split('.').last;
          }

          widget.blocDokumenEditor
              .saveDokumen(
                  _logDokumen, _selectedFilePdf, _selectedFileDoc, docext)
              .then((value) {
            Navigator.of(context).pop();
            if (value) {
              Navigator.of(context).pop(1);
            } else {
              this._infoError(context, 'Terjadi kesalahan ...');
            }
          });
        } else {
          setState(() {
            _autoValidate = AutovalidateMode.onUserInteraction;
          });
        }
      } else {
        setState(() {
          _autoValidate = AutovalidateMode.onUserInteraction;
        });
      }
    } else {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        this._textFieldOnSave();
        this._loadingWaiting(context, 'Sedang menyimpan data.');

        widget.blocDokumenEditor.updateDokumen( _logDokumen,).then((value) {
          Navigator.of(context).pop();
          if (value) {
            Navigator.of(context).pop(1);
          } else {
            this._infoError(context, 'Terjadi kesalahan ...');
          }
        });
      } else {
        setState(() {
          _autoValidate = AutovalidateMode.onUserInteraction;
        });
      }
    }
  }

  Future _loadingWaiting(BuildContext context, String text) {
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
                LoadingBouncingLine.circle(backgroundColor: Colors.deepOrange),
              ],
            ));
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
}
