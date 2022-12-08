import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_kominfo/model/users.dart';
import 'package:network_kominfo/mysql/allforpetugas.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/scroll_parent.dart';

class LaporLayanan extends StatefulWidget {
  final String ipIs;
  final bool exp;
  final Users user;
  const LaporLayanan(
      {Key? key, required this.ipIs, required this.exp, required this.user})
      : super(key: key);

  @override
  State<LaporLayanan> createState() => _LaporLayananState();
}

class _LaporLayananState extends State<LaporLayanan> {
  bool _telCbx = false,
      _remCbx = false,
      _onsCbx = false,
      _emptyVert = true,
      _cariOn = false;
  final _instanCon = TextEditingController();
  final _kontakCon = TextEditingController();
  final _laporCon = TextEditingController();
  final _namaCon = TextEditingController();
  final _rollCon = ScrollController();
  final _cariCon = TextEditingController();

  String _petugas = "", _ePetugas = "";
  String _petugas2 = "", _ePetugas2 = "";
  List<dynamic>? _vertList;

  void adding() async {
    _vertList = await CapelessHero(action: (just) {
      _emptyVert = just;
    }).getPetugas(widget.ipIs, _cariCon);
    if (_vertList!.length > 5) {
      _cariOn = true;
    }
  }

  @override
  initState() {
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
                      "Layanan ",
                      style: TextStyle(color: Colors.blue),
                    ),
                    Text("/ Pengajuan Layanan")
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
                      future: CapelessHero(action: (just) {
                        _emptyVert = just;
                      }).getPetugas(widget.ipIs, _cariCon),
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
                                      textMng("*Nama Petugas : ", insideBubble),
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
                                      children: [
                                        SizedBox(
                                          height: 47,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _vertList == null
                                                  ? 0
                                                  : _vertList!.length,
                                              itemBuilder: (context, i) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    if (_petugas == "" &&
                                                        _petugas2 == "") {
                                                      _ePetugas = _vertList![i]
                                                          ['email'];
                                                      _petugas =
                                                          _vertList![i]['name'];
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
                                                        _petugas = _petugas2;
                                                        _ePetugas = _ePetugas2;
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
                                                                  _vertList![i][
                                                                      'email'] ||
                                                              _ePetugas2 ==
                                                                  _vertList![i]
                                                                      ['email'])
                                                          ? 0
                                                          : 2,
                                                      color: (_ePetugas ==
                                                                  _vertList![i][
                                                                      'email'] ||
                                                              _ePetugas2 ==
                                                                  _vertList![i]
                                                                      ['email'])
                                                          ? Colors.red
                                                          : Colors.blue,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          _vertList![i]['name'],
                                                          style:
                                                              const TextStyle(
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
                              textMng("*Nama Instansi ", insideBubble),
                              textField(1, _instanCon),
                              textMng("Nama Pengaju ", insideBubble),
                              textField(1, _namaCon),
                              textMng("Kontak Pengaju ", insideBubble),
                              textField(1, _kontakCon),
                              textMng("*Isi Pengajuan ", insideBubble),
                              textField(5, _laporCon),
                              textMng("*Tindak Lanjut : ", insideBubble),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Checkbox(
                                      value: _onsCbx,
                                      onChanged: (val) {
                                        _onsCbx = !_onsCbx;
                                        setState(() {});
                                      }),
                                  const Text(
                                    "On Site",
                                  )
                                ],
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Checkbox(
                                      value: _telCbx,
                                      onChanged: (val) {
                                        _telCbx = !_telCbx;
                                        setState(() {});
                                      }),
                                  const Text(
                                    "Via Telepon",
                                  )
                                ],
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Checkbox(
                                      value: _remCbx,
                                      onChanged: (val) {
                                        _remCbx = !_remCbx;
                                        setState(() {});
                                      }),
                                  const Text(
                                    "Remote",
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 50, left: 50, right: 50, bottom: 30),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      loading(context);
                                      await subFun(context);
                                    },
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(fontSize: 20),
                                    )),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 208, 225, 249),
                ),
                margin: const EdgeInsets.only(left: 30, top: 0.0),
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
                    "Form Pengajuan",
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Future<void> subFun(BuildContext context) async {
    String lanjut = "";
    if (_onsCbx) {
      lanjut += "On Site|";
    }
    if (_telCbx) {
      lanjut += "Telepon|";
    }
    if (_remCbx) {
      lanjut += "Remote|";
    }
    if (_petugas != "" &&
        _instanCon.text != "" &&
        _laporCon.text != "" &&
        lanjut != '') {
      int pan = _petugas.length;
      late String kodePel;
      if (pan >= 2) {
        kodePel = _petugas.substring(0, 2);
      }
      if (pan < 2) {
        kodePel = _petugas.substring(0, 1);
        kodePel += '0';
      }

      if (_onsCbx) {
        kodePel += "Site";
      }
      if (_telCbx) {
        kodePel += "Tele";
      }
      if (_remCbx) {
        kodePel += "Remo";
      }
      String now = DateTime.now().toString();
      kodePel += now.substring(0, 8) + now.substring(9);
      try {
        Uri docari =
            Uri.parse("http://${widget.ipIs}/jaringan/conn/doLayanan.php");
        final respone = await http.post(docari, body: {
          'action': 'addLajuan',
          'key': 'CacingBernyanyi',
          'kodePel': kodePel,
          'jenis': 'layanan',
          'instansi': _instanCon.text,
          'nama': _namaCon.text,
          'kontak': _kontakCon.text,
          'desc': _laporCon.text,
          'tanggal': DateTime.now().toString(),
          'oleh': 'admin',
          'petugas': _ePetugas,
          'petugas2': _ePetugas2,
          'tgl': DateTime.now().toString(),
        });
        String reply = respone.body;
        if (reply == 'SucessSucess') {
          Uri docari =
              Uri.parse("http://${widget.ipIs}/jaringan/conn/doProsess.php");
          final respone1 = await http.post(docari, body: {
            'action': 'AddProgLay',
            'key': 'RumputJatuh',
            'idPel': kodePel,
            'oleh': 'admin',
            'tgl': DateTime.now().toString(),
          });
          String reply = respone1.body;
          if (reply == 'SucessSucess') {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (builder) => AlertDialog(
                      content: const Text("Pengajuan Berhasil Ditambahkan"),
                      title: const Text("Berhasil"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"))
                      ],
                    ));
          } else {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (builder) => AlertDialog(
                      content: Text(reply),
                      title: const Text("Gagal Progress"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"))
                      ],
                    ));
          }
        } else {
          Navigator.pop(context);
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
        Navigator.pop(context);
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
      if (_petugas == "" && _instanCon.text == "" && _laporCon.text == "") {
        kosong += ", nama Instansi dan isi pengajuan kosong";
      } else {
        if (_petugas == "" && (_instanCon.text == "" || _laporCon.text == "")) {
          if (_instanCon.text == "") {
            kosong += " dan nama Instansi masih kosong";
          }
          if (_laporCon.text == "") {
            kosong += " dan isi pengajuan masih kosong";
          }
        } else if (_laporCon.text == "" && _instanCon.text == "") {
          kosong += "Instansi dan isi pengajuan kosong";
        } else {
          if (_instanCon.text == "") {
            kosong += "nama Instansi masih kosong";
          }

          if (_laporCon.text == "") {
            kosong += "isi pengajuan masih kosong";
          }
        }
      }
      Navigator.pop(context);
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
