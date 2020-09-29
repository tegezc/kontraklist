import 'package:listkontrakapp/model/enum_app.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:rxdart/subjects.dart';

import 'package:listkontrakapp/http/http_controller.dart';

class BlocShowAll {
  List<Kontrak> _cacheAllListKontrak;
  List<Kontrak> _listKontrak;
  List<StreamKontrak> _cacheStream;

  // int _cacheIndexsort;
  // bool _cacheAsc;

  BlocShowAll() {
    _cacheAllListKontrak = List();
    _cacheStream = List();
  }

  int _currentType;
  int _currentStream;
  List<String> _types = ["Semua", "Draft", "Existing", "Amandemen", "Berakhir"];

  final PublishSubject<ItemShowAll> _itemShowAll =
      PublishSubject<ItemShowAll>();

  Sink<ItemShowAll> get itemkontrakeditorSink => _itemShowAll.sink;

  Stream<ItemShowAll> get itemkontrakeditorStream => _itemShowAll.stream;

  Future<ItemShowAll> firstTime() async {
    _currentStream = 0;
    _currentType = 0;
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response = await httpAction.getAllKontrak();
    if (response != null) {
      List<dynamic> ldk = response['kontrak'];
      List<dynamic> lds = response['stream'];

      ldk.forEach((element) {
        Kontrak k = Kontrak.fromJson(element);
        _cacheAllListKontrak.add(k);
      });
      _cacheStream.add(StreamKontrak('000', 'Semua'));
      lds.forEach((element) {
        StreamKontrak stream = StreamKontrak.fromJson(element);
        _cacheStream.add(stream);
      });
      _listKontrak = _cacheAllListKontrak;
      ItemShowAll itemShowAll = new ItemShowAll(_cacheStream, _types,
          _listKontrak, EStateShowall.finish, _currentStream, _currentType);
      return itemShowAll;
    }
    ItemShowAll itemShowAll = new ItemShowAll(_cacheStream, _types,
        _listKontrak, EStateShowall.error, _currentStream, _currentType);
    return itemShowAll;
  }

  Future<void> reloadFromInternet() async {
    if (_cacheAllListKontrak != null) {
      _cacheAllListKontrak.clear();
    }
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response = await httpAction.getAllKontrak();
    if (response != null) {
      List<dynamic> ldk = response['kontrak'];

      ldk.forEach((element) {
        Kontrak k = Kontrak.fromJson(element);
        _cacheAllListKontrak.add(k);
      });

      this.filter();
    }
  }

  void reloadData() {
    this.filter();
    ItemShowAll itemShowAll = new ItemShowAll(_cacheStream, _types,
        _listKontrak, EStateShowall.finish, _currentStream, _currentType);
    this.itemkontrakeditorSink.add(itemShowAll);
  }

  void filter() {
    _listKontrak = _cacheAllListKontrak;
    List<Kontrak> listHasilFilter;
    if (_currentStream != 0) {
      StreamKontrak streamKontrak = _cacheStream[_currentStream];
      listHasilFilter = _cacheAllListKontrak
          .where((kontrak) => kontrak.stream
              .toLowerCase()
              .contains(streamKontrak.realId.toLowerCase()))
          .toList();

      _listKontrak = listHasilFilter;
    }

    /// Type Kontrak
    /// 0 : semua
    /// 1: Draft
    /// 2: Existing
    /// 3: Amandemen
    /// 4: Berakhir

    if (_currentType == 4) {
      listHasilFilter =
          _listKontrak.where((kontrak) => kontrak.flagberakhir == 1).toList();

      _listKontrak = listHasilFilter;
    } else {
      /// initial list hanya ambil yang tidak termasuk berakhir
      listHasilFilter =
          _listKontrak.where((kontrak) => kontrak.flagberakhir == 0).toList();

      _listKontrak = listHasilFilter;

      ///========================
      if (_currentType == 1) {
        listHasilFilter =
            _listKontrak.where((kontrak) => kontrak.noKontrak == null).toList();

        _listKontrak = listHasilFilter;
      } else if (_currentType == 2) {
        listHasilFilter = _listKontrak.where((kontrak) {
          if (kontrak.noKontrak != null) {
            return kontrak.noKontrak.length > 0;
          } else {
            return false;
          }
        }).toList();

        _listKontrak = listHasilFilter;
      } else if (_currentType == 3) {
        listHasilFilter = _listKontrak.where((kontrak) {
          if (kontrak.kontrakAwal != null) {
            return kontrak.kontrakAwal.length > 0;
          }
          return false;
        }).toList();

        _listKontrak = listHasilFilter;
      }
    }

    if (_listKontrak == null) {
      _listKontrak = List();
    }
    ItemShowAll itemShowAll = new ItemShowAll(_cacheStream, _types,
        _listKontrak, EStateShowall.finish, _currentStream, _currentType);
    this.itemkontrakeditorSink.add(itemShowAll);
  }

  Future<LogDokumen> checkSp(int idkontrak) async {
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response = await httpAction.checkSp(idkontrak);
    if (response == null) return null;
    List<dynamic> lsp = response['sp'];
    if (lsp.isNotEmpty) {
      return LogDokumen.fromJson(lsp[0]);
    }
    return null;
  }

  Future<bool> downloadDokumen(
      int iddokumen, EnumFileDokumen enumFileDokumen) async {
    HttpAction httpAction = new HttpAction();

    return await httpAction.downloadDoc(iddokumen, enumFileDokumen);
  }

  void downloadCsv() async {
    String contentCsv = '';
    _listKontrak.forEach((element) {
      contentCsv = contentCsv + element.toContentCsv() + '\n';
    });
    String filename = '';
    if (_currentStream != 0) {
      StreamKontrak sk = _cacheStream[_currentStream];
      filename = filename + sk.realId + '_';
    } else {
      filename = filename + 'all_';
    }

    if (_currentType == 0) {
      filename = filename + 'all';
    } else if (_currentType == 1) {
      filename = filename + 'draft';
    } else if (_currentType == 2) {
      filename = filename + 'existing';
    } else if (_currentType == 3) {
      filename = filename + 'amandemen';
    }
    HttpAction httpAction = new HttpAction();
    httpAction.downloadCsv(contentCsv, filename);
  }

  void setSortIndex(int index, bool asc) {
    ItemShowAll itemShowAll = new ItemShowAll(_cacheStream, _types,
        _listKontrak, EStateShowall.finish, _currentStream, _currentType);
    itemShowAll.asc = asc;
    itemShowAll.sortIndex = index;
    this.itemkontrakeditorSink.add(itemShowAll);
  }

  void changeDropdownType(int value) {
    _currentType = value;
    ItemShowAll itemShowAll = new ItemShowAll(_cacheStream, _types,
        _listKontrak, EStateShowall.finish, _currentStream, _currentType);
    this.itemkontrakeditorSink.add(itemShowAll);
  }

  void chageDropdownStream(int value) {
    _currentStream = value;
    ItemShowAll itemShowAll = new ItemShowAll(_cacheStream, _types,
        _listKontrak, EStateShowall.finish, _currentStream, _currentType);
    this.itemkontrakeditorSink.add(itemShowAll);
  }

  // Future<bool> deleteKontrak(Kontrak kontrak) async {
  //   HttpAction httpAction = new HttpAction();
  //   Map<String, dynamic> response = await httpAction.deleteKontrak(kontrak);
  //   if (response != null) {
  //     var result = response['rowcount'];
  //     if (result > 0) {
  //       print(
  //           'listkontrak: ${_listKontrak.length} cachelistkontrak: ${_cacheAllListKontrak.length}');
  //       _listKontrak.remove(kontrak);
  //       _cacheAllListKontrak.remove(kontrak);
  //       return true;
  //       //  print('after delete: ${_listKontrak.length} cachelistkontrak: ${_cacheAllListKontrak.length}');
  //     }
  //   }
  //   return false;
  // }

  Future<Kontrak> editflagberakhirKontrak(Kontrak kontrak,int flagvalue) async {
   kontrak.setFlagBerakhir(flagvalue);

    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response = await httpAction.editKontrak(kontrak);
    if (response != null) {
      int i = _listKontrak.indexOf(kontrak);
      if (i > -1) {
        _cacheAllListKontrak[i].setFlagBerakhir(flagvalue);
        return Kontrak.fromJson(response);
      }
    }
    return null;
  }

  void dispose() {
    _itemShowAll.close();
  }
}

class ItemShowAll {
  List<StreamKontrak> listStream;
  List<String> typeKontrak;
  List<Kontrak> listKontrak;
  EStateShowall eStateShowall;
  int currentType;
  int currentStream;
  String textLoading;
  int sortIndex;
  bool asc = true;

  ItemShowAll(this.listStream, this.typeKontrak, this.listKontrak,
      this.eStateShowall, this.currentStream, this.currentType,
      {this.textLoading});
}

enum EStateShowall { loading, finish, error }
