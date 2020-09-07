import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:listkontrakapp/model/kontrak.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpController {
  static const String keyHost = 'host';
  String _host;

  HttpController();

  Future _init() async {
    final prefs = await SharedPreferences.getInstance();
    _host = prefs.getString(keyHost) ?? 0;
  }

  Future<Map<String, dynamic>> getDashboardData() async {
    await _init();
    final response = await http.get(_host);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<String> createKontrak(Kontrak kontrak) async {
    await _init();
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
