import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MonthAction {
  const MonthAction();
  Future<void> bacaAdm(
      String ipIs, DateTime tahun, BuildContext context) async {
    try {
      Uri dophp = Uri.parse("http://$ipIs/jaringan/conn/doDatahis.php");
      await http.post(dophp, body: {
        'action': 'BacaAdmin',
        'key': 'LightVolve',
        'now': DateTime.now().toString()
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (builder) => AlertDialog(
                content: Text(e.toString()),
                title: const Text("Error"),
              ));
    }
  }
}
