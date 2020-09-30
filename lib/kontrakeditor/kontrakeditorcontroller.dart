import 'package:flutter/material.dart';
import 'package:listkontrakapp/detailkontrak/detail_kontrak.dart';
import 'package:listkontrakapp/kontrakeditor/kontrakeditor.dart';
import 'package:listkontrakapp/model/enum_app.dart';
import 'package:listkontrakapp/model/kontrak.dart';


class KontrakEditorController extends StatefulWidget {
  final EnumStateEditor enumStateEditor;
  final Kontrak kontrak;
  final Function callbackFinish;
  final Function callbackFromDetail;

  KontrakEditorController.baru(this.callbackFromDetail,this.callbackFinish,{this.enumStateEditor=EnumStateEditor.baru,this.kontrak});

  KontrakEditorController.editmode(this.callbackFromDetail,this.callbackFinish,this.kontrak,{this.enumStateEditor=EnumStateEditor.edit});
  @override
  _KontrakEditorControllerState createState() => _KontrakEditorControllerState();
}

class _KontrakEditorControllerState extends State<KontrakEditorController> {
  
  bool _isStateEditor = true;
  Kontrak _cacheKontrak;
  @override
  void initState(){
    _cacheKontrak = widget.kontrak;
    super.initState();
  }
  
  _callbackFinishEditor(Kontrak kontrak){
    print('call back di KontrakEditorController');
    widget.callbackFinish();
    setState(() {
      _cacheKontrak = kontrak;
      _isStateEditor = false;
    });
  }

  _callbackFromDetail(){}
  
  @override
  Widget build(BuildContext context) {
    if(_isStateEditor){
     if(widget.enumStateEditor == EnumStateEditor.baru){
       return KontrakEditor.baru(_callbackFinishEditor);
     }else{
       return KontrakEditor.editmode(_callbackFinishEditor,_cacheKontrak);
     }
    }else{
      return DetailKontrak(_callbackFromDetail,_cacheKontrak);
    }
   
  }
}
