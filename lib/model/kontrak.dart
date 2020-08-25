import 'package:flutter/cupertino.dart';
import 'package:listkontrakapp/model/ConstantaApp.dart';
import 'package:listkontrakapp/util/process_string.dart';

class Kontrak {
  int realID;
  String _noKontrak;
  String _nama;
  String _namaUnit;
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
    DateTime dtmulai =
        _processString.dateFromTextToDateTime(json[DataJSONCons.fieldTglMulai]);
    DateTime dtberakhir = _processString
        .dateFromTextToDateTime(json[DataJSONCons.fieldTglBerakhir]);
    this.realID = json[DataJSONCons.fieldRealId];
    this._noKontrak = json[DataJSONCons.fieldNoKontrak];
    this._nama = json[DataJSONCons.fieldNmKontrak];
    this._namaUnit = json[DataJSONCons.fieldNmUnit];
    this._region = json[DataJSONCons.fieldRegion];
    this._stream = json[DataJSONCons.fieldStream];
    this._durasi = json[DataJSONCons.fieldDurasi];
    this._nilai = json[DataJSONCons.fieldNilai];
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

  String get strTglMulai =>
      _processString.dateToStringDdMmmYyyyShort(_tglMulai);

  String get strTglBerakhir =>
      _processString.dateToStringDdMmmYyyyShort(_tglBerakhir);

  Map toJson() {
    return {
      DataJSONCons.fieldRealId: realID,
      DataJSONCons.fieldNoKontrak: _noKontrak,
      DataJSONCons.fieldNmKontrak: _nama,
      DataJSONCons.fieldNmUnit: _namaUnit,
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
}

class LogDokumen {
  String namaReviewer;
  String keterangan;
  DateTime tanggal;
  int versi;
  String linkPdf;
  String linkDoc;

  LogDokumen(
      {@required this.namaReviewer,
      @required this.keterangan,
      @required this.tanggal,
      @required this.versi,
      @required this.linkPdf,
      this.linkDoc});

  String get strTanggal{
    ProcessString processString = new ProcessString();
    return processString.dateToStringDdMmmmYyyy(tanggal);
  }

  static List<LogDokumen> getDummyLog() {
    return <LogDokumen>[
      LogDokumen(
        namaReviewer: "Captain America",
        keterangan: "Shield",
        tanggal: DateTime.now(),
        versi: 1,
        linkPdf: 'link ke pdf',
        linkDoc: 'linkkedoc',
      ),  LogDokumen(
        namaReviewer: "Captain America",
        keterangan: "Shield",
        tanggal: DateTime.now(),
        versi: 2,
        linkPdf: 'link ke pdf',
        linkDoc: 'linkkedoc',
      ),  LogDokumen(
        namaReviewer: "Captain America",
        keterangan: "Shield",
        tanggal: DateTime.now(),
        versi: 3,
        linkPdf: 'link ke pdf',
        linkDoc: 'linkkedoc',
      ),  LogDokumen(
        namaReviewer: "Captain America",
        keterangan: "Shield",
        tanggal: DateTime.now(),
        versi: 4,
        linkPdf: 'link ke pdf',
        linkDoc: 'linkkedoc',
      )
    ];
  }
}
