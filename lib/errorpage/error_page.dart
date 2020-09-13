import 'package:flutter/material.dart';
class SettingHostSalah extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.only(left: 55.0, top: 15.0, bottom: 10.0),
            child: Text('Terjadi kesalahan di server.'),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 55.0, right: 55.0, top: 15.0, bottom: 10.0),
            child: Container(
              height: 2,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
