import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:network_kominfo/model/users.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:http/http.dart' as http;

class InsideGanEdit extends StatefulWidget {
  final String id;
  final Users user;
  final String ipIs;
  final String jenis;
  final String instansi;
  final String? kontak;
  final String? nama;
  final String lapor;
  final String date;
  final String lanjut;
  final String ePet;
  final String ePet2;
  const InsideGanEdit(this.id, this.jenis,
      {Key? key,
      required this.user,
      required this.ipIs,
      required this.instansi,
      required this.kontak,
      required this.nama,
      required this.lapor,
      required this.date,
      required this.lanjut,
      required this.ePet,
      required this.ePet2})
      : super(key: key);

  @override
  State<InsideGanEdit> createState() => _InsideGanEditState();
}

class _InsideGanEditState extends State<InsideGanEdit> {
  bool _telCbx = false,
      _remCbx = false,
      _onsCbx = false,
      _emptyVert = true,
      _cariOn = false;
  final _instanCon = TextEditingController();
  final _kontakCon = TextEditingController();
  final _namaCon = TextEditingController();
  final _laporCon = TextEditingController();
  final _cariCon = TextEditingController();
  static late String _actor, _kegiatan;
  late DateTime pickDate;
  String _petugas = "", _ePetugas = "";
  String _petugas2 = "", _ePetugas2 = "";
  List<dynamic>? _vertList;

  void adding() async {
    _vertList = await _getPetugas(widget.ipIs);
    if (_vertList!.length > 5) {
      _cariOn = true;
    }
    _instanCon.text = widget.instansi;
    if (widget.nama != null) {
      _namaCon.text = widget.nama!;
    }
    if (widget.kontak != null) {
      _kontakCon.text = widget.kontak!;
    }
    _laporCon.text = widget.lapor;

    List<String>? cek = [];
    int last = 0;
    for (int i = 0; i < widget.lanjut.length; i++) {
      if (widget.lanjut[i] == '|') {
        if (last != 0) last++;
        cek.add(widget.lanjut.substring(last, i));
        last = i;
      }
    }
    for (int i = 0; i < cek.length; i++) {
      if (cek[i] == "On Site") {
        _onsCbx = true;
      }
      if (cek[i] == "Telepon") {
        _telCbx = true;
      }
      if (cek[i] == "Remote") {
        _remCbx = true;
      }
    }
  }

  @override
  initState() {
    if (widget.jenis == "gangguan") {
      _actor = "Pelapor";
      _kegiatan = "Gangguan";
    } else {
      _actor = "Pengaju";
      _kegiatan = "Pengajuan";
    }
    pickDate = DateTime.parse(widget.date);
    adding();
    _ePetugas = widget.ePet;
    _ePetugas2 = widget.ePet2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    TextStyle insideBubble = const TextStyle(fontSize: 20, color: Colors.black);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 70.0, right: 10),
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 30, right: 10),
            height: (tinggi >= 600) ? tinggi - 260 : 600,
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(5, 5),
              )
            ], borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: FutureBuilder<List>(
                future: _getPetugas(widget.ipIs),
                builder: (context, snapshoot) {
                  _vertList = snapshoot.data;
                  if (_vertList != null) {
                    for (int i = 0; i < _vertList!.length; i++) {
                      if (_vertList![i]['email'] == _ePetugas) {
                        _petugas = _vertList![i]['name'];
                      }
                    }
                  }
                  return ListView(
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
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
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
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.blue)),
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 47,
                                  width: MediaQuery.of(context).size.width,
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
                                              _ePetugas =
                                                  _vertList![i]['email'];
                                              _petugas = _vertList![i]['name'];
                                            } else if (_petugas2 == "") {
                                              if (_petugas !=
                                                  _vertList![i]['name']) {
                                                _ePetugas2 =
                                                    _vertList![i]['email'];
                                                _petugas2 =
                                                    _vertList![i]['name'];
                                              } else {
                                                _petugas = "";
                                                _ePetugas = "";
                                              }
                                            } else {
                                              if (_petugas ==
                                                  _vertList![i]['name']) {
                                                _petugas = _petugas2;
                                                _ePetugas = _ePetugas2;
                                                _petugas2 = "";
                                                _ePetugas2 = "";
                                              }
                                              if (_petugas2 ==
                                                  _vertList![i]['name']) {
                                                _petugas2 = "";
                                                _ePetugas2 = "";
                                              }
                                            }
                                            setState(() {});
                                          },
                                          child: Tooltip(
                                            message: _vertList![i]['email'],
                                            child: Card(
                                              elevation: (_ePetugas ==
                                                          _vertList![i]
                                                              ['email'] ||
                                                      _ePetugas2 ==
                                                          _vertList![i]
                                                              ['email'])
                                                  ? 0
                                                  : 2,
                                              color: (_ePetugas ==
                                                          _vertList![i]
                                                              ['email'] ||
                                                      _ePetugas2 ==
                                                          _vertList![i]
                                                              ['email'])
                                                  ? Colors.red
                                                  : Colors.blue,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  _vertList![i]['name'],
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                if (_cariOn)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 36,
                                          width: 180,
                                          child: TextField(
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            decoration: InputDecoration(
                                                prefixIcon: const Icon(
                                                  Icons.search,
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
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
                      textMng("Nama $_actor", insideBubble),
                      textField(1, _namaCon),
                      textMng("Kontak $_actor", insideBubble),
                      textField(1, _kontakCon),
                      textMng("*Isi $_kegiatan ", insideBubble),
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
                      textMng("*Tanggal ", insideBubble),
                      Container(
                        color: Colors.grey.shade200,
                        child: ListTile(
                          onTap: _pickDate,
                          title: Text(
                            "${pickDate.day}, ${pickDate.month}, ${pickDate.year}",
                            style: const TextStyle(fontSize: 20),
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 50, left: 50, right: 50, bottom: 30),
                        child: ElevatedButton(
                            onPressed: () async {
                              loading(context);
                              await subMethod(context, "gangguan");
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(fontSize: 20),
                            )),
                      )
                    ],
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
              gradient: LinearGradient(
                  colors: [Colors.green.shade500, Colors.green.shade600]),
            ),
            child: Text(
              "Edit Form $_kegiatan",
              style: const TextStyle(color: Colors.white, fontSize: 28),
            ),
          ),
        ),
      ],
    );
  }

  Future<List> _getPetugas(String _aIPhi) async {
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

  void _pickDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 10));
    if (date != null) {
      setState(() {
        pickDate = date;
      });
    }
  }

  Future<void> subMethod(BuildContext context, String jenis) async {
    {
      if (_petugas != "" && _instanCon.text != "" && _laporCon.text != "") {
        try {
          Uri dophp =
              Uri.parse("http://${widget.ipIs}/jaringan/conn/doLayanan.php");
          final respone = await http.post(dophp, body: {
            'action': 'upLayan',
            'key': 'CacingBernyanyi',
            'kodePel': widget.id,
            'instansi': _instanCon.text,
            'kontak': _kontakCon.text,
            'desc': _laporCon.text,
            'tanggal': pickDate.toString(),
            'user': widget.user.email,
            'petugas': _ePetugas,
            'petugas2': _ePetugas2,
            'tgl': DateTime.now().toString(),
          });
          String reply = respone.body;
          if (reply == 'SucessSucess') {
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

            Uri doProgLay =
                Uri.parse("http://${widget.ipIs}/jaringan/conn/doProsess.php");

            final respone1 = await http.post(doProgLay, body: {
              'action': 'UpProgLay',
              'key': 'RumputJatuh',
              'idPel': widget.id,
              'lanjut': lanjut,
              'user': widget.user.email,
              'tgl': DateTime.now().toString(),
            });
            String reply = respone1.body;
            if (reply == 'SucessSucess') {
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (builder) => AlertDialog(
                        content: const Text("Isi Pelaporan Berhasil Di ubah"),
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
              Navigator.of(context).pop();
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
        if (_petugas == "" && _instanCon.text == "" && _laporCon.text == "") {
          kosong += ", nama Instansi dan isi Laporan kosong";
        } else {
          if (_petugas == "" &&
              (_instanCon.text == "" || _laporCon.text == "")) {
            if (_instanCon.text == "") {
              kosong += " dan nama Instansi masih kosong";
            }
            if (_laporCon.text == "") {
              kosong += " dan isi $_kegiatan masih kosong";
            }
          } else if (_laporCon.text == "" && _instanCon.text == "") {
            kosong += "Instansi dan isi $_kegiatan kosong";
          } else {
            if (_instanCon.text == "") {
              kosong += "nama Instansi masih kosong";
            }

            if (_laporCon.text == "") {
              kosong += "isi $_kegiatan masih kosong";
            }
          }
        }

        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (builder) => AlertDialog(
                  content: Text(kosong),
                  title: const Text("Mohon Isi Yang Perlu (*)"),
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
