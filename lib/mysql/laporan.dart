import 'dart:convert';
//import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportAction {
  const ReportAction();

  Future<List<dynamic>> getLayananComData(String iP) async {
    try {
      Uri doInlay = Uri.parse("http://$iP/jaringan/conn/doReport.php");
      final respone = await http.post(doInlay, body: {
        'action': 'LaySel',
        'key': 'DarkVolve',
      });
      List<dynamic> list = jsonDecode(respone.body);

      return list;
    } catch (e) {
      return <String>[];
    }
  }

  Future<List> geGangguanComData(String iP) async {
    try {
      Uri doInlay = Uri.parse("http://$iP/jaringan/conn/doReport.php");
      final respone = await http.post(doInlay, body: {
        'action': 'GanSel',
        'key': 'DarkVolve',
      });
      List<dynamic> list = jsonDecode(respone.body);
      return list;
    } catch (e) {
      return <String>[];
    }
  }

  Future<List> geBaruComData(String iP) async {
    try {
      Uri doInlay = Uri.parse("http://$iP/jaringan/conn/doReport.php");
      final respone = await http.post(doInlay, body: {
        'action': 'BarSel',
        'key': 'DarkVolve',
      });
      List<dynamic> list = jsonDecode(respone.body);
      return list;
    } catch (e) {
      return <String>[];
    }
  }

  Future<List> getLPetugasData(String iP) async {
    try {
      Uri doInlay = Uri.parse("http://$iP/jaringan/conn/doReport.php");
      final respone = await http.post(doInlay, body: {
        'action': 'DatPet',
        'key': 'DarkVolve',
      });
      List<dynamic> list = jsonDecode(respone.body);
      return list;
    } catch (e) {
      return <String>[];
    }
  }

  Future<List> getProgLayData(String iP) async {
    try {
      Uri doInlay = Uri.parse("http://$iP/jaringan/conn/doReport.php");
      final respone = await http.post(doInlay, body: {
        'action': 'DatProLay',
        'key': 'DarkVolve',
      });
      List<dynamic> list = jsonDecode(respone.body);
      return list;
    } catch (e) {
      return <String>[];
    }
  }

  Future<List> getProgGanData(String iP) async {
    try {
      Uri doInlay = Uri.parse("http://$iP/jaringan/conn/doReport.php");
      final respone = await http.post(doInlay, body: {
        'action': 'DatProGan',
        'key': 'DarkVolve',
      });
      List<dynamic> list = jsonDecode(respone.body);
      return list;
    } catch (e) {
      return <String>[];
    }
  }

  Future<List> getProgBarData(String iP) async {
    try {
      Uri doInlay = Uri.parse("http://$iP/jaringan/conn/doReport.php");
      final respone = await http.post(doInlay, body: {
        'action': 'DatProBar',
        'key': 'DarkVolve',
      });
      List<dynamic> list = jsonDecode(respone.body);
      return list;
    } catch (e) {
      return <String>[];
    }
  }

  Future<List> getInboxAdm(String iP) async {
    try {
      Uri doInlay = Uri.parse("http://$iP/jaringan/conn/doDatahis.php");
      final respone = await http.post(doInlay, body: {
        'action': 'getInboxAdm',
        'key': 'LightVolve',
      });
      List<dynamic> list = jsonDecode(respone.body);
      return list;
    } catch (e) {
      return <String>[];
    }
  }

  Future<List> getKalender(String iP) async {
    try {
      Uri doInlay = Uri.parse("http://$iP/jaringan/conn/doBulanan.php");
      final respone = await http.post(doInlay, body: {
        'action': 'doReport',
        'key': 'NewMewVolve',
      });
      debugPrint(respone.body);
      List<dynamic> list = jsonDecode(respone.body);
      return list;
    } catch (e) {
      return <String>[];
    }
  }

  Future<List> getAllInboxPet(
    String iP,
  ) async {
    try {
      Uri doInlay = Uri.parse("http://$iP/jaringan/conn/doDatahis.php");
      final respone = await http.post(doInlay, body: {
        'action': 'getInboxAllPet',
        'key': 'LightVolve',
      });
      List<dynamic> list = jsonDecode(respone.body);
      return list;
    } catch (e) {
      return <String>[];
    }
  }

  Future<List> getInboxPet(String iP, String petugas) async {
    try {
      Uri doInlay = Uri.parse("http://$iP/jaringan/conn/doDatahis.php");
      final respone = await http.post(doInlay, body: {
        'action': 'getInboxPet',
        'key': 'LightVolve',
        'petugas': petugas
      });
      List<dynamic> list = jsonDecode(respone.body);
      return list;
    } catch (e) {
      return <String>[];
    }
  }

  Future<List> getOpsiLay(String iP, String jenis) async {
    try {
      Uri doInlay = Uri.parse("http://$iP/jaringan/conn/doReport.php");
      final respone = await http.post(doInlay, body: {
        'action': (jenis == 'OpsiLay')
            ? 'OpsiLay'
            : (jenis == 'OpsiGan')
                ? 'OpsiGan'
                : 'instansi',
        'key': 'DarkVolve',
      });
      List<dynamic> list = jsonDecode(respone.body);
      return list;
    } catch (e) {
      return <String>[];
    }
  }
}
