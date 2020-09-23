import 'package:flutter/cupertino.dart';
import 'package:listkontrakapp/model/ConstantaApp.dart';
import 'package:listkontrakapp/util/process_string.dart';

class Kontrak {
  int realID;
  String _noKontrak;
  String _nama;
  String _namaUnit;
  String _anakPerusahaan;
  String _region;
  String _stream;
  int _durasi;
  int _nilai;
  DateTime _tglMulai;
  DateTime _tglBerakhir;
  String _nmPICKontrak;
  String _noHpPICKontrak;
  String _emailPICKontrak;
  String _nmVendor;
  String _nmPICVendor;
  String _noHpPICVendor;
  String _emailPICVendor;
  String _direksi;
  String _penandatangan;
  String _kontrakAwal;

  Kontrak.kosong();

  Kontrak(this._noKontrak, this._nama, this._tglBerakhir);

//  Kontrak._(this.realID,
//      this._noKontrak,
//      this._nama,
//      this._namaUnit,
//      this._region,
//      this._stream,
//      this._durasi,
//      this._nilai,
//      this._tglMulai,
//      this._tglBerakhir,
//      this._nmPICKontrak,
//      this._noHpPICKontrak,
//      this._emailPICKontrak,
//      this._nmVendor,
//      this._nmPICVendor,
//      this._noHpPICVendor,
//      this._emailPICVendor,
//      this._direksi,
//      this._penandatangan,
//      this._kontrakAwal);

  Kontrak.fromJson(Map<String, dynamic> json) {
    DateTime dtmulai = json[DataJSONCons.fieldTglMulai] == null
        ? null
        : _processString
            .dateFromTextToDateTime(json[DataJSONCons.fieldTglMulai]);
    DateTime dtberakhir = json[DataJSONCons.fieldTglBerakhir] == null
        ? null
        : _processString
            .dateFromTextToDateTime(json[DataJSONCons.fieldTglBerakhir]);
    int realid = int.parse(json[DataJSONCons.fieldRealId]);
    int nilai = json[DataJSONCons.fieldNilai] == null
        ? 0
        : int.parse(json[DataJSONCons.fieldNilai]);
    int durasi = json[DataJSONCons.fieldDurasi] == null
        ? 0
        : int.parse(json[DataJSONCons.fieldDurasi]);

    this.realID = realid;
    this._noKontrak = json[DataJSONCons.fieldNoKontrak];
    this._nama = json[DataJSONCons.fieldNmKontrak];
    this._namaUnit = json[DataJSONCons.fieldNmUnit];
    this._anakPerusahaan = json[DataJSONCons.fieldAnakperusahaan];
    this._region = json[DataJSONCons.fieldRegion];
    this._stream = json[DataJSONCons.fieldStream];
    this._durasi = durasi;
    this._nilai = nilai;
    this._tglMulai = dtmulai;
    this._tglBerakhir = dtberakhir;
    this._nmPICKontrak = json[DataJSONCons.fieldNmPicKontrak];
    this._noHpPICKontrak = json[DataJSONCons.fieldNoHpPicKontrak];
    this._emailPICKontrak = json[DataJSONCons.fieldEmailPicKontrak];
    this._nmVendor = json[DataJSONCons.fieldNmVendor];
    this._nmPICVendor = json[DataJSONCons.fieldNmPicVendor];
    this._noHpPICVendor = json[DataJSONCons.fieldNoHpPicVendor];
    this._emailPICVendor = json[DataJSONCons.fieldEmailPicVendor];
    this._direksi = json[DataJSONCons.fieldDireksi];
    this._penandatangan = json[DataJSONCons.fieldPenandatangan];
    this._kontrakAwal = json[DataJSONCons.fieldKontrakAwal];
  }

  ProcessString _processString = new ProcessString();

  String get noKontrak => _noKontrak;

  String get nama => _nama;

  String get namaUnit => _namaUnit;

  String get anakPerusahaan => _anakPerusahaan;

  String get region => _region;

  String get stream => _stream;

  int get durasi => _durasi;

  int get nilai => _nilai;

  DateTime get tglMulai => _tglMulai;

  DateTime get tglBerakhir => _tglBerakhir;

  String get nmPICKontrak => _nmPICKontrak;

  String get noHpPICKontrak => _noHpPICKontrak;

  String get emailPICKontrak => _emailPICKontrak;

  String get nmVendor => _nmVendor;

  String get nmPICVendor => _nmPICVendor;

  String get noHpPICVendor => _noHpPICVendor;

  String get emailPICVendor => _emailPICVendor;

  String get direksi => _direksi;

  String get penandatangan => _penandatangan;

  String get kontrakAwal => _kontrakAwal;

  void setnoKontrak(String value) {
    _noKontrak = value;
  }

  void setnama(String value) {
    _nama = value;
  }

  void setnamaUnit(String value) {
    _namaUnit = value;
  }

  void setanakPerusahaan(String value) {
    _anakPerusahaan = value;
  }

  void setregion(String value) {
    _region = value;
  }

  void setstream(String value) {
    _stream = value;
  }

  void setdurasiString(String value) {
    try {
      _durasi = int.parse(value);
    } catch (e) {
      throw (e);
    }
  }

  void setnilaiString(String value) {
    try {
      _nilai = int.parse(value);
    } catch (e) {
      throw (e);
    }
  }

  void setdurasi(int value) {
    _durasi = value;
  }

  void setnilai(int value) {
    _nilai = value;
  }

  void settglMulai(DateTime value) {
    _tglMulai = value;
  }

  void settglBerakhir(DateTime value) {
    _tglBerakhir = value;
  }

  void setnmPICKontrak(String value) {
    _nmPICKontrak = value;
  }

  void setnoHpPICKontrak(String value) {
    _noHpPICKontrak = value;
  }

  void setemailPICKontrak(String value) {
    _emailPICKontrak = value;
  }

  void setnmVendor(String value) {
    _nmVendor = value;
  }

  void setnmPICVendor(String value) {
    _nmPICVendor = value;
  }

  void setnoHpPICVendor(String value) {
    _noHpPICVendor = value;
  }

  void setemailPICVendor(String value) {
    _emailPICVendor = value;
  }

  void setdireksi(String value) {
    _direksi = value;
  }

  void setpenandatangan(String value) {
    _penandatangan = value;
  }

  void setkontrakAwal(String value) {
    _kontrakAwal = value;
  }

  String get strTglMulai {
    return _tglMulai == null
        ? ''
        : _processString.dateToStringDdMmmYyyyShort(_tglMulai);
  }

  String get strTglBerakhir {
    return _tglBerakhir == null
        ? ''
        : _processString.dateToStringDdMmmYyyyShort(_tglBerakhir);
  }

  Map toJson() {
    return {
      DataJSONCons.fieldRealId: realID,
      DataJSONCons.fieldNoKontrak: _noKontrak,
      DataJSONCons.fieldNmKontrak: _nama,
      DataJSONCons.fieldNmUnit: _namaUnit,
      DataJSONCons.fieldAnakperusahaan: _anakPerusahaan,
      DataJSONCons.fieldRegion: _region,
      DataJSONCons.fieldStream: _stream,
      DataJSONCons.fieldDurasi: _durasi,
      DataJSONCons.fieldNilai: _nilai,
      DataJSONCons.fieldTglMulai:
          _processString.dateToStringDdMmYyyy(_tglMulai),
      DataJSONCons.fieldTglBerakhir:
          _processString.dateToStringDdMmYyyy(_tglBerakhir),
      DataJSONCons.fieldNmPicKontrak: _nmPICKontrak,
      DataJSONCons.fieldNoHpPicKontrak: _noHpPICKontrak,
      DataJSONCons.fieldEmailPicKontrak: _emailPICKontrak,
      DataJSONCons.fieldNmVendor: _nmVendor,
      DataJSONCons.fieldNmPicVendor: _nmPICVendor,
      DataJSONCons.fieldNoHpPicVendor: _noHpPICVendor,
      DataJSONCons.fieldEmailPicVendor: _emailPICVendor,
      DataJSONCons.fieldDireksi: _direksi,
      DataJSONCons.fieldPenandatangan: _penandatangan,
      DataJSONCons.fieldKontrakAwal: _kontrakAwal
    };
  }

  String toContentCsv() {
    return '$_noKontrak;$_nama;$_namaUnit;$_anakPerusahaan;$_region;$_durasi;$_nilai;$_stream'
        ';$_tglMulai;$_tglBerakhir;$_nmPICKontrak;$_noHpPICKontrak;$_emailPICKontrak;$_nmVendor'
        ';$_nmPICVendor;$_noHpPICVendor;$_emailPICVendor;$_direksi;$_penandatangan;$_kontrakAwal';
  }

  String toString() {
    return '$_noKontrak|$_nama|$_namaUnit|$_anakPerusahaan|$_region|$_durasi|$_nilai|$_stream'
        '|$_tglMulai|$_tglBerakhir|$_nmPICKontrak|$_noHpPICKontrak|$_emailPICKontrak|$_nmVendor'
        '|$_nmPICVendor|$_noHpPICVendor|$_emailPICVendor|$_direksi|$_penandatangan|$_kontrakAwal';
  }
}

class LogDokumen {
  int id;
  int realId;
  String namaReviewer;
  String keterangan;
  DateTime tanggal;
  int versi;
  String jnsDoc;
  int realIdKontrak;
  String linkPdf;
  String linkDoc;

  LogDokumen(
      {@required this.namaReviewer,
      @required this.keterangan,
      @required this.tanggal,
      @required this.versi,
      @required this.linkPdf,
      this.linkDoc});

  LogDokumen.fromJson(Map<String, dynamic> json) {
    ProcessString processString = new ProcessString();
    this.id = int.parse(json[TagJsonDok.fId]);
    this.realId = int.parse(json[TagJsonDok.fRealId]);
    this.keterangan = json[TagJsonDok.fKet];
    this.namaReviewer = json[TagJsonDok.fId];
    this.tanggal = json[TagJsonDok.fTgl] == null
        ? null
        : processString.dateFromLongString(json[TagJsonDok.fTgl]);
    this.versi = int.parse(json[TagJsonDok.fVersi]);
    this.jnsDoc = json[TagJsonDok.fJnsDok];
    this.realIdKontrak = int.parse(json[TagJsonDok.fRealIdKontrak]);
    this.linkPdf = json[TagJsonDok.fLinkPdf];
    this.linkDoc = json[TagJsonDok.fLinkDoc];
  }

  String get strTanggal {
    ProcessString processString = new ProcessString();
    return processString.dateToStringDdMmmmYyyy(tanggal);
  }

  // static List<LogDokumen> getDummyLog() {
  //   return <LogDokumen>[
  //     LogDokumen(
  //       namaReviewer: "Captain America",
  //       keterangan: "Shield",
  //       tanggal: DateTime.now(),
  //       versi: 1,
  //       linkPdf: 'link ke pdf',
  //       linkDoc: 'linkkedoc',
  //     ),
  //     LogDokumen(
  //       namaReviewer: "Captain America",
  //       keterangan: "Shield",
  //       tanggal: DateTime.now(),
  //       versi: 2,
  //       linkPdf: 'link ke pdf',
  //       linkDoc: 'linkkedoc',
  //     ),
  //     LogDokumen(
  //       namaReviewer: "Captain America",
  //       keterangan: "Shield",
  //       tanggal: DateTime.now(),
  //       versi: 3,
  //       linkPdf: 'link ke pdf',
  //       linkDoc: 'linkkedoc',
  //     ),
  //     LogDokumen(
  //       namaReviewer: "Captain America",
  //       keterangan: "Shield",
  //       tanggal: DateTime.now(),
  //       versi: 4,
  //       linkPdf: 'link ke pdf',
  //       linkDoc: 'linkkedoc',
  //     )
  //   ];
  // }
}

class StreamKontrak {
  String realId;
  String nama;

  StreamKontrak(this.realId, this.nama);

  StreamKontrak.fromJson(Map<String, dynamic> json) {
    this.realId = json[FieldJsonStream.fieldRealId];
    this.nama = json[FieldJsonStream.fieldNama];
  }
}
