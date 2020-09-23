import 'package:listkontrakapp/model/kontrak.dart';
import 'package:rxdart/subjects.dart';

import 'package:listkontrakapp/http/http_controller.dart';

class BlocDokumenEditor {
  final PublishSubject<ItemDokumenEditor> _itemdokumeneditor =
      PublishSubject<ItemDokumenEditor>();

  Stream<ItemDokumenEditor> get itemdokumeneditorStream => _itemdokumeneditor.stream;

  Sink<ItemDokumenEditor> get itemdokumeneditorSink => _itemdokumeneditor.sink;

  void firstimeBaru(int idkontrak,String jnsdok) {
    this._initialFromInternet(idkontrak,jnsdok).then((versi){
      LogDokumen logDokumen = new LogDokumen(namaReviewer: '', keterangan: '', tanggal: DateTime.now(), versi: versi+1, linkPdf: '');
      ItemDokumenEditor itemDokumenEditor = new ItemDokumenEditor(logDokumen);
      this.itemdokumeneditorSink.add(itemDokumenEditor);
    });
  }

  Future<int> _initialFromInternet(int idkontrak,String jnsdok) async {
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response =
        await httpAction.initialCreateDokumen(idkontrak,jnsdok);
   return response['maxversi'];

  }

  void dispose() {
    _itemdokumeneditor.close();
  }
}

class ItemDokumenEditor {
  LogDokumen logDokumen;
  ItemDokumenEditor(this.logDokumen);
}
