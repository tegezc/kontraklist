import 'package:listkontrakapp/model/ConstantaApp.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:rxdart/subjects.dart';

import 'package:listkontrakapp/http/http_controller.dart';

class BlocDetailKontrak {
  final PublishSubject<ItemDetailKontrak> _itemDetailkontrak =
      PublishSubject<ItemDetailKontrak>();

  Sink<ItemDetailKontrak> get itemDetailkontrakSink => _itemDetailkontrak.sink;

  Stream<ItemDetailKontrak> get itemDetailkontrakStream =>
      _itemDetailkontrak.stream;

  void firstTime(Kontrak kontrak) async{
    ItemDetailKontrak item = await this._processFromInternet(kontrak);
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

    List<LogDokumen> ldpe = this._convertJsonToList(lpe);
    List<LogDokumen> ldtor = this._convertJsonToList(ltor);
    List<LogDokumen> ldst = this._convertJsonToList(lst);
    List<LogDokumen> ldhps = this._convertJsonToList(lhps);
    List<LogDokumen> ldsp = this._convertJsonToList(lsp);

  return new ItemDetailKontrak(kontrak, ldpe, ldtor, ldst, ldhps, ldsp);
   
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

  ItemDetailKontrak(
      this.kontrak, this.lpe, this.ltor, this.lst, this.lhps, this.lsp);
}
