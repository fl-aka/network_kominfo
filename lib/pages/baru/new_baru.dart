import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_kominfo/mysql/historydata.dart';
import 'package:network_kominfo/widgetsutils/petugas.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/scroll_parent.dart';

class NewLaporBaru extends StatefulWidget {
  final String ipIs;
  final bool admin;
  final bool exp;
  const NewLaporBaru({
    Key? key,
    required this.ipIs,
    this.admin = false,
    this.exp = false,
  }) : super(key: key);

  @override
  State<NewLaporBaru> createState() => _NewLaporBaruState();
}

class _NewLaporBaruState extends State<NewLaporBaru> {
  final _spdCon = TextEditingController();
  final _instanCon = TextEditingController();
  final _kontakCon = TextEditingController();
  final _alamatCon = TextEditingController();
  final _namaCon = TextEditingController();
  final _kontakOrgCon = TextEditingController();
  final _rollCon = ScrollController();
  final _childCon = ScrollController();

  bool _noTelp = true, _eml = false;
  bool _noTelp2 = true, _eml2 = false, _sama = false;

  String _ePetugas = "", _ePetugas2 = "";
  late List<String>? list = [];
  final _distraction = FocusNode();
  final _distractions = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _distraction.dispose();
    _distractions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;

    TextStyle insideBubble = const TextStyle(fontSize: 16, color: Colors.black);
    return Scaffold(
      backgroundColor:
          widget.admin ? const Color.fromARGB(0, 1, 1, 1) : Colors.indigo,
      body: Container(
        padding: const EdgeInsets.only(top: 5, right: 5),
        margin: EdgeInsets.only(top: widget.admin ? 70.0 : 40, left: 20),
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
                      children: const [
                        Icon(
                          Icons.home,
                          color: Colors.blue,
                        ),
                        Text("/ Pemasangan Baru")
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
                            textMng("Kecepatan Internet ", insideBubble),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: textField(1, _spdCon,
                                        maxs: 5, mode: TextInputType.number),
                                  ),
                                  textMng("Mbps", insideBubble)
                                ],
                              ),
                            ),
                            textMng("Nama Instansi ", insideBubble),
                            textField(1, _instanCon),
                            textMng("Kontak Instansi ", insideBubble),
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
                            textMng("Nama Pemohon ", insideBubble),
                            textField(1, _namaCon),
                            textMng("Kontak Pemohon ", insideBubble),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: _sama,
                                      onChanged: (val) async {
                                        _kontakOrgCon.text = "";
                                        _sama = !_sama;
                                        setState(() {});
                                      }),
                                  const Text("Sama"),
                                  if (!_sama)
                                    Checkbox(
                                        value: _noTelp2,
                                        onChanged: (val) async {
                                          _kontakOrgCon.text = "";
                                          _noTelp2 = !_noTelp2;
                                          _eml2 = !_eml2;
                                          if (_distractions.hasFocus) {
                                            _distractions.unfocus();
                                            await Future.delayed(const Duration(
                                                milliseconds: 400));
                                            _distractions.requestFocus();
                                          }
                                          setState(() {});
                                        }),
                                  if (!_sama) const Text("No Telp"),
                                  if (!_sama)
                                    const SizedBox(
                                      width: 30,
                                    ),
                                  if (!_sama)
                                    Checkbox(
                                        value: _eml2,
                                        onChanged: (val) async {
                                          _kontakOrgCon.text = "";
                                          _noTelp2 = !_noTelp2;
                                          _eml2 = !_eml2;
                                          if (_distractions.hasFocus) {
                                            _distractions.unfocus();
                                            await Future.delayed(const Duration(
                                                milliseconds: 400));
                                            _distractions.requestFocus();
                                          }
                                          setState(() {});
                                        }),
                                  if (!_sama) const Text("Email"),
                                ],
                              ),
                            ),
                            if (!_sama)
                              textField(1, _kontakOrgCon,
                                  focus: _distractions,
                                  mode: _noTelp
                                      ? TextInputType.phone
                                      : TextInputType.emailAddress),
                            textMng("Alamat Instansi ", insideBubble),
                            textField(3, _alamatCon, maxs: 400),
                            if (widget.admin)
                              PetugasList(
                                ipIs: widget.ipIs,
                                petugas1: (val) {
                                  debugPrint(val);
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
                      child: const Text(
                        "Form Pemasangan Baru",
                        style: TextStyle(fontSize: 25, color: Colors.white),
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
    if (_namaCon.text != "" &&
        _kontakCon.text != "" &&
        (_sama || _kontakOrgCon.text != "") &&
        _instanCon.text != "" &&
        _spdCon.text != "" &&
        _alamatCon.text != "") {
      if (_sama) {
        _kontakOrgCon.text = _kontakCon.text;
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
      kodePel += "Pem";

      try {
        Uri doInstansi =
            Uri.parse("http://${widget.ipIs}/jaringan/conn/doInstansi.php");
        final replies = await http.post(doInstansi, body: {
          'action': 'insData',
          'key': 'ParagimParadoxus',
          'nama': _instanCon.text,
          'kontak': _kontakCon.text,
          'tempat': _alamatCon.text,
          'tgl': DateTime.now().toString(),
        });

        if (replies.body != "Sucess") {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (builder) => AlertDialog(
                    content: Text("Respone Body: ${replies.body}"),
                    title: const Text("Kesalahan Dalam Menambah Instansi"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"))
                    ],
                  ));
          loading(context);
        }

        Uri docari =
            Uri.parse("http://${widget.ipIs}/jaringan/conn/doLayanan.php");
        final respone = await http.post(docari, body: {
          'action': 'addLajuan',
          'key': 'CacingBernyanyi',
          'kodePel': kodePel,
          'jenis': 'baru',
          'instansi': _instanCon.text,
          'nama': _namaCon.text,
          'kontak': _kontakOrgCon.text,
          'desc': 'Pemasangan Baru ${_spdCon.text}Mbps',
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
            if (widget.admin && _ePetugas != "") {
              _tombolKirim(kodePel);
            }
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (builder) => AlertDialog(
                      content:
                          const Text("Pemasangan Baru Berhasil Ditambahkan"),
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
      Navigator.of(context).pop();
      String error = "";
      if (_spdCon.text == "") {
        error += "Kecepatan Masih Kosong \n";
      }
      if (_instanCon.text == "") {
        error += "Instansi Masih Kosong \n";
      }
      if (_kontakCon.text == "") {
        error += "Kontak Instansi Masih Kosong \n";
      }
      if (_namaCon.text == "") {
        error += "Nama Masih Kosong \n";
      }
      if (!_sama && _kontakOrgCon.text == "") {
        error += "Kontak Pemohon Masih Kosong \n";
      }
      if (_alamatCon.text == "") {
        error += "Alamat Masih Kosong \n";
      }
      showDialog(
          context: context,
          builder: (builder) => AlertDialog(
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"))
                ],
                content: Text(error),
                title: const Text("Input Salah!"),
              ));
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
