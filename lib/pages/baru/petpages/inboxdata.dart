import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:network_kominfo/mysql/historydata.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/spcbutton.dart';

class InboxPetugas extends StatefulWidget {
  final List<dynamic>? list;
  final String ipIs;
  final String email;
  final Color color1;
  final Setstasis refresh;
  final ScrollController controller;
  const InboxPetugas(
    this.color1, {
    Key? key,
    required this.list,
    required this.ipIs,
    required this.refresh,
    required this.controller,
    required this.email,
  }) : super(key: key);
  @override
  _InboxPetugasState createState() => _InboxPetugasState();
}

class _InboxPetugasState extends State<InboxPetugas> {
  bool _telCbx = false, _remCbx = false, _onsCbx = false;
  String tindakLanjut = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<bool> _unread = [
    true,
    true,
    true,
    true,
    true,
    true,
  ];

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;
    TextStyle insideBubble = const TextStyle(fontSize: 16, color: Colors.black);
    return ListView.builder(
        scrollDirection: (tinggi < lebar) ? Axis.horizontal : Axis.vertical,
        itemCount: widget.list == null ? 0 : widget.list!.length,
        itemBuilder: (context, i) {
          if (widget.list![i]['dbcptg'] != null) {
            _unread[i] = false;
          }
          String devil = widget.list![i]['instansi'];
          double pas = pasWidth(devil);
          if (pas == 0) {
            pas = 100;
          }
          return GestureDetector(
            onTap: () {
              if (_unread[i]) {
                _unread[i] = !_unread[i];
                const HisAction()
                    .bacaPet(widget.ipIs, widget.list![i]['KodePel'], context);
                setState(() {});
              }
            },
            child: AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) {
                final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                return AniRotBu(i,
                    child: child, rotate: rotate, fronts: _unread);
              },
              duration: const Duration(milliseconds: 500),
              child: _unread[i]
                  ? SizedBox(
                      key: const ValueKey<String>("key2"),
                      height: 430,
                      width: 500,
                      child: Card(
                        color: widget.color1,
                        child: Transform.rotate(
                          angle: 110,
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(border: Border.all()),
                            child: Stack(
                              children: [
                                Transform.rotate(
                                  angle: -110,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text("Inbox"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text("Pesan Yang Belum Dibaca"),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 150,
                                              width: 150,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.contain,
                                                      image: AssetImage(
                                                          'assets/img/ribbon.png'))),
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        const Text("Tap Untuk Membaca Pesan"),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      key: const ValueKey<String>("key1"),
                      height: 430,
                      width: 500,
                      child: Card(
                        color: widget.color1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: ListTile(
                                      trailing: SizedBox(
                                        width: (widget.list![i]['instansi']
                                                    .toString()
                                                    .length <
                                                8)
                                            ? pas
                                            : 130,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Text(widget.list![i]['instansi'],
                                                  style: const TextStyle(
                                                      fontSize: 30)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      leading: const Icon(
                                          FontAwesomeIcons.building,
                                          size: 35),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Pengajuan"),
                                        const Spacer(),
                                        SizedBox(
                                          width: 150,
                                          child: SingleChildScrollView(
                                            reverse: true,
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  widget.list![i]['deskripsi'],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Nama Pelapor"),
                                        const Spacer(),
                                        SizedBox(
                                          width: 150,
                                          child: SingleChildScrollView(
                                            reverse: true,
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text((widget.list![i]['nama'] !=
                                                        null)
                                                    ? widget.list![i]['nama']
                                                    : "Kosong")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Kontak Pelapor"),
                                        const Spacer(),
                                        SizedBox(
                                          width: 150,
                                          child: SingleChildScrollView(
                                            reverse: true,
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text((widget.list![i][
                                                            'kontak_instansi'] !=
                                                        null)
                                                    ? widget.list![i]
                                                        ['kontak_instansi']
                                                    : "Kosong"),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Tanggal"),
                                        const Spacer(),
                                        Text(widget.list![i]['tanggal'])
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  textMng("Tindak Lanjut : ", insideBubble),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
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
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
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
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
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
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ),
                              SizedBox(
                                height: 430,
                                width: 500,
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                            width: 120,
                                            child: spcButton(
                                              doThisQuick: () {
                                                if (_onsCbx ||
                                                    _remCbx ||
                                                    _telCbx) {
                                                  loading(context);
                                                  tombolProsess(i);
                                                }
                                              },
                                              child: Row(
                                                children: const [
                                                  Text("Prosses"),
                                                  Spacer(),
                                                  Icon(FontAwesomeIcons.wrench,
                                                      size: 15),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ]),
                              )
                            ],
                          ),
                        ),
                      )),
            ),
          );
        });
  }

  Future<void> tombolProsess(int i) async {
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
    tindakLanjut = lanjut;
    try {
      Uri dophp =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doProsess.php");
      final respone = await http.post(dophp, body: {
        'action': 'upPetugas',
        'key': 'RumputJatuh',
        'user': widget.email,
        'tndk': tindakLanjut,
        'kodePel': widget.list![i]['IdPelaporan'],
        'tgl': DateTime.now().toString()
      });
      if (respone.body == "SucessSucess") {
        const HisAction()
            .bacaTndk(widget.ipIs, widget.list![i]['IdPelaporan'], context);
        Navigator.of(context).pop();
        tindakLanjut = "";
        _unread = [true, true, true, true, true, true];
        widget.refresh();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Data Telah Dikirim")));
      } else {
        Navigator.of(context).pop();
        tindakLanjut = "";
        showDialog(
            context: context,
            builder: (builder) => AlertDialog(
                  content: Text(respone.body),
                  title: const Text("Gagal"),
                ));
      }
    } catch (e) {
      Navigator.of(context).pop();
      tindakLanjut = "";
      showDialog(
          context: context,
          builder: (builder) => AlertDialog(
                content: Text(e.toString()),
                title: const Text("Error"),
              ));
    }
  }
}
