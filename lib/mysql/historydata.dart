import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HisAction {
  const HisAction();
  Future<void> bacaAdm(String ipIs, String idPel, BuildContext context) async {
    try {
      Uri dophp = Uri.parse("http://$ipIs/jaringan/conn/doDatahis.php");
      await http.post(dophp, body: {
        'action': 'BacaAdmin',
        'key': 'LightVolve',
        'idPel': idPel,
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

  Future<void> bacaPet(String ipIs, String idPel, BuildContext context) async {
    try {
      Uri dophp = Uri.parse("http://$ipIs/jaringan/conn/doDatahis.php");
      await http.post(dophp, body: {
        'action': 'BacaPetugas',
        'key': 'LightVolve',
        'idPel': idPel,
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

  Future<void> kirimPet(String ipIs, String idPel, BuildContext context) async {
    try {
      Uri dophp = Uri.parse("http://$ipIs/jaringan/conn/doDatahis.php");
      await http.post(dophp, body: {
        'action': 'krmPtg',
        'key': 'LightVolve',
        'idPel': idPel,
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

  Future<void> bacaTndk(String ipIs, String idPel, BuildContext context) async {
    try {
      Uri dophp = Uri.parse("http://$ipIs/jaringan/conn/doDatahis.php");
      await http.post(dophp, body: {
        'action': 'krmTndk',
        'key': 'LightVolve',
        'idPel': idPel,
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

  Future<void> kembali(String ipIs, String idPel, BuildContext context) async {
    try {
      Uri dophp = Uri.parse("http://$ipIs/jaringan/conn/doDatahis.php");
      final respone = await http.post(dophp, body: {
        'action': 'kembali',
        'key': 'LightVolve',
        'idPel': idPel,
        'now': DateTime.now().toString()
      });
      if (respone.body == "Sucess") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No Problem")));
      }
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
