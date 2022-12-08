import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:network_kominfo/pages/kalender/kalender_data.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/scroll_parent.dart';

class Kalender extends StatefulWidget {
  final String ipIs;
  final bool exp;
  const Kalender({Key? key, required this.ipIs, required this.exp})
      : super(key: key);

  @override
  _KalenderState createState() => _KalenderState();
}

class _KalenderState extends State<Kalender> {
  Color blue = getBlueColor();
  final _rollCon = ScrollController();
  List<String> lisTahun = [];
  String tahun = '';

  Future<void> _getTahun() async {
    lisTahun = await _setTahun();
    tahun = lisTahun[0];
  }

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: _getTahun(),
        builder: (context, ss) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.only(top: 5, right: 5),
            margin: EdgeInsets.only(top: 80.0, left: widget.exp ? 50 : 5),
            child: ListView(
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
                            "Kalender ",
                            style: TextStyle(color: Colors.blue),
                          ),
                          Text("/ Data Bulanan")
                        ],
                      ),
                    ),
                  ],
                ),
                Stack(
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
                          top: 55, left: 20, right: 10, bottom: 5),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: FutureBuilder<List>(
                                future: _getData(),
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
                                              child: KalenderList(
                                                blue,
                                                list: snapped.data,
                                                controller: _rollCon,
                                                ipIs: widget.ipIs,
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
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 241,
                      height: 128,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            bottom: 30,
                            child: Container(
                              height: 60,
                              width: 135,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 208, 225, 249),
                              ),
                            ),
                          ),
                          Container(
                            height: 70,
                            width: 193,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 208, 225, 249),
                            ),
                            margin: const EdgeInsets.only(left: 30),
                            padding: const EdgeInsets.all(11),
                            child: Container(
                              color: Colors.black,
                              padding: const EdgeInsets.all(1),
                            ),
                          ),
                          Positioned(
                            right: 7,
                            bottom: 39,
                            child: Container(
                              height: 42,
                              width: 117,
                              color: Colors.black,
                            ),
                          ),
                          Positioned(
                              top: 12,
                              right: 30,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color.fromARGB(255, 110, 181, 192),
                                    Color.fromARGB(255, 146, 170, 199)
                                  ]),
                                ),
                                child: const Text(
                                  "Data Bulanan",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 28),
                                ),
                              )),
                          Positioned(
                            right: 8,
                            bottom: 10,
                            child: Container(
                              height: 40,
                              width: 115,
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 30),
                              padding: const EdgeInsets.only(left: 10),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 110, 181, 192),
                                  Color.fromARGB(255, 146, 170, 199)
                                ]),
                              ),
                            ),
                          ),
                          Positioned(
                              right: 6,
                              bottom: 35,
                              child: Row(
                                children: [
                                  const Text("Tahun : ",
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                  DropdownButton<String>(
                                      onChanged: (val) {
                                        tahun = val!;
                                        setState(() {});
                                      },
                                      value: tahun,
                                      items: lisTahun.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        );
                                      }).toList()),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<List<String>> _setTahun() async {
    List<String> returner = [];
    try {
      Uri doInlay =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doBulanan.php");
      final respone = await http.post(doInlay, body: {
        'action': 'getTahun',
        'key': 'NewMewVolve',
      });
      List<dynamic> list = jsonDecode(respone.body);

      for (int i = 0; i < list.length; i++) {
        returner.add(list[i]['tanggal'].toString().substring(0, 4));
      }
      return returner;
    } catch (e) {
      return <String>[DateTime.now().year.toString()];
    }
  }

  Future<List<dynamic>> _getData() async {
    try {
      Uri doInlay =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doBulanan.php");
      final respone = await http.post(doInlay,
          body: {'action': 'getData', 'key': 'NewMewVolve', 'tahun': tahun});
      List<dynamic> list = jsonDecode(respone.body);
      return list;
    } catch (e) {
      return <String>[];
    }
  }
}
