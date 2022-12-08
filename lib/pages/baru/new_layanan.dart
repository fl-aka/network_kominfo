import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_kominfo/mysql/historydata.dart';
import 'package:network_kominfo/widgetsutils/petugas.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/scroll_parent.dart';

class NewLaporLayan extends StatefulWidget {
  final String ipIs;
  final bool layanan;
  final bool admin;
  final List<dynamic>? data;
  const NewLaporLayan(
      {Key? key,
      required this.ipIs,
      required this.layanan,
      required this.data,
      this.admin = false})
      : super(key: key);

  @override
  State<NewLaporLayan> createState() => _NewLaporLayanState();
}

class _NewLaporLayanState extends State<NewLaporLayan> {
  final _instanCon = TextEditingController();
  final _kontakCon = TextEditingController();
  final _namaCon = TextEditingController();
  final _lainnyaCon = TextEditingController();
  final _rollCon = ScrollController();
  final _childCon = ScrollController();

  String _laporan = "", _ePetugas = "", _ePetugas2 = "";

  int _forever = 1;
  bool _lainnya = false;
  bool _permintaaan = true;
  bool _noTelp = true, _eml = false;

  List<String>? recorder = [""];
  late List<String>? list = [];
  final _distraction = FocusNode();

  @override
  void initState() {
    try {
      recorder![0] = widget.data![0]['permasalahan'];
      for (int i = 0; i < widget.data!.length; i++) {
        list!.add(widget.data![i]['permasalahan']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    String actor = "Pelaporan Gangguan", act = "Pelapor";
    if (widget.layanan) {
      actor = "Permintaan Layanan";
      act = "Pengaju";
    }
    TextStyle insideBubble = const TextStyle(fontSize: 16, color: Colors.black);
    return Scaffold(
      backgroundColor:
          widget.admin ? const Color.fromARGB(0, 1, 1, 1) : Colors.indigo,
      body: Container(
        padding: const EdgeInsets.only(top: 5, right: 5),
        margin: EdgeInsets.only(top: widget.admin ? 62.0 : 40, left: 20),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (context) {
            context.disallowIndicator();
            return false;
          },
          child: ListView(
            controller: _rollCon,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        right: 20, bottom: widget.admin ? 20 : 35),
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
                        Text("/ $actor")
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
                      padding:
                          const EdgeInsets.only(top: 50, left: 30, right: 10),
                      height: (tinggi >= 640)
                          ? widget.admin
                              ? tinggi - 230
                              : tinggi - 220
                          : 640,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              offset: Offset(5, 5),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: ScrollParent(
                        controller: _rollCon,
                        child: ListView(
                          controller: _childCon,
                          children: [
                            textMng("Nama Instansi ", insideBubble),
                            textField(1, _instanCon),
                            textMng("Nama $act ", insideBubble),
                            textField(1, _namaCon),
                            textMng("Kontak $act ", insideBubble),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: _noTelp,
                                      onChanged: (val) async {
                                        _kontakCon.text = "";
                                        _noTelp = !_noTelp;
                                        _eml = !_eml;
                                        if (_distraction.hasFocus) {
                                          _distraction.unfocus();
                                          await Future.delayed(const Duration(
                                              milliseconds: 400));
                                          _distraction.requestFocus();
                                        }
                                        setState(() {});
                                      }),
                                  const Text("No Telp"),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Checkbox(
                                      value: _eml,
                                      onChanged: (val) async {
                                        _kontakCon.text = "";
                                        _noTelp = !_noTelp;
                                        _eml = !_eml;
                                        if (_distraction.hasFocus) {
                                          _distraction.unfocus();
                                          await Future.delayed(const Duration(
                                              milliseconds: 400));
                                          _distraction.requestFocus();
                                        }
                                        setState(() {});
                                      }),
                                  const Text("Email"),
                                ],
                              ),
                            ),
                            textField(1, _kontakCon,
                                focus: _distraction,
                                mode: _noTelp
                                    ? TextInputType.phone
                                    : TextInputType.emailAddress),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: textMng(
                                      (widget.layanan)
                                          ? "Isi Permintaan "
                                          : "Isi Pelaporan ",
                                      insideBubble),
                                ),
                                if (_lainnya)
                                  Checkbox(
                                      value: _permintaaan,
                                      onChanged: (val) {
                                        _permintaaan = val!;
                                        setState(() {});
                                      })
                              ],
                            ),
                            Stack(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  height: _permintaaan ? 150 : 0,
                                  margin: const EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: !_permintaaan
                                      ? null
                                      : ScrollParent(
                                          controller: (tinggi < 640)
                                              ? _rollCon
                                              : _childCon,
                                          child: ListView.builder(
                                              itemCount: _forever,
                                              itemBuilder: (context, i) {
                                                if (recorder!.length <
                                                    _forever) {
                                                  recorder!.add(list![i]);
                                                }
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: DropdownButton<String>(
                                                      isExpanded: true,
                                                      onChanged: (val) {
                                                        recorder![i] = val!;
                                                        setState(() {});
                                                      },
                                                      value: recorder![i],
                                                      items: list!.map((value) {
                                                        return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList()),
                                                );
                                              }),
                                        ),
                                ),
                                if (_permintaaan)
                                  Positioned(
                                      right: 30,
                                      bottom: 0,
                                      child: Row(
                                        children: [
                                          if (_forever < list!.length)
                                            GestureDetector(
                                              onTap: () {
                                                _forever++;
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all()),
                                                child: const Icon(Icons.add),
                                              ),
                                            ),
                                          if (_forever > 1)
                                            GestureDetector(
                                              onTap: () {
                                                _forever--;
                                                recorder!.removeLast();
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all()),
                                                child: const Icon(Icons.remove),
                                              ),
                                            ),
                                        ],
                                      ))
                              ],
                            ),
                            Wrap(
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        value: _lainnya,
                                        onChanged: (val) {
                                          _lainnya = val!;
                                          if (!val) {
                                            _permintaaan = true;
                                          }
                                          setState(() {});
                                        }),
                                    Text("$actor Lainnya")
                                  ],
                                ),
                                textField(1, _lainnyaCon,
                                    enabled: _lainnya, maxs: 100),
                              ],
                            ),
                            if (widget.admin)
                              PetugasList(
                                ipIs: widget.ipIs,
                                petugas1: (val) {
                                  _ePetugas = val;
                                },
                                petugas2: (val) {
                                  _ePetugas2 = val;
                                },
                              ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 50, left: 50, right: 50, bottom: 30),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    loading(context);
                                    await subFun(context);
                                  },
                                  child: const Text(
                                    "Kirim",
                                    style: TextStyle(fontSize: 20),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
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
                        "Form $actor",
                        style:
                            const TextStyle(fontSize: 25, color: Colors.white),
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
        ),
      ),
    );
  }

  Future<void> subFun(BuildContext context) async {
    _laporan = "";
    if (_permintaaan) {
      for (int i = 0; i < _forever; i++) {
        _laporan += "${recorder![i]}, ";
      }
    }
    if (_lainnya) {
      _laporan += _lainnyaCon.text;
    }

    if (_namaCon.text != "" &&
        _kontakCon.text != "" &&
        _instanCon.text != "" &&
        _laporan != "") {
      String actor = "Pelaporan Gangguan";
      if (widget.layanan) {
        actor = "Permintaan Layanan";
      }
      String gen = (_instanCon.text.length > 3)
          ? _instanCon.text.substring(0, 3)
          : _instanCon.text;
      String kodePel = gen;
      int last = 0;
      String now = DateTime.now().toString();
      for (int i = 0; i < now.length; i++) {
        if (now[i] == ' ' || now[i] == ':' || now[i] == '.') {
          if (last != 0) last++;
          kodePel += now.substring(last, i);
          last = i;
        }
      }

      kodePel += now.substring(last + 1, now.length);

      kodePel += (widget.layanan) ? "Lay" : "Gan";
      try {
        Uri docari =
            Uri.parse("http://${widget.ipIs}/jaringan/conn/doLayanan.php");
        final respone = await http.post(docari, body: {
          'action': 'addLajuan',
          'key': 'CacingBernyanyi',
          'kodePel': kodePel,
          'jenis': (widget.layanan) ? 'layanan' : 'gangguan',
          'instansi': _instanCon.text,
          'nama': _namaCon.text,
          'kontak': _kontakCon.text,
          'desc': _laporan,
          'oleh': widget.admin ? 'admin' : 'skpd',
          'tanggal': DateTime.now().toString(),
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
            'tgl': DateTime.now().toString(),
          });
          String reply = respone1.body;
          if (reply == 'SucessSucess') {
            if (_permintaaan) {
              for (int i = 0; i < _forever; i++) {
                Uri doMe = Uri.parse(
                    "http://${widget.ipIs}/jaringan/conn/doLayanan.php");
                await http.post(doMe, body: {
                  'action': 'addKonlap',
                  'key': 'CacingBernyanyi',
                  'kodePel': kodePel,
                  'masalah': recorder![i],
                });
              }
            }
            // if (_lainnya) {
            //   _laporan += _lainnyaCon.text;
            // }
            if (widget.admin && _ePetugas != "") {
              debugPrint(_ePetugas);
              _tombolKirim(kodePel);
            }

            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (builder) => AlertDialog(
                      content: Text("$actor Berhasil Ditambahkan"),
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
    }
  }

  Future<void> _tombolKirim(String kode) async {
    try {
      Uri dophp =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doLayanan.php");
      final respone = await http.post(dophp, body: {
        'action': 'upPetugas',
        'key': 'CacingBernyanyi',
        'kodePel': kode,
        'petugas': _ePetugas,
        'petugas2': _ePetugas2,
        'tgl': DateTime.now().toString()
      });
      if (respone.body == "SucessSucess") {
        const HisAction().kirimPet(widget.ipIs, kode, context);
        _ePetugas = "";
        _ePetugas2 = "";
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
