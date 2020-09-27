import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:js' as js;
import 'package:listkontrakapp/model/enum_app.dart';
import 'package:listkontrakapp/model/kontrak.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';
import 'package:url_launcher/url_launcher.dart';

class HttpAction {
  static const String keyHost = 'host';
  String _host;

  HttpAction() {
    _host = 'http://localhost/project';
  }

  Future<Map<String, dynamic>> getDashboardData() async {
    try {
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
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> getDetailKontrak(Kontrak kontrak) async {
    try {
      // print(_host);
      final response = await http.get('$_host/kontraks/${kontrak.realID}');
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
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> createKontrak(Kontrak kontrak) async {
//String jsondata = "{\"nokontrak\":\"RR20231201SS\",\"nama\":\"Pengadaan Anti Virus Norton 2018 untuk divisi IT PT Pertamina \",\"namaunit\":\"IT Divisi\",\"anakperusahaan\":\"PT Anak Perusahaan\",\"region\":\"region 1\",\"stream\":\"\",\"durasi\":24,\"nilai\":900000000,\"tanggal_mulai\":\"2020-08-01\",\"tanggal_berakhir\":\"2022-08-01\",\"nm_pic_kontrak\":\"Heri\",\"hp_pic_kontrak\":\"0889898981\",\"email_pic_kontrak\":\"kontrak@contoh.com\",\"vendor_pemenanga\":\"PT Vendor Pertamina\",\"nm_pic_vendor\":\"Gunawan \",\"no_pic_vendor\":\"08766767689\",\"email_pic_vendor\":\"budi@coba.com\",\"direksi\":\"direksi\",\"penandatangan\":\"penandatangan\",\"kontrak_awal\":\"\",\"email\":\"budi@coba.com\"}";
//Kontrak k = new Kontrak.fromJson(json.decode(jsondata));
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
      print(response.body);
      throw Exception('Failed to createContract.');
    }
  }

  Future<void> downloadCsv(String contentcsv, String filename) async {
    // prepare
    final bytes = utf8.encode(contentcsv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$filename.csv';
    html.document.body.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future<Map<String, dynamic>> initialCreateKontrak() async {
    try {
      String url = '$_host/kontraks';
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> getAllKontrak() async {
    String url = '$_host/kontraks';
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed get all kontrak');
    }
  }

  Future<Map<String, dynamic>> deleteKontrak(Kontrak kontrak) async {
    final http.Response response = await http.delete(
      '$_host/kontraks/${kontrak.realID}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to createContract.');
    }
  }

  Future<Map<String, dynamic>> editKontrak(Kontrak kontrak) async {
    final http.Response response = await http.put(
      '$_host/kontraks/${kontrak.realID}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(kontrak.toJson()),
    );

    if (response.statusCode == 201) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to createContract.');
    }
  }

  Future<Map<String, dynamic>> initialCreateDokumen(
      int idkontrak, String jnsdok) async {
    try {
      final response = await http.get('$_host/dokumen/$idkontrak/$jnsdok');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(response.body);
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> uploadDoc(
      LogDokumen logDokumen, List<int> _selectedFile, String ext) async {
    print(_selectedFile.length);
    var url = Uri.parse('$_host/upload');
    var request = new http.MultipartRequest("POST", url);
    request.fields['idkontrak'] = '${logDokumen.realIdKontrak}';
    request.fields['type'] = '${logDokumen.jnsDoc.code}';
    request.fields['versi'] = '${logDokumen.versi}';
    request.fields['ext'] = ext;
    request.files.add(http.MultipartFile.fromBytes('file', _selectedFile,
        contentType: new MediaType('application', 'octet-stream'),
        filename: "file_up"));

    //http.StreamedResponse response = await request.send();
    http.Response response =
        await http.Response.fromStream(await request.send());
    print("Result: ${response.body}");

    if (response.statusCode == 200) {
      Map<String,dynamic> resp = json.decode(response.body);
      if(resp['status'] !=null){
        if(resp['status']==1)return true;
      }
      return false;
    }
    return false;
  }

  Future<Map<String, dynamic>> createDokumen(LogDokumen logDokumen) async {
    final http.Response response = await http.post(
      '$_host/dokumen',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(logDokumen.toJson()),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to createContract.');
    }
  }

  Future<Map<String, dynamic>> editDokumen(LogDokumen dokumen) async {
    final http.Response response = await http.put(
      '$_host/dokumen/${dokumen.realId}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dokumen.toJson()),
    );

    if (response.statusCode == 201) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to createContract.');
    }
  }

  Future<Map<String, dynamic>> deleteDokumen(LogDokumen dokumen) async {
    final http.Response response = await http.delete(
      '$_host/dokumen/${dokumen.realId}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to createContract.');
    }
  }

  Future<bool> downloadDoc(
      int iddokumen, EnumFileDokumen enumFileDokumen) async {
    String jnsFile = '';
    if (enumFileDokumen == EnumFileDokumen.pdf) {
      jnsFile = 'pdf';
    } else if (enumFileDokumen == EnumFileDokumen.doc) {
      jnsFile = 'doc';
    } else {}
    String param = '$iddokumen+$jnsFile';
    String url = '$_host/download/$param';
    print('url: $url');
    js.context.callMethod("open", [url]);
  }
}
