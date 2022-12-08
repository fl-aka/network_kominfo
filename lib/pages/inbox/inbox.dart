import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_kominfo/pages/inbox/inboxdata.dart';
import 'package:network_kominfo/widgetsutils/pagecontrol.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/scroll_parent.dart';

class Inbox extends StatefulWidget {
  final String ipIs;
  final int layanan;
  final bool exp;

  const Inbox(
      {Key? key, required this.ipIs, required this.layanan, required this.exp})
      : super(key: key);

  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  final _rollCon = ScrollController();
  int _lit = 0, _maxPage = 1;
  Color a = getBlueColor();

  Future<void>? _setMaxPage() async {
    try {
      Uri docari =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doProsess.php");
      final responecari = await http.post(docari, body: {
        'action': 'getJumlahData',
        'key': 'RumputJatuh',
        'sql': 'Aminbox',
        'jenis': (widget.layanan == 1)
            ? 'layanan'
            : (widget.layanan == 2)
                ? 'gangguan'
                : 'baru'
      });
      double totalData = double.parse(responecari.body);
      _maxPage = totalData ~/ 6;
      if (totalData % 6 != 0) _maxPage++;
    } catch (e) {
      debugPrint(e.toString());
      _maxPage = 1;
    }
  }

  Future<List> _dataSet(String af) async {
    try {
      Uri dophp =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doProsess.php");
      final respone = await http.post(dophp, body: {
        'action': 'getAllDataInbox',
        'key': 'RumputJatuh',
        'jenis': af,
        'lit': _lit.toString()
      });
      await Future.delayed(const Duration(milliseconds: 500));
      return jsonDecode(respone.body);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 500));
      return <String>[];
    }
  }

  late Color color1;

  @override
  void initState() {
    color1 = getBlueColor();
    super.initState();
    _setMaxPage();
  }

  @override
  Widget build(BuildContext context) {
    String actor = (widget.layanan == 1)
        ? "Layanan"
        : (widget.layanan == 2)
            ? "Gangguan"
            : "Pemasangan Baru";
    final tinggi = MediaQuery.of(context).size.height;
    return FutureBuilder<void>(
        future: _setMaxPage(),
        builder: (context, x) {
          return ListView(
            controller: _rollCon,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(top: 90, right: 20, bottom: 30),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade200),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.home,
                          color: Colors.blue,
                        ),
                        const Text("/ "),
                        const Text(
                          "Inbox ",
                          style: TextStyle(color: Colors.blue),
                        ),
                        Text("/ Inbox $actor")
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
                                future: _dataSet(widget.layanan == 1
                                    ? 'layanan'
                                    : (widget.layanan == 2)
                                        ? "gangguan"
                                        : "baru"),
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
                                              child: InboxList(
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
                      margin:
                          EdgeInsets.only(left: (widget.exp) ? 60 : 30, top: 0),
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
                        child: Text(
                          "Inbox $actor",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 28),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
