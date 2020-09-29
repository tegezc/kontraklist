import 'package:flutter/material.dart';
import 'package:listkontrakapp/kontrakeditor/bloc_kontrakeditor.dart';
import 'package:listkontrakapp/kontrakeditor/search_kontrak.dart';
import 'package:listkontrakapp/model/enum_app.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:listkontrakapp/util/loadingnunggudatateko.dart';
import 'package:listkontrakapp/util/process_string.dart';
import 'package:listkontrakapp/util/validatortextfield.dart';
import 'package:loading_animations/loading_animations.dart';

class KontrakEditor extends StatefulWidget {
  final EnumStateEditor enumStateEditor;
  final Kontrak kontrak;
  final Function callbackFinish;
  final bool isfromdetail;

  KontrakEditor.baru(this.callbackFinish,
      {this.enumStateEditor = EnumStateEditor.baru, this.kontrak,this.isfromdetail=false});

  KontrakEditor.editmode(this.callbackFinish, this.kontrak,
      {this.enumStateEditor = EnumStateEditor.edit,this.isfromdetail=false});

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

  void _callbackFinish(Kontrak kontrak) {
    widget.callbackFinish(kontrak);
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
                  KontrakEditorForm(
                    _callbackFinish,
                    _title,
                    itemEditorKontrak,
                    _blocKontrakEditor,
                    widget.enumStateEditor,
                    kontrak: widget.kontrak,
                    isFromdetail: widget.isfromdetail,
                  ),
                  itemEditorKontrak.isModeSearch
                      ? Positioned.fill(
                          child: SearchKontrak(
                              _blocKontrakEditor, itemEditorKontrak))
                      : Container(),
                  // itemEditorKontrak.isMenyimpan?Positioned.fill(child: LoadingMenyimpan(itemEditorKontrak.textLoading)):Container(),
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
  final Kontrak kontrak; //jika edit mode, tidak boleh null
  final Function callbackFinish;
  final bool isFromdetail;

  KontrakEditorForm(this.callbackFinish, this.title, this.itemEditorKontrak,
      this.blocKontrakEditor, this.enumStateEditor,
      {this.kontrak,this.isFromdetail});

  @override
  _KontrakEditorFormState createState() => _KontrakEditorFormState();
}

class _KontrakEditorFormState extends State<KontrakEditorForm> {
  static const defaultCodeStream = '000';
  final TextStyle _stylePeringatan =
      TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.red);

  final Color colorButton = Colors.cyan[600];
  final Color colorTextBtn = Colors.white;

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
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  Kontrak _resultKontrak;
  Kontrak _kontrakAwal;

  ValidatorTextField _validatorTextField;

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
    _processString = new ProcessString();
    _validatorTextField = ValidatorTextField();
    if (widget.enumStateEditor == EnumStateEditor.baru) {
      this._initBaru();
    } else {
      this._initEditmode(widget.kontrak);
    }
    super.initState();
  }

  void _initEditmode(Kontrak kontrak) {
    _resultKontrak = kontrak;

    _dropDownStream =
        _getDropDownMenuItems(widget.itemEditorKontrak.listStream);
    _currentStream = kontrak.stream;

    _dtMulai = kontrak.tglMulai;
    _dtBerakhir = kontrak.tglBerakhir;
    _noKontrakTextController.text = kontrak.noKontrak;
    _namaKontrakTextController.text = kontrak.nama;
    _unitTextController.text = kontrak.namaUnit;
    _anakPerusahaanTextController.text = kontrak.anakPerusahaan;
    _regionTextController.text = kontrak.region;
    _durasiTextController.text = '${kontrak.durasi}';
    _nilaiKontrakTextController.text = '${kontrak.nilai}';
    _nmPicKontrakTextController.text = kontrak.nmPICKontrak;
    _noHpPicKontrakTextController.text = kontrak.noHpPICKontrak;
    _emailPicKontrakTextController.text = kontrak.emailPICKontrak;
    _nmVendorPemenangTextController.text = kontrak.nmVendor;
    _nmPicVendorTextController.text = kontrak.nmPICVendor;
    _noHpPicVendorTextController.text = kontrak.noHpPICVendor;
    _emailPicVendorTextController.text = kontrak.emailPICVendor;
    _direksiPekerjaanTextController.text = kontrak.direksi;
    _penandaTanganKontrakTextController.text = kontrak.penandatangan;
  }

  void _initBaru() {
    _resultKontrak = new Kontrak.kosong();

    _dropDownStream =
        _getDropDownMenuItems(widget.itemEditorKontrak.listStream);
    _currentStream = _dropDownStream[0].value;
    _testOnly();
  }

  void _testOnly() {
    _currentStream = _dropDownStream[1].value;
    _dtMulai = DateTime.now();
    _dtBerakhir = DateTime(_dtMulai.year + 2, _dtMulai.month, _dtMulai.day);
    _noKontrakTextController.text = 'RR20200101SS';
    _namaKontrakTextController.text = 'Pengadaan Aplikasi';
    _unitTextController.text = 'Unit 1';
    _anakPerusahaanTextController.text = 'PT Anak Nusantara';
    _regionTextController.text = 'Region 1';
    _durasiTextController.text = '24';
    _nilaiKontrakTextController.text = '1000000000';
    _nmPicKontrakTextController.text = 'Dermawan';
    _noHpPicKontrakTextController.text = '081767876545';
    _emailPicKontrakTextController.text = 'coba@coooo.com';
    _nmVendorPemenangTextController.text = 'PT Vendor';
    _nmPicVendorTextController.text = 'Asep';
    _noHpPicVendorTextController.text = '081804378767';
    _emailPicVendorTextController.text = 'coba@coba.com';
    _direksiPekerjaanTextController.text = 'Direktur';
    _penandaTanganKontrakTextController.text = 'Direktur';
  }

  Widget _shortField(
      String text,
      EnumValidatorTextFieldForm enumValidat,
      EnumFieldState enumFieldState,
      TextEditingController controller,
      int tag) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        autovalidateMode: _autoValidate,
        onSaved: (str) {
          _saveValueField(tag, str);
        },
        validator: (value) {
          return _controlvalidationfield(value, enumFieldState, enumValidat);
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
            _shortField(
                'Nomor Kontrak:',
                EnumValidatorTextFieldForm.bebas,
                EnumFieldState.existing,
                _noKontrakTextController,
                tagnokontrak),
            _shortField('Nama Kontrak:', EnumValidatorTextFieldForm.bebas,
                EnumFieldState.draft, _namaKontrakTextController, tagnama),
            _shortField('Nama Unit / AP:', EnumValidatorTextFieldForm.bebas,
                EnumFieldState.draft, _unitTextController, tagnamaunit),
            _shortField(
                'Anak Perusahaan:',
                EnumValidatorTextFieldForm.bebas,
                EnumFieldState.draft,
                _anakPerusahaanTextController,
                taganakperusahaan),
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
                        EnumFieldState.draft,
                        _durasiTextController,
                        tagdurasi)),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: w * 6,
                    child: _shortField(
                        'Region:',
                        EnumValidatorTextFieldForm.bebas,
                        EnumFieldState.draft,
                        _regionTextController,
                        tagregion)),
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
                EnumFieldState.existing, _nilaiKontrakTextController, tagnilai),
            _shortField(
                'Direksi Pekerjaan:',
                EnumValidatorTextFieldForm.bebas,
                EnumFieldState.existing,
                _direksiPekerjaanTextController,
                tagdireksi),
            _shortField(
                'Penanda Tangan Kontrak:',
                EnumValidatorTextFieldForm.bebas,
                EnumFieldState.existing,
                _penandaTanganKontrakTextController,
                tagpenandatangan),
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
            _autoValidate == AutovalidateMode.onUserInteraction
                ? _validationOtherField()
                : Container(),
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
                EnumFieldState.existing,
                _nmPicKontrakTextController,
                tagnmpickontrak),
            _shortField(
                'No HP PIC Kontrak:',
                EnumValidatorTextFieldForm.phoneNumber,
                EnumFieldState.existing,
                _noHpPicKontrakTextController,
                tagnopickontrak),
            _shortField(
                'Email PIC Kontrak:',
                EnumValidatorTextFieldForm.email,
                EnumFieldState.existing,
                _emailPicKontrakTextController,
                tagemailpickontrak),
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
                EnumFieldState.existing,
                _nmVendorPemenangTextController,
                tagvendor),
            _shortField(
                'Nama PIC Vendor:',
                EnumValidatorTextFieldForm.onlyText,
                EnumFieldState.existing,
                _nmPicVendorTextController,
                tagpicvendor),
            _shortField(
                'No HP PIC Vendor:',
                EnumValidatorTextFieldForm.phoneNumber,
                EnumFieldState.existing,
                _noHpPicVendorTextController,
                tagnopicvendor),
            _shortField(
                'Email PIC Vendor:',
                EnumValidatorTextFieldForm.email,
                EnumFieldState.existing,
                _emailPicVendorTextController,
                tagemailpicvendor),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getDropDownMenuItems(
      List<StreamKontrak> lstream) {
    List<DropdownMenuItem<String>> items = new List();
    StreamKontrak sk = new StreamKontrak(defaultCodeStream, 'Pilih Stream');
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

  bool _validasiStream() {
    return _currentStream != defaultCodeStream;
  }

  bool _validasiTanggal() {
    bool isTglValid = false;
    if (_noKontrakTextController.text.length > 0) {
      // existing
      if (_dtMulai != null && _dtBerakhir != null) {
        isTglValid = _dtMulai.isBefore(_dtBerakhir);
      }
    } else {
      // draft
      isTglValid = true;
      if (_dtMulai != null && _dtBerakhir != null) {
        isTglValid = _dtMulai.isBefore(_dtBerakhir);
      }
    }
    return isTglValid;
  }

  /// untuk validasi field selain textfield (combobox dan tanggal)
  Widget _validationOtherField() {
    /// validasi tanggal
    bool isTglValid = this._validasiTanggal();

    /// validasi stream
    bool isStreamValid = this._validasiStream();
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isTglValid
              ? Container()
              : Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8),
                  child: Text('* Tanggal awal harus sebelum tanggal berakhir',
                      style: _stylePeringatan),
                ),
          isStreamValid
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Text('* Pilih salah satu stream.',
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
    double widhtCardInternal = (width / 20) * 11;
    double widthPIC = (width / 20) * 7;
    String strbuttonsubmit =
        widget.enumStateEditor == EnumStateEditor.baru ? 'Simpan' : 'Edit';
    _kontrakAwal = widget.itemEditorKontrak.kontrakAwal;
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
      initialDate = _dtMulai == null ? DateTime.now() : _dtMulai;
    } else {
      DateTime tmp = DateTime.now();
      initialDate = _dtBerakhir == null
          ? DateTime(tmp.year + 2, tmp.month, tmp.day)
          : _dtBerakhir;
    }
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(initialDate.year - 10, 1),
        lastDate: DateTime(initialDate.year + 10, 1));
    if (picked != null) {
      if (isMulai) {
        _dtMulai = picked;
      } else {
        _dtBerakhir = picked;
      }
      setState(() {});
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

  String _controlvalidationfield(String value, EnumFieldState enumFieldState,
      EnumValidatorTextFieldForm enumValidat) {
    if (_noKontrakTextController.text.length > 0) {
      // Existing

      if (value.length == 0) {
        return '*Field tidak boleh kosong.';
      } else {
        return _validatorTextField.validator(enumValidat, value);
      }
    } else {
      // Baru
      if (enumFieldState == EnumFieldState.draft) {
        if (value.length == 0) {
          return 'Field tidak boleh kosong.';
        }
      }
      if (value.length > 0) {
        return _validatorTextField.validator(enumValidat, value);
      }

      return null;
    }
  }

  // TAG FIELD
  static const tagnokontrak = 1;
  static const tagnama = 2;
  static const tagnamaunit = 3;
  static const taganakperusahaan = 4;
  static const tagregion = 5;
  static const tagdurasi = 7;
  static const tagnilai = 8;
  static const tagnmpickontrak = 11;
  static const tagnopickontrak = 12;
  static const tagemailpickontrak = 13;
  static const tagvendor = 14;
  static const tagpicvendor = 15;
  static const tagnopicvendor = 16;
  static const tagemailpicvendor = 17;
  static const tagdireksi = 18;
  static const tagpenandatangan = 19;

  void _saveValueField(int tag, String str) {
    switch (tag) {
      case tagnokontrak:
        {
          _resultKontrak.setnoKontrak(str);
        }
        break;
      case tagnama:
        {
          _resultKontrak.setnama(str);
        }
        break;
      case tagnamaunit:
        {
          _resultKontrak.setnamaUnit(str);
        }
        break;
      case taganakperusahaan:
        {
          _resultKontrak.setanakPerusahaan(str);
        }
        break;
      case tagregion:
        {
          _resultKontrak.setregion(str);
        }
        break;
      case tagdurasi:
        {
          _resultKontrak.setdurasiString(str);
        }
        break;
      case tagnilai:
        {
          _resultKontrak.setnilaiString(str);
        }
        break;
      case tagnmpickontrak:
        {
          _resultKontrak.setnmPICKontrak(str);
        }
        break;
      case tagnopickontrak:
        {
          _resultKontrak.setnoHpPICKontrak(str);
        }
        break;
      case tagemailpickontrak:
        {
          _resultKontrak.setemailPICKontrak(str);
        }
        break;
      case tagvendor:
        {
          _resultKontrak.setnmVendor(str);
        }
        break;
      case tagpicvendor:
        {
          _resultKontrak.setnmPICVendor(str);
        }
        break;
      case tagnopicvendor:
        {
          _resultKontrak.setnoHpPICVendor(str);
        }
        break;
      case tagemailpicvendor:
        {
          _resultKontrak.setemailPICVendor(str);
        }
        break;
      case tagdireksi:
        {
          _resultKontrak.setdireksi(str);
        }
        break;
      case tagpenandatangan:
        {
          _resultKontrak.setpenandatangan(str);
        }
        break;
    }
  }

  void _setValueOtherField() {
    _resultKontrak.settglMulai(_dtMulai);
    _resultKontrak.settglBerakhir(_dtBerakhir);
    String kodeKontrakAwal = _kontrakAwal == null ? '' : _kontrakAwal.noKontrak;
    _resultKontrak.setkontrakAwal(kodeKontrakAwal);
    _resultKontrak.setstream(_currentStream);
  }

  void _validateInputs() async {
    if (this._validasiTanggal() &&
        this._validasiStream() &&
        _formKey.currentState.validate()) {
      _formKey.currentState.save();
      _setValueOtherField();
      if (widget.enumStateEditor == EnumStateEditor.baru) {
        this._loadingWaiting(context, 'Sedang proses menyimpan data.');
        widget.blocKontrakEditor.saveKontrak(_resultKontrak).then((k) {
          Navigator.of(context).pop();
          if (k != null) {
            widget.callbackFinish(k);
          } else {
            this._infoError(
                context, 'Terjadi kesalahan saat proses menyimpan data.');
          }
        });
      } else {
        this._loadingWaiting(context, 'Sedang proses edit data.');

        widget.blocKontrakEditor.editKontrak(_resultKontrak).then((k) {
          Navigator.of(context).pop();

          if (k != null) {
            if(widget.isFromdetail){
              Navigator.of(context).pop(1);
            }else{
              widget.callbackFinish(k);
            }

          } else {
            this._infoError(
                context, 'Terjadi kesalahan saat proses edit data.');
          }
        });
      }


    } else {
      setState(() {
        _autoValidate = AutovalidateMode.onUserInteraction;
      });
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
