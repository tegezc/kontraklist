import 'package:flutter/material.dart';
import 'package:listkontrakapp/enum_app.dart';
import 'package:listkontrakapp/util/process_string.dart';

class KontrakEditor extends StatefulWidget {
  final EnumStateEditor enumStateEditor;

  KontrakEditor(this.enumStateEditor);

  @override
  _KontrakEditorState createState() => _KontrakEditorState();
}

class _KontrakEditorState extends State<KontrakEditor> {
  String _title;

  @override
  void initState() {
    _title = widget.enumStateEditor == EnumStateEditor.baru
        ? 'Kontrak Baru'
        : 'Edit Kontrak';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title:Text(_title),
//        backgroundColor: Colors.cyan,
//      ),
      body: SingleChildScrollView(
        child: KontrakEditorForm(_title),
      ),
    );
  }
}

class KontrakEditorForm extends StatefulWidget {
  final String title;

  KontrakEditorForm(this.title);

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
  List _streams = ["Stream1", "Stream2", "Stream3", "Stream4"];
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
    _dtMulai = DateTime.now();
    _dtBerakhir = DateTime.now();
    _processString = new ProcessString();
    _dropDownStream = getDropDownMenuItems();
    _currentStream = _dropDownStream[0].value;
    super.initState();
  }

  Widget _shortField(String text, EnumValidatorTextFieldForm enumValidat,
      TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        autovalidate: _autoValidate,
        validator: (value) {
          switch (enumValidat) {
            case EnumValidatorTextFieldForm.email:
              {
                return _validatorEmail(value);
              }
              break;
            case EnumValidatorTextFieldForm.noEmpty:
              {
                return _validatorNoEmpty(value);
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
          }
          return null;
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
            onPressed:(){
              actionBtnClick();
            },// actionBtnClick(),
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

  Widget _cardInternalPerusahaan(double width) {
    String txtMulai = _processString.dateToStringDdMmmYyyyShort(_dtMulai);
    String txtBerakhir = _processString.dateToStringDdMmmYyyyShort(_dtBerakhir);
    double w = width / 20;
    return Container(
      width: width,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shortField('Nomor Kontrak:', EnumValidatorTextFieldForm.bebas,
                _noKontrakTextController),
            _shortField('Nama Kontrak:', EnumValidatorTextFieldForm.noEmpty,
                _namaKontrakTextController),
            _shortField('Nama Unit / AP:', EnumValidatorTextFieldForm.bebas,
                _unitTextController),
            _shortField('Anak Perusahaan:', EnumValidatorTextFieldForm.bebas,
                _anakPerusahaanTextController),
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
                        _durasiTextController)),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: w * 6,
                    child: _shortField(
                        'Region:',
                        EnumValidatorTextFieldForm.bebas,
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
                _nilaiKontrakTextController),
            _shortField('Direksi Pekerjaan:', EnumValidatorTextFieldForm.bebas,
                _direksiPekerjaanTextController),
            _shortField(
                'Penanda Tangan Kontrak:',
                EnumValidatorTextFieldForm.bebas,
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
                    'Buat link',
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
            _shortField('Nama PIC Kontrak:', EnumValidatorTextFieldForm.bebas,
                _nmPicKontrakTextController),
            _shortField('No HP PIC Kontrak:', EnumValidatorTextFieldForm.bebas,
                _noHpPicKontrakTextController),
            _shortField('Email PIC Kontrak:', EnumValidatorTextFieldForm.bebas,
                _emailPicKontrakTextController),
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
                _nmVendorPemenangTextController),
            _shortField('Nama PIC Vendor:', EnumValidatorTextFieldForm.bebas,
                _nmPicVendorTextController),
            _shortField('No HP PIC Vendor:', EnumValidatorTextFieldForm.bebas,
                _noHpPicVendorTextController),
            _shortField('Email PIC Vendor:', EnumValidatorTextFieldForm.bebas,
                _emailPicVendorTextController),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String stream in _streams) {
      items.add(new DropdownMenuItem(value: stream, child: new Text(stream)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = mediaQueryData.size.width - 120;
    double widhtCardInternal = (width / 20) * 12;
    double widthPIC = (width / 20) * 8;
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
              child: FlatButton.icon(onPressed: (){
                Navigator.of(context).pop();
              }, icon: Icon(Icons.keyboard_backspace), label: Text('Kemabli')),
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
                _cardInternalPerusahaan(widhtCardInternal),
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
            SizedBox(height: 30,),
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
                  onPressed: () {

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

  String _validatorEmail(value) {
    if (value.isEmpty) {
      return 'Tidak boleh kosong.';
    } else {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
          .hasMatch(value);
      if (emailValid) {
        return null;
      } else {
        return 'Email tidak valid.';
      }
    }
  }

  String _validatorNoEmpty(String value) {
    if (value.isEmpty) {
      return 'Field tidak boleh kosong.';
    }
    return null;
  }

  String _validatorMustNumber(String value) {
    if (value.isEmpty) {
      return 'Field tidak boleh kosong.';
    } else {
      int val = int.tryParse(value);
      if (val == null) {
        return '* Harus berupa angka positif.';
      } else {
        if (val < 0) {
          return '* Harus berupa angka positif.';
        }
      }
    }
    return null;
  }

  void _actionBtnTglAwalKlik(BuildContext context) {
    _selectDate(context, true);
  }

  void _actionBtnTglAkhirKlik(BuildContext context) {
    _selectDate(context, false);
  }

  void _actionLinkKontrakKlik() {}

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
