import 'package:listkontrakapp/model/kontrak.dart';
import 'package:rxdart/subjects.dart';

import 'package:listkontrakapp/http/http_controller.dart';

class BlocKontrakEditor {
  List<Kontrak> _cacheListKontrak;
  List<StreamKontrak> _cacheStream;

  BlocKontrakEditor() {
    _cacheListKontrak = List();
    _cacheStream = List();
  }

  final PublishSubject<ItemEditorKontrak> _itemkontrakeditor =
      PublishSubject<ItemEditorKontrak>();

  final PublishSubject<List<Kontrak>> _listKontrak =
      PublishSubject<List<Kontrak>>();

  Sink<ItemEditorKontrak> get itemkontrakeditorSink => _itemkontrakeditor.sink;

  Stream<ItemEditorKontrak> get itemkontrakeditorStream =>
      _itemkontrakeditor.stream;

  Sink<List<Kontrak>> get listKontrakSink => _listKontrak.sink;

  Stream<List<Kontrak>> get listKontrakStream => _listKontrak.stream;

  void firstTime() async {
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

      ItemEditorKontrak itemEditorKontrak = new ItemEditorKontrak(_cacheStream, EStateKontrakEditor.finish, null, false);
      this.itemkontrakeditorSink.add(itemEditorKontrak);
    }
  }

  void searchKontrak(String text) {
    List<Kontrak> lk = _cacheListKontrak
        .where((kontrak) =>
            kontrak.noKontrak.toLowerCase().contains(text.toLowerCase()))
        .toList();
    listKontrakSink.add(lk);
  }

  void dispose() {
    _listKontrak.close();
    _itemkontrakeditor.close();
  }
}

class ItemEditorKontrak {
  List<StreamKontrak> listStream;
  EStateKontrakEditor eStateKontrakEditor;
  Kontrak kontrakAwal;
  bool isModeSearch;

  ItemEditorKontrak(this.listStream,this.eStateKontrakEditor,this.kontrakAwal,this.isModeSearch);
}

enum EStateKontrakEditor { loading, finish }
