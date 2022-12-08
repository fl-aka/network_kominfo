import 'dart:convert';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_kominfo/model/users.dart';
import 'package:network_kominfo/widgetsutils/scroll_parent.dart';

class Event extends StatefulWidget {
  final String ipIs;
  final bool exp;
  final Users user;
  const Event(
      {Key? key, required this.ipIs, required this.exp, required this.user})
      : super(key: key);

  @override
  State<Event> createState() => _LaporLayananState();
}

class _LaporLayananState extends State<Event> {
  bool _emptyVert = true, _cariOn = false;
  final _namaEventCon = TextEditingController();
  final _tempatCon = TextEditingController();
  final _kendalaCon = TextEditingController();
  final _rollCon = ScrollController();
  final _alatCon = TextEditingController();
  final _cariCon = TextEditingController();
  late DateTime pickDate;
  late DateTime pickDate1;
  List<dynamic>? _vertList;

  String _petugas = "", _ePetugas = "";
  String _petugas2 = "", _ePetugas2 = "";

  Future<List> getPetugas(String _aIPhi) async {
    try {
      Uri dophp = Uri.parse("http://$_aIPhi/jaringan/conn/doPetugas.php");
      final respone = await http.post(dophp, body: {
        'key': 'RahasiaIlahi',
        'action': 'getData',
        'cari': _cariCon.text
      });
      List<dynamic> list = jsonDecode(respone.body);
      if (list.isNotEmpty) {
        _emptyVert = false;
      }
      return list;
    } catch (e) {
      _emptyVert = true;
      return <String>[];
    }
  }

  void adding() async {
    _vertList = await getPetugas(widget.ipIs);
    if (_vertList!.length > 5) {
      _cariOn = true;
    }
  }

  @override
  initState() {
    pickDate = DateTime.now();
    pickDate1 = DateTime.now();
    adding();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    TextStyle insideBubble = const TextStyle(fontSize: 20, color: Colors.black);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.only(top: 5, right: 5),
      margin: EdgeInsets.only(top: 80.0, left: widget.exp ? 50 : 20),
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
                      "Event ",
                      style: TextStyle(color: Colors.blue),
                    ),
                    Text("/ Pelaporan Event")
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, right: 10),
                child: Container(
                  padding: const EdgeInsets.only(top: 10, left: 30, right: 10),
                  height: (tinggi >= 600) ? tinggi - 260 : 600,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          offset: Offset(5, 5),
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: FutureBuilder<List>(
                      future: getPetugas(widget.ipIs),
                      builder: (context, snapshoot) {
                        _vertList = snapshoot.data;
                        return ScrollParent(
                          controller: _rollCon,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      textMng("Nama Petugas : ", insideBubble),
                                      Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            _petugas2 == ""
                                                ? _petugas
                                                : "$_petugas dan $_petugas2",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.blue))
                                    ],
                                  ),
                                ),
                              ),
                              (_emptyVert)
                                  ? Row(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.all(8),
                                            padding: const EdgeInsets.all(8),
                                            child: const Text(
                                              "Tidak Ada Data Petugas",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.blue)),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (_vertList!.isEmpty)
                                            ? Container(
                                                margin: const EdgeInsets.all(8),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: const Text(
                                                  "Petugas Tidak Ditemukan",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.blue))
                                            : SizedBox(
                                                height: 47,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: _vertList == null
                                                        ? 0
                                                        : _vertList!.length,
                                                    itemBuilder: (context, i) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (_petugas == "" &&
                                                              _petugas2 == "") {
                                                            _ePetugas =
                                                                _vertList![i]
                                                                    ['email'];
                                                            _petugas =
                                                                _vertList![i]
                                                                    ['name'];
                                                          } else if (_petugas2 ==
                                                              "") {
                                                            if (_petugas !=
                                                                _vertList![i]
                                                                    ['name']) {
                                                              _ePetugas2 =
                                                                  _vertList![i]
                                                                      ['email'];
                                                              _petugas2 =
                                                                  _vertList![i]
                                                                      ['name'];
                                                            } else {
                                                              _petugas = "";
                                                              _ePetugas = "";
                                                            }
                                                          } else {
                                                            if (_petugas ==
                                                                _vertList![i]
                                                                    ['name']) {
                                                              _petugas =
                                                                  _petugas2;
                                                              _ePetugas =
                                                                  _ePetugas2;
                                                              _petugas2 = "";
                                                              _ePetugas2 = "";
                                                            }
                                                            if (_petugas2 ==
                                                                _vertList![i]
                                                                    ['name']) {
                                                              _petugas2 = "";
                                                              _ePetugas2 = "";
                                                            }
                                                          }
                                                          setState(() {});
                                                        },
                                                        child: Tooltip(
                                                          message: _vertList![i]
                                                              ['email'],
                                                          child: Card(
                                                            elevation: (_ePetugas ==
                                                                        _vertList![i]
                                                                            [
                                                                            'email'] ||
                                                                    _ePetugas2 ==
                                                                        _vertList![i]
                                                                            [
                                                                            'email'])
                                                                ? 0
                                                                : 2,
                                                            color: (_ePetugas ==
                                                                        _vertList![i]
                                                                            [
                                                                            'email'] ||
                                                                    _ePetugas2 ==
                                                                        _vertList![i]
                                                                            [
                                                                            'email'])
                                                                ? Colors.red
                                                                : Colors.blue,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                _vertList![i]
                                                                    ['name'],
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                        if (_cariOn)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 36,
                                                  width: 180,
                                                  child: TextField(
                                                    onChanged: (val) {
                                                      setState(() {});
                                                    },
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .bottom,
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                    decoration: InputDecoration(
                                                        prefixIcon: const Icon(
                                                          Icons.search,
                                                        ),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        hintText: "Cari..."),
                                                    controller: _cariCon,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                              textMng("*Nama Acara ", insideBubble),
                              textField(2, _namaEventCon),
                              textMng("*Tempat ", insideBubble),
                              textField(3, _tempatCon),
                              textMng("*Tanggal ", insideBubble),
                              Container(
                                color: Colors.grey.shade200,
                                child: ListTile(
                                  onTap: _pickDate,
                                  title: Text(
                                    "${pickDate.day}, ${pickDate.month}, ${pickDate.year}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  trailing:
                                      const Icon(Icons.keyboard_arrow_down),
                                ),
                              ),
                              textMng("*Tanggal Selesai", insideBubble),
                              Container(
                                color: Colors.grey.shade200,
                                child: ListTile(
                                  onTap: _pickDate1,
                                  title: Text(
                                    "${pickDate1.day}, ${pickDate1.month}, ${pickDate1.year}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  trailing:
                                      const Icon(Icons.keyboard_arrow_down),
                                ),
                              ),
                              const Divider(),
                              Container(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10),
                                  child: textMng("Information ", insideBubble)),
                              textMng("Alat ", insideBubble),
                              textField(4, _alatCon),
                              textMng("Kendala ", insideBubble),
                              textField(4, _kendalaCon),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 50, left: 50, right: 50, bottom: 30),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      loading(context);
                                      await subMethod(context);
                                    },
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(fontSize: 20),
                                    )),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                  ),
                  margin: const EdgeInsets.only(left: 30, top: 0.0),
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      gradient: LinearGradient(colors: [
                        Colors.green.shade500,
                        Colors.green.shade600
                      ]),
                    ),
                    child: const Text(
                      "Form Event",
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  void _pickDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 5));
    if (date != null) {
      setState(() {
        pickDate = date;
      });
    }
  }

  void _pickDate1() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 5));
    if (date != null) {
      setState(() {
        pickDate = date;
      });
    }
  }

  Future<void> subMethod(BuildContext context) async {
    {
      if (_petugas != "" && _namaEventCon.text != "" && _tempatCon.text != "") {
        String kodeEve = _petugas.substring(0, 2);

        String now = DateTime.now().toString();
        kodeEve += now.substring(0, 8) + now.substring(9);

        try {
          Uri docari =
              Uri.parse("http://${widget.ipIs}/jaringan/conn/doEvent.php");
          final respone = await http.post(docari, body: {
            'action': 'AddEve',
            'key': 'AirBasi',
            'kode': kodeEve,
            'nama': _namaEventCon.text,
            'tempat': _tempatCon.text,
            'user': widget.user.email,
            'petugas': _ePetugas,
            'tglml': pickDate.toString(),
            'tglsl': pickDate1.toString(),
            'tgl': DateTime.now().toString(),
          });
          String reply = respone.body;

          if (reply == 'SucessSucess') {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (builder) => AlertDialog(
                      content: const Text("Berhasil"),
                      title: const Text("Pelaporan Berhasil Ditambahkan"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"))
                      ],
                    ));
          } else {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (builder) => AlertDialog(
                      content: Text(reply),
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
      } else {
        String kosong = "";
        if (_petugas == "") {
          kosong += "Petugas Belum Di pilih";
        }
        if (_petugas == "" &&
            _namaEventCon.text == "" &&
            _tempatCon.text == "") {
          kosong += ", nama event dan tempat event kosong";
        } else {
          if (_petugas == "" &&
              (_namaEventCon.text == "" || _tempatCon.text == "")) {
            if (_namaEventCon.text == "") {
              kosong += "dan nama event masih kosong";
            }

            if (_namaEventCon.text == "") {
              kosong += "dan tempat event masih kosong";
            }
          }

          if (_namaEventCon.text == "" && _tempatCon.text == "") {
            kosong += ", nama event dan tempat event kosong";
          } else {
            if (_namaEventCon.text == "") {
              kosong += "nama event masih kosong";
            }

            if (_namaEventCon.text == "") {
              kosong += "tempat event masih kosong";
            }
          }
        }

        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (builder) => AlertDialog(
                  content: Text(kosong),
                  title: const Text("Mohon Isi (*)"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))
                  ],
                ));
      }
    }
  }
}
