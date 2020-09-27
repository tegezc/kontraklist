class DataTableConstants {
  DataTableConstants._();

  static const String dtTitle = 'Daftar Seluruh Kontrak';
 // static const String users = 'List of Users (Sort by Name, ID, Email)';

  static const String colAction = 'Action';
  static const String colDetail = 'Detail';
  // COLUMNS
  static const String colNoKontrak = 'No Kontrak';
  static const String colNmKontrak = 'Nama';
  static const String colNmUnit = 'Nama Unit / AP';
  static const String colRegion = 'Region';
  static const String colStream = 'Stream';
  static const String colDurasi = 'Durasi (Bulan)';
  static const String colNilai = 'Nilai';
  static const String colTglMulai = 'Tanggal Mulai';
  static const String colTglBerakhir = 'Tanggal Berakhir';
  static const String colNmPicKontrak = 'Nama PIC Kontrak';
  static const String colNoHpPicKontrak = 'No HP PIC Kontrak';
  static const String colEmailPicKontrak = 'Email PIC Kontrak';
  static const String colNmVendor = 'Nama Vendor Pemenang';
  static const String colNmPicVendor = 'Nama PIC Vendor';
  static const String colNoHpPicVendor = 'No HP PIC Vendor';
  static const String colEmailPicVendor = 'Email PIC Vendor';
  static const String colDireksi = 'Direksi';
  static const String colPenandatangan = 'Penandatangan';
  static const String colKontrakAwal = 'Kontrak Awal';
}

class DataJSONCons{
  DataJSONCons._();
  static const String fieldId = 'id';
  static const String fieldRealId = 'realid';
  static const String fieldNoKontrak = 'nokontrak';
  static const String fieldNmKontrak = 'nama';
  static const String fieldNmUnit = 'namaunit';
  static const String fieldAnakperusahaan = 'anakperusahaan';
  static const String fieldRegion = 'region';
  static const String fieldStream = 'stream';
  static const String fieldDurasi = 'durasi';
  static const String fieldNilai = 'nilai';
  static const String fieldTglMulai = 'tanggal_mulai';
  static const String fieldTglBerakhir = 'tanggal_berakhir';
  static const String fieldNmPicKontrak = 'nm_pic_kontrak';
  static const String fieldNoHpPicKontrak = 'hp_pic_kontrak';
  static const String fieldEmailPicKontrak = 'email_pic_kontrak';
  static const String fieldNmVendor = 'vendor_pemenanga';
  static const String fieldNmPicVendor = 'nm_pic_vendor';
  static const String fieldNoHpPicVendor = 'no_pic_vendor';
  static const String fieldEmailPicVendor = 'email_pic_vendor';
  static const String fieldDireksi = 'direksi';
  static const String fieldPenandatangan = 'penandatangan';
  static const String fieldKontrakAwal = 'kontrak_awal';
//  static const String dummyjsonkontrak = "[{\"id\":111111111111,\"nokontrak\":\"nokontrak1\",\"namakontrak\":\"anamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"anamaunit1\",\"region\":\"region1\",\"stream\":\"st2\",\"durasi\":24,\"nilai\":1100000000,\"tglmulai\":\"1-01-2014\",\"tglberakhir\":\"1-01-2016\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":111111111112,\"nokontrak\":\"nokontrak2\",\"namakontrak\":\"bnamakontrak2 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"bnamaunit1\",\"region\":\"region1\",\"stream\":\"st1\",\"durasi\":24,\"nilai\":1200000000,\"tglmulai\":\"1-01-2015\",\"tglberakhir\":\"1-01-2017\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":111111111113,\"nokontrak\":\"nokontrak3\",\"namakontrak\":\"cnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"cnamaunit1\",\"region\":\"region1\",\"stream\":\"stream1\",\"durasi\":24,\"nilai\":1300000000,\"tglmulai\":\"1-01-2016\",\"tglberakhir\":\"1-01-2018\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"nokontrak1\"},{\"id\":111111111114,\"nokontrak\":\"nokontrak4\",\"namakontrak\":\"dnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"dnamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":1400000000,\"tglmulai\":\"1-01-2017\",\"tglberakhir\":\"1-01-2019\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":1111111111115,\"nokontrak\":\"nokontrak5\",\"namakontrak\":\"enamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"enamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":1500000000,\"tglmulai\":\"1-08-2019\",\"tglberakhir\":\"1-08-2021\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":1111111111116,\"nokontrak\":\"nokontrak6\",\"namakontrak\":\"fnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"fnamaunit1\",\"region\":\"region2\",\"stream\":\"st1\",\"durasi\":24,\"nilai\":1600000000,\"tglmulai\":\"1-11-2019\",\"tglberakhir\":\"1-11-2021\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":1111111111117,\"nokontrak\":\"nokontrak7\",\"namakontrak\":\"gnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"gnamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":1700000000,\"tglmulai\":\"1-01-2020\",\"tglberakhir\":\"1-01-2022\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":1111111111118,\"nokontrak\":\"nokontrak8\",\"namakontrak\":\"hnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"hnamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":1800000000,\"tglmulai\":\"1-02-2019\",\"tglberakhir\":\"1-02-2021\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"nokontrak4\"},{\"id\":1111111111119,\"nokontrak\":\"nokontrak9\",\"namakontrak\":\"inamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"inamaunit1\",\"region\":\"region5\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":1900000000,\"tglmulai\":\"1-06-2019\",\"tglberakhir\":\"1-06-2021\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":11111111111110,\"nokontrak\":\"nokontrak10\",\"namakontrak\":\"jnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"jnamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":2000000000,\"tglmulai\":\"1-09-2018\",\"tglberakhir\":\"1-09-2020\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":11111111111111,\"nokontrak\":\"nokontrak11\",\"namakontrak\":\"knamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"knamaunit1\",\"region\":\"region2\",\"stream\":\"st1\",\"durasi\":24,\"nilai\":2100000000,\"tglmulai\":\"1-01-2019\",\"tglberakhir\":\"1-01-2021\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":11111111111112,\"nokontrak\":\"nokontrak12\",\"namakontrak\":\"lnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"lnamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":2200000000,\"tglmulai\":\"1-12-2018\",\"tglberakhir\":\"1-12-2020\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":11111111111113,\"nokontrak\":\"nokontrak13\",\"namakontrak\":\"mnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"mnamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":2300000000,\"tglmulai\":\"1-11-2018\",\"tglberakhir\":\"1-11-2020\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":11111111111114,\"nokontrak\":\"nokontrak14\",\"namakontrak\":\"namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"namaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":2400000000,\"tglmulai\":\"1-02-2019\",\"tglberakhir\":\"1-02-2021\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":11111111111115,\"nokontrak\":\"nokontrak15\",\"namakontrak\":\"onamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"onamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":2500000000,\"tglmulai\":\"1-03-2019\",\"tglberakhir\":\"1-03-2021\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":11111111111126,\"nokontrak\":\"nokontrak16\",\"namakontrak\":\"pnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"pnamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":2600000000,\"tglmulai\":\"1-04-2019\",\"tglberakhir\":\"1-04-2021\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":11111111111127,\"nokontrak\":\"nokontrak17\",\"namakontrak\":\"qnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"qnamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":2700000000,\"tglmulai\":\"1-03-2019\",\"tglberakhir\":\"1-03-2021\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":11111111111128,\"nokontrak\":\"nokontrak18\",\"namakontrak\":\"rnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"rnamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":2800000000,\"tglmulai\":\"1-05-2019\",\"tglberakhir\":\"1-05-2021\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":1111111111129,\"nokontrak\":\"nokontrak19\",\"namakontrak\":\"snamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"snamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":2900000000,\"tglmulai\":\"1-06-2019\",\"tglberakhir\":\"1-06-2021\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":11111111111130,\"nokontrak\":\"nokontrak20\",\"namakontrak\":\"tnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"tnamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":24,\"nilai\":3000000000,\"tglmulai\":\"1-07-2019\",\"tglberakhir\":\"1-07-2021\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"PT PEMENANG 1\",\"nmpicvendor\":\"nmpicvendor1\",\"nohppicvendor\":\"0808080808\",\"emailpicvendor\":\"emailpicvendor1@tgz.com\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"\"},{\"id\":11111111111131,\"nokontrak\":\"\",\"namakontrak\":\"tnamakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1 namakontrak1\",\"namaunit\":\"tnamaunit1\",\"region\":\"region1\",\"stream\":\"st3\",\"durasi\":0,\"nilai\":0,\"tglmulai\":\"\",\"tglberakhir\":\"\",\"namapickontrak\":\"namapickontrak1\",\"nohppickontrak\":\"0808080808\",\"emailpickontrak\":\"emailpickontrak@tgz.com\",\"nmvendorpemenang\":\"\",\"nmpicvendor\":\"\",\"nohppicvendor\":\"\",\"emailpicvendor\":\"\",\"direksi\":\"direksi1\",\"penandatangan\":\"penandatangan1\",\"kontrakawal\":\"nokontrak20\"}]";

}

class TagJsonDok{
  TagJsonDok._();
  static const String fId = 'id';
  static const String fRealId = 'realid';
  static const String fKet = 'keterangan';
  static const String fNmReviewer = 'nama_reviewer';
  static const String fTgl = 'tanggal';
  static const String fVersi = 'versi';
  static const String fJnsDok = 'jenis_dok';
  static const String fRealIdKontrak = 'realid_kontrak';
  static const String fextDoc = 'doc';
}

class FieldJsonStream{
  static const String fieldRealId = 'realid';
  static const String fieldNama = 'nama';
}

class JenisDokumen{
  String _jenisdoc;
  JenisDokumen(this._jenisdoc);
  JenisDokumen.pe():this._jenisdoc=tagPe;
  JenisDokumen.tor():this._jenisdoc=tagTor;
  JenisDokumen.st():this._jenisdoc=tagSt;
  JenisDokumen.hps():this._jenisdoc=tagHps;
  JenisDokumen.sp():this._jenisdoc=tagSp;
  
  String get code => _jenisdoc;

  bool isPe()=>_jenisdoc==tagPe;
  bool isTor()=>_jenisdoc==tagTor;
  bool isSt()=>_jenisdoc==tagSt;
  bool isHps()=>_jenisdoc==tagHps;
  bool isSp()=>_jenisdoc==tagSp;

  static const String tagPe='pe';
  static const String tagTor='tor';
  static const String tagSt='st';
  static const String tagHps='hps';
  static const String tagSp='sp';
}
// {
// "id": "5",
// "realid": "1598883589291",
// "nokontrak": "RR20181002SS",
// "nama": "Pengadaan Laptop PT Pertamina  Indonesia",
// "namaunit": "Unit 3",
// "anakperusahaan": "PT Anak Pertamina",
// "region": "Region 1",
// "stream": "STONT",
// "durasi": "24",
// "nilai": "1400000000",
// "tanggal_mulai": "2018-10-02",
// "tanggal_berakhir": "2020-10-02",
// "nm_pic_kontrak": "Budi",
// "hp_pic_kontrak": "0818000000",
// "email_pic_kontrak": "budi@example.com",
// "vendor_pemenanga": "PT VENDOR 1",
// "nm_pic_vendor": "Ani",
// "no_pic_vendor": "0818888888",
// "email_pic_vendor": "ani@example.com",
// "direksi": "Direksi 1",
// "penandatangan": "Direktur Pertamina",
// "kontrak_awal": null
// },