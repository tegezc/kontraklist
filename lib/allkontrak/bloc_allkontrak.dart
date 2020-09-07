import 'dart:async';

import 'package:listkontrakapp/model/kontrak.dart';
import 'package:rxdart/subjects.dart';

class BlocAllKontrak {


  final BehaviorSubject<EntryAllKontrak> _entryAllKontrak = BehaviorSubject();

  void dispose(){
    _entryAllKontrak.close();
  }

  Stream<EntryAllKontrak> get entryAllKontrak => _entryAllKontrak.stream;

  void _sinkEntryKontrak(EntryAllKontrak entryAllKontrak) {
    _entryAllKontrak.sink.add(entryAllKontrak);
  }

  void firstTime(){

  }

}

class EntryAllKontrak{
  List<Kontrak> lkontrak90;
  List<Kontrak> lKontrak180;
  List<Kontrak> lKontrak360;
}