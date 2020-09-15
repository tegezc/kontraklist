import 'package:listkontrakapp/model/kontrak.dart';
import 'package:rxdart/subjects.dart';

import 'package:listkontrakapp/http/http_controller.dart';

class BlocKontrakEditor {
  List<Kontrak> _cacheListKontrak;
  List<StreamKontrak> _cacheStream;
  Kontrak  _cacheKontrak;

  BlocKontrakEditor() {
    _cacheListKontrak = List();
    _cacheStream = List();
  }

  final PublishSubject<ItemEditorKontrak> _itemkontrakeditor =
      PublishSubject<ItemEditorKontrak>();
  
  Sink<ItemEditorKontrak> get itemkontrakeditorSink => _itemkontrakeditor.sink;

  Stream<ItemEditorKontrak> get itemkontrakeditorStream =>
      _itemkontrakeditor.stream;
  
  void firstTimeNew() async {
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response = await httpAction.initialCreateKontrak();
    if (response != null) {
      List<dynamic> ldk = response['kontrak'];
      List<dynamic> lds = response['stream'];

      ldk.forEach((element) {
        Kontrak k = Kontrak.fromJson(element);
        _cacheListKontrak.add(k);
      });

      lds.forEach((element) {
        StreamKontrak stream = StreamKontrak.fromJson(element);
        _cacheStream.add(stream);
      });

      ItemEditorKontrak itemEditorKontrak = new ItemEditorKontrak(
          _cacheStream, _cacheListKontrak,EStateKontrakEditor.finish, _cacheKontrak, false);
      this.itemkontrakeditorSink.add(itemEditorKontrak);
    }
  }

  void firstTimeEdit(){}

  void showSearch() {
    ItemEditorKontrak itemEditorKontrak = new ItemEditorKontrak(
        _cacheStream, _cacheListKontrak,EStateKontrakEditor.finish, _cacheKontrak, true);
    this.itemkontrakeditorSink.add(itemEditorKontrak);

  }

  void finishSearch(Kontrak kontrak) {
    _cacheKontrak = kontrak;
    ItemEditorKontrak itemEditorKontrak = new ItemEditorKontrak(
        _cacheStream, _cacheListKontrak,EStateKontrakEditor.finish, _cacheKontrak, false);
    this.itemkontrakeditorSink.add(itemEditorKontrak);
  }

  void closeSearch() {
    ItemEditorKontrak itemEditorKontrak = new ItemEditorKontrak(
        _cacheStream, _cacheListKontrak,EStateKontrakEditor.finish, _cacheKontrak, false);
    this.itemkontrakeditorSink.add(itemEditorKontrak);
  }

  void dispose() {
    _itemkontrakeditor.close();
  }
}

class ItemEditorKontrak {
  List<StreamKontrak> listStream;
  List<Kontrak> listKontrak;
  EStateKontrakEditor eStateKontrakEditor;
  Kontrak kontrakAwal;
  bool isModeSearch;

  ItemEditorKontrak(this.listStream, this.listKontrak,this.eStateKontrakEditor, this.kontrakAwal,
      this.isModeSearch);
}

enum EStateKontrakEditor { loading, finish }
