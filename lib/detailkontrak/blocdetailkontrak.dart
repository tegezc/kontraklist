import 'package:listkontrakapp/model/ConstantaApp.dart';
import 'package:listkontrakapp/model/enum_app.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:rxdart/subjects.dart';

import 'package:listkontrakapp/http/http_controller.dart';

class BlocDetailKontrak {

  Kontrak _cacheKontrak;
  ItemDetailKontrak _cacheItemDetailKontrak;
  Map<String,String> _cacheStream;

  final PublishSubject<ItemDetailKontrak> _itemDetailkontrak =
      PublishSubject<ItemDetailKontrak>();

  Sink<ItemDetailKontrak> get itemDetailkontrakSink => _itemDetailkontrak.sink;

  Stream<ItemDetailKontrak> get itemDetailkontrakStream =>
      _itemDetailkontrak.stream;

  void firstTime(Kontrak kontrak) async{

     _cacheStream = Map();
    _cacheKontrak = kontrak;
    ItemDetailKontrak item = await this._processFromInternet(kontrak);
     _cacheItemDetailKontrak = item;
    this.itemDetailkontrakSink.add(item);
  }

  Future<ItemDetailKontrak> _processFromInternet(Kontrak kontrak) async {
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response = await httpAction.getDetailKontrak(kontrak);

    List<dynamic> lpe = response[JenisDokumen.tagPe];
    List<dynamic> ltor = response[JenisDokumen.tagTor];
    List<dynamic> lst = response[JenisDokumen.tagSt];
    List<dynamic> lhps = response[JenisDokumen.tagHps];
    List<dynamic> lsp = response[JenisDokumen.tagSp];
    List<dynamic> lstream = response['stream'];

    lstream.forEach((element) {
      StreamKontrak streamKontrak = StreamKontrak.fromJson(element);
      _cacheStream[streamKontrak.realId] = streamKontrak.nama;
    });

    List<LogDokumen> ldpe = this._convertJsonToList(lpe);
    List<LogDokumen> ldtor = this._convertJsonToList(ltor);
    List<LogDokumen> ldst = this._convertJsonToList(lst);
    List<LogDokumen> ldhps = this._convertJsonToList(lhps);
    List<LogDokumen> ldsp = this._convertJsonToList(lsp);

    String textStream = _cacheStream[_cacheKontrak.stream];
    _cacheKontrak.textStream = textStream;
  return new ItemDetailKontrak(kontrak, ldpe, ldtor, ldst, ldhps, ldsp,null,EnumLoadingStateDetKon.finish);
   
  }

  void reloadFromInternet(JenisDokumen jnsdoc) async {
    ItemDetailKontrak itemDetailKontrakLoading =  new ItemDetailKontrak(_cacheKontrak, null, null, null, null, null,null,EnumLoadingStateDetKon.reload);
    this.itemDetailkontrakSink.add(itemDetailKontrakLoading);
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response = await httpAction.getDetailKontrak(_cacheKontrak);

    List<dynamic> lpe = response[JenisDokumen.tagPe];
    List<dynamic> ltor = response[JenisDokumen.tagTor];
    List<dynamic> lst = response[JenisDokumen.tagSt];
    List<dynamic> lhps = response[JenisDokumen.tagHps];
    List<dynamic> lsp = response[JenisDokumen.tagSp];

    List<LogDokumen> ldpe = this._convertJsonToList(lpe);
    List<LogDokumen> ldtor = this._convertJsonToList(ltor);
    List<LogDokumen> ldst = this._convertJsonToList(lst);
    List<LogDokumen> ldhps = this._convertJsonToList(lhps);
    List<LogDokumen> ldsp = this._convertJsonToList(lsp);

    String textStream = _cacheStream[_cacheKontrak.stream];
    _cacheKontrak.textStream = textStream;
    ItemDetailKontrak itemDetailKontrak =  new ItemDetailKontrak(_cacheKontrak, ldpe, ldtor, ldst, ldhps, ldsp,jnsdoc,EnumLoadingStateDetKon.finish);
   _cacheItemDetailKontrak = itemDetailKontrak;
    this.itemDetailkontrakSink.add(itemDetailKontrak);

  }

  Future<bool> deleteDokumen(LogDokumen logDokumen)async{
    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response = await httpAction.deleteDokumen(logDokumen);
    if(response['rowcount']!=null){
      if(response['rowcount']>0){
        return true;
      }
    }
    return false;


  }

  Future<bool> downloadDokumen(int iddokumen,EnumFileDokumen enumFileDokumen)async{
    HttpAction httpAction = new HttpAction();

    return await httpAction.downloadDoc(iddokumen, enumFileDokumen);
  }

  Future<bool> editflagberakhirKontrak(Kontrak kontrak,int flagvalue) async {
    kontrak.setFlagBerakhir(flagvalue);

    HttpAction httpAction = new HttpAction();
    Map<String, dynamic> response = await httpAction.editKontrak(kontrak);
    if (response != null) {
     _cacheKontrak.setFlagBerakhir(flagvalue);
     _cacheItemDetailKontrak.kontrak = _cacheKontrak;
     return true;
    }
    return false;
  }

  void reloadDataLocal(){
    String textStream = _cacheStream[_cacheKontrak.stream];
    _cacheKontrak.textStream = textStream;

    this.itemDetailkontrakSink.add(_cacheItemDetailKontrak);
  }


  List<LogDokumen> _convertJsonToList(List<dynamic> ljson) {
    List<LogDokumen> ldoc = List();

    ljson.forEach((element) {
      LogDokumen d = LogDokumen.fromJson(element);
      ldoc.add(d);
    });
    return ldoc;
  }

  void dispose() {
    _itemDetailkontrak.close();
  }
}

class ItemDetailKontrak {
  Kontrak kontrak;
  List<LogDokumen> lpe;
  List<LogDokumen> ltor;
  List<LogDokumen> lst;
  List<LogDokumen> lhps;
  List<LogDokumen> lsp;
  EnumLoadingStateDetKon enumLoadingStateDetKon;

  /// null jika tidak ada yang expands
  /// nilai sesuai class [JenisDokumen]
  JenisDokumen specificExpanseByDoc;

  ItemDetailKontrak(
      this.kontrak, this.lpe, this.ltor, this.lst, this.lhps, this.lsp,this.specificExpanseByDoc,this.enumLoadingStateDetKon);
}

enum EnumLoadingStateDetKon{
  finish,
  reload,
}
