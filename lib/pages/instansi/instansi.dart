import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:network_kominfo/pages/instansi/instansi_data.dart';
import 'package:network_kominfo/widgetsutils/pagecontrol.dart';
import 'package:http/http.dart' as http;
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/scroll_parent.dart';

class Instansi extends StatefulWidget {
  final String ipIs;
  final bool exp;
  const Instansi({Key? key, required this.ipIs, required this.exp})
      : super(key: key);

  @override
  _InstansiState createState() => _InstansiState();
}

class _InstansiState extends State<Instansi> {
  final _rollCon = ScrollController();
  final _cariCon = TextEditingController(text: '');

  int _lit = 0, _maxPage = 1;
  Future<void>? _setMaxPage() async {
    try {
      Uri docari = Uri.parse("http://${widget.ipIs}/jaringan/conn/do.php");
      final responecari = await http.post(docari,
          body: {'action': 'getJumlahData', 'key': 'KucingBeintalu'});

      double totalData = double.parse(responecari.body) - 1;
      _maxPage = totalData ~/ 6;
      if (totalData % 6 != 0 && totalData > 6) _maxPage++;
    } catch (e) {
      _maxPage = 1;
    }
  }

  Future<List> _dataSet() async {
    try {
      Uri dophp =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doInstansi.php");
      final respone = await http.post(dophp, body: {
        'action': 'getData',
        'key': 'ParagimParadoxus',
        'lit': _lit.toString(),
        'cari': _cariCon.text
      });
      return jsonDecode(respone.body);
    } catch (e) {
      debugPrint(e.toString());
      return <String>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    Color a = getBlueColor();
    final tinggi = MediaQuery.of(context).size.height;
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.only(top: 5, right: 5),
        margin: EdgeInsets.only(top: 80.0, left: widget.exp ? 50 : 5),
        child: FutureBuilder<void>(
            future: _setMaxPage(),
            builder: (context, x) {
              return ListView(
                controller: _rollCon,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20, bottom: 30),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.shade200),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.home,
                              color: Colors.blue,
                            ),
                            Text("/ "),
                            Text(
                              "Instansi ",
                              style: TextStyle(color: Colors.blue),
                            ),
                            Text("/ Data Instansi")
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Stack(
                      children: [
                        Container(
                          height: (tinggi >= 255) ? tinggi - 255 : tinggi,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26, offset: Offset(5, 4))
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          margin: const EdgeInsets.only(
                              top: 40, left: 20, right: 10, bottom: 5),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 25.0),
                                child: FutureBuilder<List>(
                                    future: _dataSet(),
                                    builder: (context, snapped) {
                                      if (snapped.hasError) {
                                        return Center(
                                          child: Text(snapped.toString()),
                                        );
                                      } else {
                                        try {
                                          if (snapped.data!.isEmpty) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: (tinggi >= 415)
                                                      ? tinggi - 415
                                                      : tinggi,
                                                  top: 40),
                                              child: noDataSizedBox(),
                                            );
                                          }

                                          return SizedBox(
                                              height: (tinggi > 350)
                                                  ? tinggi - 350
                                                  : tinggi,
                                              width: 500,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0),
                                                child: ScrollParent(
                                                  controller: _rollCon,
                                                  child: InstansiList(
                                                    a,
                                                    list: snapped.data,
                                                    ipIs: widget.ipIs,
                                                    controller: _rollCon,
                                                    refresh: () {
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                              ));
                                        } catch (e) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                top: 40,
                                                bottom: (tinggi >= 415)
                                                    ? tinggi - 415
                                                    : tinggi),
                                            child: noDataSizedBox(),
                                          );
                                        }
                                      }
                                    }),
                              ),
                              PageControl(_maxPage, newPage: (i) {
                                _lit = (6 * i) - 6;
                                setState(() {});
                              })
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 208, 225, 249),
                          ),
                          margin: EdgeInsets.only(
                              left: (widget.exp) ? 60 : 30, top: 0),
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 110, 181, 192),
                                Color.fromARGB(255, 146, 170, 199)
                              ]),
                            ),
                            child: const Text(
                              "Data Instansi",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 28),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }));
  }
}
