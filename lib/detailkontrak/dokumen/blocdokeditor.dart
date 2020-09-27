import 'package:listkontrakapp/model/ConstantaApp.dart';
import 'package:listkontrakapp/model/enum_app.dart';
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

  void firstimeBaru(int idkontrak, JenisDokumen jnsdok) {
    this._initialFromInternet(idkontrak, jnsdok).then((versi) {
      LogDokumen logDokumen = new LogDokumen(
          namaReviewer: '',
          keterangan: '',
          tanggal: DateTime.now(),
          versi: versi + 1);
      logDokumen.realIdKontrak = idkontrak;
      logDokumen.jnsDoc = jnsdok;

      ItemDokumenEditor itemDokumenEditor = new ItemDokumenEditor(logDokumen,EnumStateEditor.baru);
      this.itemdokumeneditorSink.add(itemDokumenEditor);
    });
  }

  void  firstimeEdit(LogDokumen logDokumen){
    this._initialFromInternet(logDokumen.realIdKontrak, logDokumen.jnsDoc).then((versi) {
      ItemDokumenEditor itemDokumenEditor = new ItemDokumenEditor(logDokumen,EnumStateEditor.edit);
      this.itemdokumeneditorSink.add(itemDokumenEditor);
    });
  }


  Future<int> _initialFromInternet(int idkontrak, JenisDokumen jnsdok) async {
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response =
        await httpAction.initialCreateDokumen(idkontrak, jnsdok.code);
    return response['maxversi'];
  }


  Future<bool> updateDokumen(LogDokumen logDokumen,)async{
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response = await httpAction.editDokumen(logDokumen);
    if(response['id']!=null){
      if(response['id']>0){
        return true;
      }
    }
    return false;
  }

  Future<bool> saveDokumen(LogDokumen logDokumen,List<int> filePdf,List<int> filedoc,String extdoc)async{
    bool uploadpdf = await this._saveFile(logDokumen, filePdf, 'pdf');
    if(uploadpdf){
      if(filedoc != null){
        bool uploaddoc = await this._saveFile(logDokumen, filedoc, extdoc);
        if(uploaddoc){
          logDokumen.extDoc = extdoc;
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

  Future<bool> downloadDokumen(int iddokumen,EnumFileDokumen enumFileDokumen)async{
    HttpAction httpAction = new HttpAction();

    return await httpAction.downloadDoc(iddokumen, enumFileDokumen);
  }

  void dispose() {
    _itemdokumeneditor.close();
  }
}

class ItemDokumenEditor {
  LogDokumen logDokumen;
  EnumStateEditor enumStateEditor;

  ItemDokumenEditor(this.logDokumen,this.enumStateEditor);
}
