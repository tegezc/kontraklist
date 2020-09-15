import 'package:flutter/material.dart';
import 'package:listkontrakapp/kontrakeditor/bloc_kontrakeditor.dart';
import 'package:listkontrakapp/model/kontrak.dart';

class SearchKontrak extends StatefulWidget {
  final BlocKontrakEditor blocKontrakEditor;
  final ItemEditorKontrak itemEditorKontrak;

  SearchKontrak(this.blocKontrakEditor, this.itemEditorKontrak);

  @override
  _SearchKontrakState createState() => _SearchKontrakState();
}

class _SearchKontrakState extends State<SearchKontrak> {
  FocusNode _focusNode;
  TextEditingController _textEditingController;
  List<Kontrak> _listKontrak;
  List<Kontrak> _listHasilSearch;
  Kontrak _kontrakKosong;

  @override
  void initState() {
    _textEditingController = new TextEditingController();
    _focusNode = new FocusNode();
    _listKontrak = List();
    if (widget.itemEditorKontrak.listKontrak != null) {
      _listKontrak.addAll(widget.itemEditorKontrak.listKontrak);
    }
    _listHasilSearch = List();
    _kontrakKosong = new Kontrak('', 'Tidak memiliki kontrak awal',null);
    _listHasilSearch.add(_kontrakKosong);
    _listHasilSearch.addAll(_listKontrak);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _handleOnchageTextField(String str) {
    _listHasilSearch = _listKontrak
        .where((kontrak) =>
            kontrak.noKontrak.toLowerCase().contains(str.toLowerCase()))
        .toList();
    if(_listHasilSearch !=null){
      _listHasilSearch.insert(0, _kontrakKosong);
    }
    setState(() {});
  }

  void _finish(Kontrak kontrak) {
    widget.blocKontrakEditor.finishSearch(kontrak);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: 800,
          height: 800,
          child: Column(
            children: [
              Container(
                width: 800,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    onPressed: () {
                      widget.blocKontrakEditor.closeSearch();
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                    ),
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (str) {
                      _handleOnchageTextField(str);
                    },
                    autocorrect: false,
                    focusNode: _focusNode,
                    controller: _textEditingController,
                    autofocus: true,
                    maxLines: 1,
                    onSubmitted: (str) {
                      if (_listHasilSearch != null) {
                        if (_listHasilSearch.length>1) {
                          this._finish(_listHasilSearch[1]);
                        }
                      }
                    },
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                      //Add th Hint text here.
                      hintText: "Masukkan Nomor Kontrak",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: Colors.white,
                  height: 500,
                  width: 800,
                  child: Table(
                    border: TableBorder.symmetric(),
                    children: this._table(_listHasilSearch),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> _table(List<Kontrak> lk) {
    List<TableRow> lrow = new List();
    int rowCount = lk.length > 10 ? 10 : lk.length;
    for (int i = 0; i < rowCount; i++) {
      lrow.add(this._contentTable(lk[i]));
    }
    return lrow;
  }

  TableRow _contentTable(Kontrak kontrak) {
    return TableRow(children: [
      FlatButton(
        onPressed: () {
          if(kontrak.noKontrak.length==0){
            this._finish(null);
          }else{
            this._finish(kontrak);
          }

        },
        child: Row(
          children: [
            Container(
              child: Text(kontrak.noKontrak),
              width: 120,
            ),
            Container(
              child: Text(kontrak.nama),
              width: 600,
            ),
          ],
        ),
      )
    ]);
  }
}
