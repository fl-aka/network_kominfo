import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_kominfo/pages/dashBoardMenu/itemlist.dart';
import 'package:network_kominfo/widgetsutils/pagecontrol.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';

//Page Nomor 7

class Gangguan extends StatefulWidget {
  final String ipIs;
  const Gangguan({Key? key, required this.ipIs}) : super(key: key);

  @override
  State<Gangguan> createState() => _GangguanState();
}

class _GangguanState extends State<Gangguan> {
  int _lit = 0, _maxPage = 1;
  final _cariCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final lebar = MediaQuery.of(context).size.width;
    final tinggi = MediaQuery.of(context).size.height;

    Future<void>? _setMaxPage() async {
      try {
        Uri docari =
            Uri.parse("http://${widget.ipIs}/jaringan/conn/doProsess.php");
        final responecari = await http.post(docari, body: {
          'action': 'getJumlahData',
          'key': 'RumputJatuh',
          'sql': 'Gangguan'
        });

        double totalData = (jsonDecode(responecari.body)).toDouble();
        _maxPage = totalData ~/ 6;
        if (totalData % 6 != 0) _maxPage++;
      } catch (e) {
        debugPrint(e.toString());
        _maxPage = 1;
      }
    }

    Future<List> dataSet() async {
      try {
        Uri dophp =
            Uri.parse("http://${widget.ipIs}/jaringan/conn/doLayanan.php");
        final respone = await http.post(dophp, body: {
          'action': 'getAllData',
          'key': 'CacingBernyanyi',
          'jenis': 'gangguan',
          'lit': _lit.toString(),
          'cari': _cariCon.text
        });
        return jsonDecode(respone.body);
      } catch (e) {
        return <String>[];
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 80),
      child: ListView(
        children: [
          Wrap(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: (lebar > 400)
                        ? 320
                        : (lebar >= 80)
                            ? lebar - 80
                            : lebar,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: (lebar > 400) ? 270 : lebar - 130,
                          child: TextField(
                            controller: _cariCon,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)))),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: const Icon(Icons.search))
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20, top: 20),
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
                          "Gangguan Selesai",
                          style: TextStyle(color: Colors.blue),
                        ),
                        Text("/ Data")
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
            height: tinggi > 250 ? tinggi - 250 : tinggi,
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(color: Colors.black26, offset: Offset(4, 8))
            ], borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: FutureBuilder(
                future: _setMaxPage(),
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      FutureBuilder<List>(
                        future: dataSet(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.toString()),
                            );
                          } else {
                            if (snapshot.data == null) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: 15,
                                    bottom: (tinggi >= 355)
                                        ? tinggi - 355
                                        : tinggi),
                                child: noDataSizedBox(),
                              );
                            }
                            return SizedBox(
                                height: (tinggi > 350) ? tinggi - 315 : tinggi,
                                width: lebar,
                                child: ItemList(
                                  "Gangguan",
                                  list: snapshot.data,
                                  ipIs: widget.ipIs,
                                  refresh: () {
                                    setState(() {});
                                  },
                                ));
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PageControl(_maxPage, newPage: (i) {
                          _lit = (6 * i) - 6;
                          setState(() {});
                        }),
                      )
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
