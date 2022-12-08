import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

typedef Moradelema = void Function(bool justice, String hero);

class ActionLawsuit {
  final Moradelema action;
  const ActionLawsuit({required this.action});

  Future<Map<String, dynamic>> inBoxPep(String iP) async {
    Map<String, dynamic> returner = {};
    try {
      Uri doIn = Uri.parse("http://$iP/jaringan/conn/doProsess.php");
      final responeInLay = await http.post(doIn, body: {
        'action': 'getJumlahData',
        'key': 'RumputJatuh',
        'sql': 'Aminbox',
        'jenis': 'layanan'
      });
      String lay = responeInLay.body;

      final responeInGan = await http.post(doIn, body: {
        'action': 'getJumlahData',
        'key': 'RumputJatuh',
        'sql': 'Aminbox',
        'jenis': 'gangguan'
      });
      String gan = responeInGan.body;

      final responeInBar = await http.post(doIn, body: {
        'action': 'getJumlahData',
        'key': 'RumputJatuh',
        'sql': 'Aminbox',
        'jenis': 'baru'
      });
      String bar = responeInBar.body;

      String think = '{"yan":"$lay", "gan":"$gan","bar":"$bar"}';
      if (lay == "" || gan == "" || bar == "") {
        think = "";
      }

      returner = jsonDecode(think);
    } catch (e) {
      String think = '{"yan":"0", "gan":"0", "bar":"0"}';
      debugPrint(e.toString());
      return returner = jsonDecode(think);
    }

    return returner;
  }

  Future<List> inBoxPet(String iP, String petugas) async {
    List<dynamic> returner = [];
    try {
      Uri doIn = Uri.parse("http://$iP/jaringan/conn/doProsess.php");
      final responeInLay = await http.post(doIn, body: {
        'action': 'getJumlahData',
        'key': 'RumputJatuh',
        'sql': 'Petbox',
        'petugas': petugas,
        'jenis': 'layanan'
      });
      String lay = responeInLay.body;

      final responeInGan = await http.post(doIn, body: {
        'action': 'getJumlahData',
        'key': 'RumputJatuh',
        'sql': 'Petbox',
        'petugas': petugas,
        'jenis': 'gangguan'
      });
      String gan = responeInGan.body;
      final responeInBar = await http.post(doIn, body: {
        'action': 'getJumlahData',
        'key': 'RumputJatuh',
        'sql': 'Petbox',
        'petugas': petugas,
        'jenis': 'baru'
      });
      String bar = responeInBar.body;

      String think = '[{"yan":"$lay", "gan":"$gan", "bar":"$bar"}]';
      returner = jsonDecode(think);
    } catch (e) {
      debugPrint(e.toString());
      String think = '[{"yan":"0", "gan":"0", "bar":"0"}]';
      returner = jsonDecode(think);
    }

    return returner;
  }

  Future<List> inBoxPetPro(String iP, String petugas) async {
    List<dynamic> returner = [];
    try {
      Uri doIn = Uri.parse("http://$iP/jaringan/conn/doProsess.php");
      final responeInLay = await http.post(doIn, body: {
        'action': 'getJumlahData',
        'key': 'RumputJatuh',
        'sql': 'LayananPet',
        'petugas': petugas,
      });
      String lay = responeInLay.body;

      final responeInGan = await http.post(doIn, body: {
        'action': 'getJumlahData',
        'key': 'RumputJatuh',
        'sql': 'GangguanPet',
        'petugas': petugas,
      });
      String gan = responeInGan.body;

      final responeInBar = await http.post(doIn, body: {
        'action': 'getJumlahData',
        'key': 'RumputJatuh',
        'sql': 'BaruPet',
        'petugas': petugas,
      });
      String bar = responeInBar.body;
      String think = '[{"yan":"$lay", "gan":"$gan","bar":"$bar"}]';
      returner = jsonDecode(think);
    } catch (e) {
      debugPrint(e.toString());
      String think = '[{"yan":"0", "gan":"0", "bar":"0"}]';
      returner = jsonDecode(think);
    }

    return returner;
  }

  Future<void> kembali(String ipIs, String id, BuildContext context) async {
    try {
      Uri dophp = Uri.parse("http://$ipIs/jaringan/conn/doProsess.php");
      await http.post(dophp, body: {
        'action': 'back',
        'key': 'RumputJatuh',
        'id': id,
        'tgl': DateTime.now().toString()
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
