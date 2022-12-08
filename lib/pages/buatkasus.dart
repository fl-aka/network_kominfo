import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:network_kominfo/widgetsutils/pagecontrol.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/spcbutton.dart';

class InKasus extends StatefulWidget {
  final String ip;
  const InKasus({Key? key, required this.ip}) : super(key: key);

  @override
  State<InKasus> createState() => _InKasusState();
}

class _InKasusState extends State<InKasus> with SingleTickerProviderStateMixin {
  bool _kuantitas = false, _deskripsi = false, _dropDown = false;
  final _masalahCon = TextEditingController();
  final _labelCon = TextEditingController();
  final _label1Con = TextEditingController();
  final _satuanCon = TextEditingController();
  final _rollCon = ScrollController();
  String a = "layanan";
  double angles = 0;

  bool _toZero = true, _toPie = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String _opsi = "";
    if (_toPie) {
      _opsi = "Edit";
    } else {
      _opsi = "Tambah";
    }
    final tinggi = MediaQuery.of(context).size.height;
    TextStyle insideBubble = const TextStyle(fontSize: 16, color: Colors.black);
    return Container(
      padding: const EdgeInsets.only(top: 5, right: 5),
      margin: const EdgeInsets.only(top: 40.0, left: 20),
      child: ListView(
        controller: _rollCon,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
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
                      "Setting Admin ",
                      style: TextStyle(color: Colors.blue),
                    ),
                    Text("/ Opsi Pelaporan")
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children: [
              AnimatedSwitcher(
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    final rotate =
                        Tween(begin: pi, end: 0.0).animate(animation);
                    return AnimatedBuilder(
                        animation: rotate,
                        child: child,
                        builder: (context, child) {
                          final angles = (_toPie)
                              ? min(rotate.value, pi / 2)
                              : rotate.value;
                          return Transform(
                            transform: Matrix4.rotationY(angles),
                            child: child,
                            alignment: Alignment.center,
                          );
                        });
                  },
                  duration: const Duration(milliseconds: 500),
                  child: !_toPie
                      ? Padding(
                          key: const ValueKey<String>('1'),
                          padding: const EdgeInsets.only(top: 50.0, right: 10),
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 50, left: 25, right: 10),
                            height: (tinggi >= 230) ? tinggi - 230 : 574,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(5, 5),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: ListView(
                                  children: [
                                    textMng("Isi Pilihan ", insideBubble),
                                    textField(2, _masalahCon),
                                    textMng("Jenis ", insideBubble),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButton<String>(
                                          isExpanded: true,
                                          onChanged: (val) {
                                            a = val!;
                                            setState(() {});
                                          },
                                          value: a,
                                          items: const [
                                            DropdownMenuItem<String>(
                                                value: "layanan",
                                                child: Text("Layanan")),
                                            DropdownMenuItem<String>(
                                                value: "gangguan",
                                                child: Text("Gangguan")),
                                          ]),
                                    ),
                                    const Divider(),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 8),
                                      child: Text(
                                          "Keterangan Tambahan (Opsional)"),
                                    ),
                                    Row(
                                      children: [
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Checkbox(
                                                value: _kuantitas,
                                                onChanged: (val) {
                                                  _kuantitas = !_kuantitas;
                                                  setState(() {});
                                                }),
                                            const Text(
                                              "Kuantitas",
                                            )
                                          ],
                                        ),
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Checkbox(
                                                value: _deskripsi,
                                                onChanged: (val) {
                                                  _deskripsi = !_deskripsi;
                                                  setState(() {});
                                                }),
                                            const Text(
                                              "Keterangan",
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Checkbox(
                                            value: _dropDown,
                                            onChanged: (val) {
                                              _dropDown = !_dropDown;
                                              setState(() {});
                                            }),
                                        const Text(
                                          "Dropdown",
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                                if (_kuantitas)
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(children: [
                                        const Divider(),
                                        const Text("Setting Kuantitas"),
                                        Row(children: [
                                          const Text("Label"),
                                          const Spacer(),
                                          Expanded(
                                              child: TextField(
                                                  controller: _labelCon))
                                        ]),
                                        Row(children: [
                                          const Text("Satuan"),
                                          const Spacer(),
                                          Expanded(
                                              child: TextField(
                                                  controller: _satuanCon))
                                        ]),
                                        const Divider(),
                                      ]),
                                    ),
                                  ),
                                if (_deskripsi)
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(children: [
                                        const Divider(),
                                        const Text("Setting Keterangan"),
                                        Row(children: [
                                          const Text("Label"),
                                          const Spacer(),
                                          Expanded(
                                              child: TextField(
                                                  controller: _label1Con))
                                        ]),
                                        const Divider(),
                                      ]),
                                    ),
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            loading(context);
                                            submitButton(context);
                                          },
                                          child: const Text(
                                            "Submit",
                                            style: TextStyle(fontSize: 20),
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : TableOfKasus(
                          ipIs: widget.ip,
                          insideBubble: insideBubble,
                        )),
              Row(
                children: [
                  AnimatedContainer(
                    width: _toZero ? 175 : 130,
                    height: 65,
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 208, 225, 249),
                    ),
                    margin: const EdgeInsets.only(left: 20, top: 0.0),
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
                        "$_opsi Opsi ",
                        style:
                            const TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        _toZero = !_toZero;
                        _toPie = !_toPie;
                        setState(() {});
                      },
                      child: StreamBuilder(
                          stream:
                              Stream.periodic(const Duration(microseconds: 30)),
                          builder: (context, snapshot) {
                            if (_toPie && angles < 31.4) {
                              angles += 1;
                            }
                            if (_toZero && angles > 0) {
                              angles -= 1;
                            }
                            if (angles < 0) {
                              angles = 0;
                            }
                            if (angles > 31.4) {
                              angles = 31.4;
                            }
                            return Transform.rotate(
                              angle: angles,
                              child: const Icon(
                                Icons.swap_horiz,
                                color: Color.fromARGB(255, 208, 225, 249),
                                size: 40,
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<void> submitButton(BuildContext context) async {
    try {
      Uri doGo =
          Uri.parse("http://${widget.ip}/jaringan/conn/doPermasalahan.php");
      final respone = await http.post(doGo, body: {
        'action': 'addData',
        'key': 'danLainLain',
        'permasalahan': _masalahCon.text,
        'jenis': a,
        'tgl': DateTime.now().toString(),
      });
      String reply = respone.body;

      if (reply == 'SucessSucess') {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data Berhasil Di Tambahkan")));
      } else {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (builder) => AlertDialog(
                  content: Text("Gagal : $reply"),
                  title: const Text("Gagal"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))
                  ],
                ));
      }
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (builder) => AlertDialog(
                content: Text(e.toString()),
                title: const Text("Error"),
              ));
    }
  }
}

class TableOfKasus extends StatefulWidget {
  final String ipIs;
  final TextStyle insideBubble;
  const TableOfKasus({Key? key, required this.ipIs, required this.insideBubble})
      : super(key: key);

  @override
  _TableOfKasusState createState() => _TableOfKasusState();
}

class _TableOfKasusState extends State<TableOfKasus> {
  int _lit = 0, _maxPage = 1;
  final _cariCon = TextEditingController(text: '');

  Future<void>? _setMaxPage() async {
    try {
      Uri docari = Uri.parse("http://${widget.ipIs}/jaringan/conn/do.php");
      final responecari = await http.post(docari,
          body: {'action': 'getJumlahData', 'key': 'KucingBeintalu'});
      debugPrint(responecari.body);
      double totalData = double.parse(responecari.body);
      _maxPage = totalData ~/ 12;
      if (totalData % 12 != 0 && totalData > 12) _maxPage++;
      if (_maxPage == 0) _maxPage = 1;
    } catch (e) {
      _maxPage = 1;
    }
  }

  Future<List> _dataSet() async {
    try {
      Uri dophp =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doPermasalahan.php");
      final respone = await http.post(dophp, body: {
        'action': 'getSomeData',
        'key': 'danLainLain',
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
    final tinggi = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: _setMaxPage(),
        builder: (context, ss) {
          return Padding(
            key: const ValueKey<String>('2'),
            padding: const EdgeInsets.only(top: 50.0, right: 10),
            child: Container(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 10),
              height: (tinggi >= 230) ? tinggi - 230 : 574,
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(5, 5),
                )
              ], borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 50,
                        width: 500,
                        child: TextField(
                          controller: _cariCon,
                          onChanged: (val) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            hintText: "Cari",
                            suffixIcon: Icon(Icons.search),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: (tinggi >= 330) ? tinggi - 400 : 444,
                    child: ListView(
                      children: [
                        textMng("Table Data ", widget.insideBubble),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        FutureBuilder<List<dynamic>>(
                            future: _dataSet(),
                            builder: (context, ss) {
                              return Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FixedColumnWidth(45),
                                  1: FixedColumnWidth(125),
                                  2: FixedColumnWidth(75),
                                  3: FixedColumnWidth(76)
                                },
                                border: TableBorder.all(),
                                children: [
                                  TableRow(
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlue.shade200),
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text("No"),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text("Opsi"),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text("Jenis"),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text("Action"),
                                          ),
                                        )
                                      ]),
                                  if (ss.hasData)
                                    for (int co = 0; co < ss.data!.length; co++)
                                      TableRow(children: [
                                        Center(
                                            child: Text(
                                                (co + 1 + (_lit)).toString())),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(ss.data![co]
                                                  ['permasalahan'] ??
                                              "Kosong"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(ss.data![co]['jenis'] ??
                                              "Kosong"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 35,
                                                width: 35,
                                                child: spcButton(
                                                    color: const Color.fromARGB(
                                                        255, 110, 181, 192),
                                                    child: const Icon(
                                                      FontAwesomeIcons.edit,
                                                      size: 15,
                                                      color: Colors.white,
                                                    ),
                                                    padding: 5,
                                                    doThisQuick: () {}),
                                              ),
                                              SizedBox(
                                                height: 35,
                                                width: 35,
                                                child: spcButton(
                                                    color: const Color.fromARGB(
                                                        255, 110, 181, 192),
                                                    child: const Icon(
                                                      FontAwesomeIcons.trash,
                                                      size: 15,
                                                      color: Colors.white,
                                                    ),
                                                    padding: 5,
                                                    doThisQuick: () {
                                                      delData(
                                                          ss.data![co]['0']);
                                                      setState(() {});
                                                    }),
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                ],
                              );
                            })
                      ],
                    ),
                  ),
                  PageControl(_maxPage, newPage: (i) {
                    _lit = (12 * i) - 12;
                    setState(() {});
                  })
                ],
              ),
            ),
          );
        });
  }

  Future<void> delData(String iD) async {
    bool lanjut = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Hapus Data Ini?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Iya")),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Tidak")),
              ],
            ));
    if (lanjut) {
      try {
        Uri dophp = Uri.parse(
            "http://${widget.ipIs}/jaringan/conn/doPermasalahan.php");
        final respone = await http.post(dophp, body: {
          'action': 'delData',
          'key': 'danLainLain',
          'id': iD,
        });
        if (respone.body == "Sucess") {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Data Telah Dihapus")));
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
}
