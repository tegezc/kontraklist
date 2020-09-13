import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:listkontrakapp/model/kontrak.dart';

class HttpAction {
  static const String keyHost = 'host';
  String _host;

  HttpAction(){
    _host = 'http://localhost/project';
  }

  Future<Map<String, dynamic>> getDashboardData() async {

    try{
     // print(_host);
      final response = await http.get(_host);
      //print('masuk sini');
      if (response.statusCode == 200) {
        //print('masuk sini1');
        // If the server did return a 200 OK response,
        // then parse the JSON.
       // print(response.body);
        return json.decode(response.body);
      } else {
       // print('masuk sini2');
        return null;
      }
    }catch(e){
      print(e.toString());
      return null;
    }

  }

  Future<String> createKontrak(Kontrak kontrak) async {

    final http.Response response = await http.post(
      '$_host/kontraks',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(kontrak.toJson()),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create album.');
    }
  }
}
