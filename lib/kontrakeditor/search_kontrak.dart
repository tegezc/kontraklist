import 'package:flutter/material.dart';
import 'package:listkontrakapp/model/kontrak.dart';

class SearchKontrak extends StatefulWidget {
  final Function finishpick;

  SearchKontrak(this.finishpick);

  @override
  _SearchKontrakState createState() => _SearchKontrakState();
}

class _SearchKontrakState extends State<SearchKontrak> {
  FocusNode _focusNode;
  TextEditingController _textEditingController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Kontrak> lkon = List();
    for (int i = 0; i < 10; i++) {
      Kontrak k = new Kontrak('dfsd', 'sdfdfd', DateTime.now());
      lkon.add(k);
    }

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
                    onPressed: () {},
                    child: Icon(Icons.close_rounded,color: Colors.white,),
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
                    onChanged: (str) {},
                    autocorrect: false,
                    focusNode: _focusNode,
                    controller: _textEditingController,
                    autofocus: true,
                    maxLines: 1,
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
                    children: this._table(lkon),
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
        onPressed: () {},
        child: Row(
          children: [
            Container(
              color: Colors.red,
              width: 100,
              height: 30,
            ),
            Container(
              color: Colors.green,
              width: 600,
              height: 30,
            ),
          ],
        ),
      )
    ]);
  }
}
