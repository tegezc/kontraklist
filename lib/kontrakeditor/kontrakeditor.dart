import 'package:flutter/material.dart';
import 'package:listkontrakapp/kontrakeditor/bloc_kontrakeditor.dart';
import 'package:listkontrakapp/kontrakeditor/search_kontrak.dart';
import 'package:listkontrakapp/model/enum_app.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:listkontrakapp/util/loadingnunggudatateko.dart';
import 'package:listkontrakapp/util/process_string.dart';

class KontrakEditor extends StatefulWidget {
  final EnumStateEditor enumStateEditor;

  KontrakEditor(this.enumStateEditor);

  @override
  _KontrakEditorState createState() => _KontrakEditorState();
}

class _KontrakEditorState extends State<KontrakEditor> {
  String _title;
  BlocKontrakEditor _blocKontrakEditor;

  @override
  void initState() {
    _title = widget.enumStateEditor == EnumStateEditor.baru
        ? 'Kontrak Baru'
        : 'Edit Kontrak';
    _blocKontrakEditor = new BlocKontrakEditor();
    super.initState();
    widget.enumStateEditor == EnumStateEditor.baru
        ? _blocKontrakEditor.firstTimeNew()
        : _blocKontrakEditor.firstTimeEdit();
  }

  void dispose() {
    _blocKontrakEditor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ItemEditorKontrak>(
        stream: _blocKontrakEditor.itemkontrakeditorStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ItemEditorKontrak itemEditorKontrak = snapshot.data;
            return Scaffold(
              body: SingleChildScrollView(
                child: Stack(children: <Widget>[
                  KontrakEditorForm(_title, itemEditorKontrak,
                      _blocKontrakEditor, widget.enumStateEditor),
                  itemEditorKontrak.isModeSearch
                      ? Positioned.fill(
                          child: SearchKontrak(
                              _blocKontrakEditor, itemEditorKontrak))
                      : Container(),
                ]),
              ),
            );
          } else if (snapshot.hasError) {
            return ErrorPage();
          } else {
            return LoadingNunggu(
                'Harap menunggu, sedang mempersiapkan data...');
          }
        });
  }
}

class KontrakEditorForm extends StatefulWidget {
  final ItemEditorKontrak itemEditorKontrak;
  final String title;
  final BlocKontrakEditor blocKontrakEditor;
  final EnumStateEditor enumStateEditor;

  KontrakEditorForm(this.title, this.itemEditorKontrak, this.blocKontrakEditor,
      this.enumStateEditor);

  @override
  _KontrakEditorFormState createState() => _KontrakEditorFormState();
}

class _KontrakEditorFormState extends State<KontrakEditorForm> {
  final _noKontrakTextController = TextEditingController();
  final _namaKontrakTextController = TextEditingController();
  final _unitTextController = TextEditingController();
  final _anakPerusahaanTextController = TextEditingController();
  final _regionTextController = TextEditingController();
  final _durasiTextController = TextEditingController();
  final _nilaiKontrakTextController = TextEditingController();
  final _nmPicKontrakTextController = TextEditingController();
  final _noHpPicKontrakTextController = TextEditingController();
  final _emailPicKontrakTextController = TextEditingController();
  final _nmVendorPemenangTextController = TextEditingController();
  final _nmPicVendorTextController = TextEditingController();
  final _noHpPicVendorTextController = TextEditingController();
  final _emailPicVendorTextController = TextEditingController();
  final _direksiPekerjaanTextController = TextEditingController();
  final _penandaTanganKontrakTextController = TextEditingController();

  double _formProgress = 0;
  List<DropdownMenuItem<String>> _dropDownStream;
  String _currentStream;
  DateTime _dtMulai;
  DateTime _dtBerakhir;
  ProcessString _processString;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void dispose() {
    _noKontrakTextController.dispose();
    _namaKontrakTextController.dispose();
    _unitTextController.dispose();
    _anakPerusahaanTextController.dispose();
    _regionTextController.dispose();
    _durasiTextController.dispose();
    _nilaiKontrakTextController.dispose();
    _nmPicKontrakTextController.dispose();
    _noHpPicKontrakTextController.dispose();
    _emailPicKontrakTextController.dispose();
    _nmVendorPemenangTextController.dispose();
    _nmPicVendorTextController.dispose();
    _noHpPicVendorTextController.dispose();
    _emailPicVendorTextController.dispose();
    _direksiPekerjaanTextController.dispose();
    _penandaTanganKontrakTextController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.enumStateEditor == EnumStateEditor.baru) {
      this._initBaru();
    } else {
      this._initEditmode();
    }
    super.initState();
  }

  void _initEditmode() {}

  void _initBaru() {
    _processString = new ProcessString();
    _dropDownStream =
        _getDropDownMenuItems(widget.itemEditorKontrak.listStream);
    _currentStream = _dropDownStream[0].value;
  }

  Widget _shortField(String text, EnumValidatorTextFieldForm enumValidat,
      EnumFieldState enumFieldState, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        autovalidate: _autoValidate,
        validator: (value) {
          if (_noKontrakTextController.text.length > 0) {
            // Existing

            if (text.length == 0) {
              return '*Field tidak boleh kosong.';
            } else {
              switch (enumValidat) {
                case EnumValidatorTextFieldForm.email:
                  {
                    return _validatorEmail(value);
                  }
                  break;
                case EnumValidatorTextFieldForm.onlynumber:
                  {
                    return _validatorMustNumber(value);
                  }
                  break;
                case EnumValidatorTextFieldForm.bebas:
                  {
                    return null;
                  }
                  break;
                case EnumValidatorTextFieldForm.onlyText:
                  {
                    return _validatorOnlyText(value);
                  }
                  break;
                case EnumValidatorTextFieldForm.phoneNumber:
                  {
                    return this._validatorPhoneNumber(value);
                  }
                  break;
              }
              return null;
            }
          } else {
            // Baru
            if (enumFieldState == EnumFieldState.baru) {
              if (value.length == 0) {
                return 'Field tidak boleh kosong.';
              }
            }
            if (value.length > 0) {
              switch (enumValidat) {
                case EnumValidatorTextFieldForm.email:
                  {
                    return _validatorEmail(value);
                  }
                  break;
                case EnumValidatorTextFieldForm.onlyText:
                  {
                    return _validatorOnlyText(value);
                  }
                  break;
                case EnumValidatorTextFieldForm.onlynumber:
                  {
                    return _validatorMustNumber(value);
                  }
                  break;
                case EnumValidatorTextFieldForm.bebas:
                  {
                    return null;
                  }
                  break;
                case EnumValidatorTextFieldForm.phoneNumber:
                  {
                    return this._validatorPhoneNumber(value);
                  }
                  break;
              }
            }

            return null;
          }
        },
        maxLines: null,
        controller: controller,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(
            fontSize: 12,
            color: Colors.blue,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _widgetLabelAndButtonVer(
      String txtLabel, String txtBtn, double width, Function actionBtnClick) {
    return Container(
      //    color: Colors.red,
      //    height: 120,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(txtLabel),
          SizedBox(
            height: 8,
          ),
          OutlineButton(
            onPressed: () {
              actionBtnClick();
            }, // actionBtnClick(),
            child: Text(txtBtn),
          ),
        ],
      ),
    );
  }

  Widget _widgetLabelAndButtonVerWithTooltip(String txtLabel, String txtBtn,
      String txtTooltip, double width, Function actionBtnClick) {
    return Container(
      //   color: Colors.red,
      //   height: 110,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              Text(txtLabel),
              Tooltip(
                padding: EdgeInsets.all(8.0),
                message: txtTooltip,
                verticalOffset: 10,
                height: 15,
                child: Icon(
                  Icons.help_outline,
                  size: 18,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          OutlineButton(
            onPressed: actionBtnClick,
            child: Text(txtBtn),
          ),
        ],
      ),
    );
  }

  Widget _cardInternalPerusahaan(double width, Kontrak kontrakawal) {
    String txtMulai = _dtMulai == null
        ? 'Belum ditentkan'
        : _processString.dateToStringDdMmmYyyyShort(_dtMulai);
    String txtBerakhir = _dtBerakhir == null
        ? 'Belum ditentukan'
        : _processString.dateToStringDdMmmYyyyShort(_dtBerakhir);
    double w = width / 20;
    String strkontrakawal =
        kontrakawal == null ? 'Buat link' : kontrakawal.noKontrak;
    return Container(
      width: width,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shortField('Nomor Kontrak:', EnumValidatorTextFieldForm.bebas,
                EnumFieldState.edit, _noKontrakTextController),
            _shortField('Nama Kontrak:', EnumValidatorTextFieldForm.bebas,
                EnumFieldState.baru, _namaKontrakTextController),
            _shortField('Nama Unit / AP:', EnumValidatorTextFieldForm.bebas,
                EnumFieldState.baru, _unitTextController),
            _shortField('Anak Perusahaan:', EnumValidatorTextFieldForm.bebas,
                EnumFieldState.baru, _anakPerusahaanTextController),
            Wrap(
              direction: Axis.horizontal,
//              alignment: WrapAlignment.start,
//              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                SizedBox(
                    width: w * 4,
                    child: _shortField(
                        'Durasi (Bulan):',
                        EnumValidatorTextFieldForm.onlynumber,
                        EnumFieldState.baru,
                        _durasiTextController)),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: w * 6,
                    child: _shortField(
                        'Region:',
                        EnumValidatorTextFieldForm.bebas,
                        EnumFieldState.baru,
                        _regionTextController)),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 40.0, right: 24, left: 20),
                  child: Text(
                    'Stream:',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: new DropdownButton(
                    value: _currentStream,
                    items: _dropDownStream,
                    onChanged: changedDropDownItem,
                  ),
                ),
              ],
            ),
            _shortField('Nilai Kontrak:', EnumValidatorTextFieldForm.onlynumber,
                EnumFieldState.edit, _nilaiKontrakTextController),
            _shortField('Direksi Pekerjaan:', EnumValidatorTextFieldForm.bebas,
                EnumFieldState.edit, _direksiPekerjaanTextController),
            _shortField(
                'Penanda Tangan Kontrak:',
                EnumValidatorTextFieldForm.bebas,
                EnumFieldState.edit,
                _penandaTanganKontrakTextController),
            Wrap(
              direction: Axis.horizontal,
              spacing: 20,
              children: [
                _widgetLabelAndButtonVer('Tanggal Mulai:', txtMulai, w * 5, () {
                  _actionBtnTglAwalKlik(context);
                }),
                _widgetLabelAndButtonVer(
                    'Tanggal Berakhir:', txtBerakhir, w * 5, () {
                  _actionBtnTglAkhirKlik(context);
                }),
                _widgetLabelAndButtonVerWithTooltip(
                    'Kontrak Awal ',
                    strkontrakawal,
                    'Jika kontrak termasuk amandemen,\nsebaiknya buat link ke kontrak awal.',
                    w * 7,
                    _actionLinkKontrakKlik),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardPICKontrak(double width) {
    return SizedBox(
      width: width,
      child: Card(
        child: Column(
          children: [
            _shortField(
                'Nama PIC Kontrak:',
                EnumValidatorTextFieldForm.onlyText,
                EnumFieldState.edit,
                _nmPicKontrakTextController),
            _shortField(
                'No HP PIC Kontrak:',
                EnumValidatorTextFieldForm.phoneNumber,
                EnumFieldState.edit,
                _noHpPicKontrakTextController),
            _shortField('Email PIC Kontrak:', EnumValidatorTextFieldForm.email,
                EnumFieldState.edit, _emailPicKontrakTextController),
          ],
        ),
      ),
    );
  }

  Widget _cardPICVendor(double width) {
    return SizedBox(
      width: width,
      child: Card(
        child: Column(
          children: [
            _shortField(
                'Nama Vendor Pemenang:',
                EnumValidatorTextFieldForm.bebas,
                EnumFieldState.edit,
                _nmVendorPemenangTextController),
            _shortField('Nama PIC Vendor:', EnumValidatorTextFieldForm.onlyText,
                EnumFieldState.edit, _nmPicVendorTextController),
            _shortField(
                'No HP PIC Vendor:',
                EnumValidatorTextFieldForm.phoneNumber,
                EnumFieldState.edit,
                _noHpPicVendorTextController),
            _shortField('Email PIC Vendor:', EnumValidatorTextFieldForm.email,
                EnumFieldState.edit, _emailPicVendorTextController),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getDropDownMenuItems(
      List<StreamKontrak> lstream) {
    List<DropdownMenuItem<String>> items = new List();
    StreamKontrak sk = new StreamKontrak('000', 'Pilih Stream');
    items.add(new DropdownMenuItem(
        value: sk.realId,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(sk.nama),
        )));
    for (StreamKontrak stream in lstream) {
      items.add(new DropdownMenuItem(
          value: stream.realId,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(stream.nama),
          )));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = mediaQueryData.size.width - 120;
    double widhtCardInternal = (width / 20) * 12;
    double widthPIC = (width / 20) * 8;
    String strbuttonsubmit = widget.enumStateEditor==EnumStateEditor.baru?'Simpan':'Edit';
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
            Wrap(
              direction: Axis.horizontal,
              children: [
                _cardInternalPerusahaan(
                    widhtCardInternal, widget.itemEditorKontrak.kontrakAwal),
                Column(
                  children: [
                    _cardPICKontrak(widthPIC),
                    SizedBox(
                      height: 20.0,
                    ),
                    _cardPICVendor(widthPIC),
                  ],
                )
              ],
            ),
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
                  child: Text(strbuttonsubmit),
                ),
                SizedBox(
                  width: 50.0,
                ),
                RaisedButton(
                  color: Colors.cyan[600],
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
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

  void changedDropDownItem(String selectedStream) {
    setState(() {
      _currentStream = selectedStream;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isMulai) async {
    DateTime initialDate;
    if (isMulai) {
      initialDate = _dtMulai;
    } else {
      initialDate = _dtBerakhir;
    }
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(initialDate.year - 5, 1),
        lastDate: DateTime(initialDate.year + 5, 1));
    if (picked != null) {
      if (isMulai) {
        _dtMulai = picked;
      } else {
        _dtBerakhir = picked;
      }
      setState(() {});
    }
  }

  /// value tidak boleh null / kosong
  String _validatorEmail(value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
        .hasMatch(value);
    if (emailValid) {
      return null;
    } else {
      return 'Email tidak valid.';
    }
  }

  /// value tidak boleh null / kosong
  String _validatorMustNumber(String value) {
    int val = int.tryParse(value);
    if (val == null) {
      return '* Harus berupa angka positif.';
    } else {
      if (val < 0) {
        return '* Harus berupa angka positif.';
      }
    }

    return null;
  }

  /// value tidak boleh null / kosong
  String _validatorOnlyText(String value) {
    bool emailValid = RegExp(r"^[a-zA-Z ]*$").hasMatch(value);
    if (emailValid) {
      return null;
    } else {
      return 'Harus text';
    }
  }

  /// value tidak boleh null / kosong
  String _validatorPhoneNumber(String value) {
    if (value.length <= 15) {
      bool phoneNumberValid =
          RegExp(r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$")
              .hasMatch(value);
      if (phoneNumberValid) {
        return null;
      } else {
        return 'Nomor kontak tidak valid.';
      }
    } else {
      return 'Nomor kontak tidak valid.';
    }
  }

  void _actionBtnTglAwalKlik(BuildContext context) {
    _selectDate(context, true);
  }

  void _actionBtnTglAkhirKlik(BuildContext context) {
    _selectDate(context, false);
  }

  void _actionLinkKontrakKlik() {
    widget.blocKontrakEditor.showSearch();
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
