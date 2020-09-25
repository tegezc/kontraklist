import 'package:listkontrakapp/model/kontrak.dart';
import 'package:rxdart/subjects.dart';
import 'dart:async';

import 'package:listkontrakapp/http/http_controller.dart';

class BlocDokumenEditor {
  final PublishSubject<ItemDokumenEditor> _itemdokumeneditor =
      PublishSubject<ItemDokumenEditor>();

  Stream<ItemDokumenEditor> get itemdokumeneditorStream =>
      _itemdokumeneditor.stream;

  Sink<ItemDokumenEditor> get itemdokumeneditorSink => _itemdokumeneditor.sink;

  void firstimeBaru(int idkontrak, String jnsdok) {
    this._initialFromInternet(idkontrak, jnsdok).then((versi) {
      LogDokumen logDokumen = new LogDokumen(
          namaReviewer: '',
          keterangan: '',
          tanggal: DateTime.now(),
          versi: versi + 1,
          linkPdf: '');
      logDokumen.realIdKontrak = idkontrak;
      logDokumen.jnsDoc = jnsdok;
      logDokumen.linkDoc = '';

      ItemDokumenEditor itemDokumenEditor = new ItemDokumenEditor(logDokumen);
      this.itemdokumeneditorSink.add(itemDokumenEditor);
    });
  }

  Future<int> _initialFromInternet(int idkontrak, String jnsdok) async {
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response =
        await httpAction.initialCreateDokumen(idkontrak, jnsdok);
    return response['maxversi'];
  }

  Future<bool> saveDokumen(LogDokumen logDokumen,List<int> filePdf,List<int> filedoc,String extdoc)async{
    bool uploadpdf = await this._saveFile(logDokumen, filePdf, 'pdf');
    if(uploadpdf){
      if(filedoc != null){
        bool uploaddoc = await this._saveFile(logDokumen, filedoc, extdoc);
        if(uploaddoc){
          return await this._saveDokumen(logDokumen);
        }
      }else{
        return await this._saveDokumen(logDokumen);
      }

    }
    return false;
  }

  Future<bool> _saveFile(LogDokumen logDokumen,List<int> selectedFile,String ext) async{
    HttpAction httpAction = new HttpAction();
    bool result = await httpAction.uploadDoc(logDokumen, selectedFile,ext);
    return result;
  }

  Future<bool> _saveDokumen(LogDokumen logDokumen) async{
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> result = await httpAction.createDokumen(logDokumen);
    int id = result['id'];
    if(id>0){
      return true;
    }
    return false;
  }

  void dispose() {
    _itemdokumeneditor.close();
  }
}

class ItemDokumenEditor {
  LogDokumen logDokumen;

  ItemDokumenEditor(this.logDokumen);
}
