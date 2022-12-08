import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:network_kominfo/dpdf/pdf_api.dart';
import 'package:network_kominfo/model/dataset.dart';
import 'package:network_kominfo/model/users.dart';
import 'package:network_kominfo/dpdf/pdf_invoice.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/spcbutton.dart';
import 'insideganedit.dart';

class ProgGanList extends StatefulWidget {
  final List<dynamic>? list;
  final String ipIs;
  final Color color1;
  final List<bool> able;
  final Users user;
  final Setstasis refresh;
  final ScrollController controller;
  const ProgGanList(this.color1, this.able,
      {Key? key,
      required this.list,
      required this.ipIs,
      required this.refresh,
      required this.controller,
      required this.user})
      : super(key: key);

  @override
  State<ProgGanList> createState() => _ProgGanListState();
}

class _ProgGanListState extends State<ProgGanList> {
  File? image, image2, image3, image4, image5, image6;
  final List<bool> _fronts = [true, true, true, true, true, true];
  final List<bool> _traps = [true, true, true, true, true, true];

  final List<ScrollController> _roll = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController()
  ];
  final List<List<bool>> _kelars = [[], [], [], [], [], []];
  final List<List<TextEditingController>> _salahs = [[], [], [], [], [], []];
  final List<List<TextEditingController>> _solusis = [[], [], [], [], [], []];
  final List<int> _loops = [0, 0, 0, 0, 0, 0];

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
    //final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: widget.list == null ? 0 : widget.list!.length,
        itemBuilder: (context, i) {
          List<dynamic>? _problem;
          String devil = widget.list![i]['instansi'];
          double pas = pasWidth(devil);
          if (pas == 0) {
            pas = 100;
          }
          return GestureDetector(
            onTap: () {
              if (widget.able[0]) {
                if (!_fronts[i] && !_traps[i]) {
                  _fronts[i] = !_fronts[i];
                  _traps[i] = !_traps[i];
                } else {
                  if (!_fronts[i]) {
                    _traps[i] = !_traps[i];
                  }
                  if (_fronts[i]) {
                    if (_traps[i]) {
                      _fronts[i] = !_fronts[i];
                    }
                  }
                }
                if (_loops[i] < 0) {
                  _loops[i] = 0;
                }
                setState(() {});
                widget.refresh();
              }
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    height: 430,
                    width: lebar - 55,
                    child: AnimatedSwitcher(
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        final rotate =
                            Tween(begin: pi, end: 0.0).animate(animation);
                        return AniRotBu(i,
                            child: child, rotate: rotate, fronts: _fronts);
                      },
                      duration: const Duration(milliseconds: 500),
                      child: _fronts[i]
                          ? Card(
                              key: const ValueKey<String>("key1"),
                              color: widget.color1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: ListTile(
                                        trailing: SizedBox(
                                          width: (widget.list![i]['instansi']
                                                      .toString()
                                                      .length <
                                                  6)
                                              ? pas
                                              : 130,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text(
                                                    widget.list![i]['instansi'],
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
                                          Expanded(
                                              child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(widget.list![i]
                                                      ['deskripsi']))),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
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
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Proses"),
                                          const Spacer(),
                                          Text(
                                              "${widget.list![i]['presentase']}%"),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Petugas"),
                                          const Spacer(),
                                          Text((widget.list![i]['petugas2'] ==
                                                  null)
                                              ? widget.list![i]['petugas']
                                              : "${widget.list![i]['petugas']}, ${widget.list![i]['petugas2']}"),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Kendala"),
                                          const Spacer(),
                                          Text((widget.list![i]['kendala'] ==
                                                  null)
                                              ? "Tidak ada Kendala"
                                              : widget.list![i]['kendala']),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                    width: 120,
                                                    child: spcButton(
                                                      doThisQuick: () async {
                                                        DatasetPrint printI = DatasetPrint(
                                                            permasalahan: (widget.list![i]["aktifitas"] != null)
                                                                ? widget.list![i][
                                                                    "aktifitas"]
                                                                : "",
                                                            tglsls: (widget.list![i]['selesai'] != null)
                                                                ? widget.list![i]
                                                                    ['selesai']
                                                                : "",
                                                            petugas1: widget.list![i]
                                                                ['name'],
                                                            petugas2:
                                                                widget.list![i]['nama_petugas_2'] ??
                                                                    "",
                                                            namaPelapor: widget.list![i]
                                                                    ['nama'] ??
                                                                "",
                                                            instansi: widget.list![i]
                                                                ['instansi'],
                                                            deskripsi: widget.list![i]
                                                                ['deskripsi'],
                                                            tindakLanjut: widget.list![i]['tindakLanjut'],
                                                            tanggal: widget.list![i]['tanggal'],
                                                            kodePrint: widget.list![i]['1']);
                                                        final pdFile =
                                                            await PdfInvoiceApi
                                                                .generateTicket(
                                                                    printI);
                                                        PdfApi.openFile(pdFile);
                                                      },
                                                      child: Row(
                                                        children: const [
                                                          Text("Print"),
                                                          Spacer(),
                                                          Icon(
                                                              FontAwesomeIcons
                                                                  .print,
                                                              size: 15),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ]),
                                      ],
                                    ),
                                    const Divider(),
                                    if (widget.able[0])
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [Text("Tap For More")],
                                      )
                                  ],
                                ),
                              ),
                            )
                          : (_traps[i])
                              ? Card(
                                  key: const ValueKey<String>("key2"),
                                  color: widget.color1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Column(children: [
                                      const ListTile(
                                        title: Text("Actions"),
                                        trailing: Icon(
                                          FontAwesomeIcons.cogs,
                                          size: 40,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text("Nama Pelapor"),
                                            const Spacer(),
                                            SizedBox(
                                              width: 100,
                                              child: SingleChildScrollView(
                                                reverse: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text((widget.list![i]
                                                                ['nama'] !=
                                                            null)
                                                        ? widget.list![i]
                                                            ['nama']
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
                                              width: 100,
                                              child: SingleChildScrollView(
                                                reverse: true,
                                                scrollDirection:
                                                    Axis.horizontal,
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
                                      const Divider(),
                                      GestureDetector(
                                        onTap: () {},
                                        child: SizedBox(
                                          height: 170,
                                          width: 600,
                                          child: FutureBuilder<List<dynamic>>(
                                              future: _getProblem(
                                                  widget.list![i]['1'], i),
                                              builder: (context, snapshot) {
                                                _problem = snapshot.data;
                                                return Column(
                                                  children: [
                                                    Expanded(
                                                      child: ListView.builder(
                                                        controller: _roll[i],
                                                        itemCount: _problem ==
                                                                null
                                                            ? _loops[i]
                                                            : _problem!.length +
                                                                _loops[i],
                                                        itemBuilder:
                                                            (context, j) {
                                                          if (_problem !=
                                                              null) {
                                                            if (_kelars[i]
                                                                    .length <
                                                                _loops[i] +
                                                                    _problem!
                                                                        .length) {
                                                              if (_kelars[i]
                                                                      .length <
                                                                  _problem!
                                                                      .length) {
                                                                if (_problem![j]
                                                                        [
                                                                        'status'] ==
                                                                    "true") {
                                                                  _kelars[i]
                                                                      .add(
                                                                          true);
                                                                } else {
                                                                  _kelars[i].add(
                                                                      false);
                                                                }
                                                                _salahs[i].add(
                                                                    TextEditingController(
                                                                        text: _problem![j]
                                                                            [
                                                                            'Permasalahan']));
                                                                _solusis[i].add(
                                                                    TextEditingController(
                                                                        text: _problem![j]
                                                                            [
                                                                            'Penanganan']));
                                                              } else {
                                                                _kelars[i]
                                                                    .add(false);
                                                                _salahs[i].add(
                                                                    TextEditingController());
                                                                _solusis[i].add(
                                                                    TextEditingController());
                                                              }
                                                            }
                                                          } else {
                                                            if (_kelars[i]
                                                                    .length <
                                                                _loops[i] + 1) {
                                                              _kelars[i]
                                                                  .add(false);
                                                              _salahs[i].add(
                                                                  TextEditingController());
                                                              _solusis[i].add(
                                                                  TextEditingController());
                                                            }
                                                          }
                                                          return Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            decoration: BoxDecoration(
                                                                border: Border
                                                                    .all(),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top: 6,
                                                                      bottom:
                                                                          6),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50)),
                                                                  child: Text(
                                                                      (j + 1)
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          40,
                                                                      width:
                                                                          150,
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      child:
                                                                          TextField(
                                                                        maxLines:
                                                                            1,
                                                                        controller:
                                                                            _salahs[i][j],
                                                                        decoration:
                                                                            const InputDecoration(hintText: "Permasalahan"),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          40,
                                                                      width:
                                                                          150,
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      child:
                                                                          TextField(
                                                                        maxLines:
                                                                            1,
                                                                        controller:
                                                                            _solusis[i][j],
                                                                        decoration:
                                                                            const InputDecoration(hintText: "Penanganan"),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const Spacer(),
                                                                Checkbox(
                                                                    value:
                                                                        _kelars[i]
                                                                            [j],
                                                                    onChanged:
                                                                        (val) {
                                                                      _kelars[i]
                                                                              [
                                                                              j] =
                                                                          !_kelars[i]
                                                                              [
                                                                              j];
                                                                      setState(
                                                                          () {});
                                                                    })
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              if (_loops[i] >
                                                                  0) {
                                                                _loops[i]--;
                                                                _kelars[i]
                                                                    .removeLast();
                                                                _salahs[i]
                                                                    .removeLast();
                                                                _solusis[i]
                                                                    .removeLast();
                                                              } else if (_problem !=
                                                                  null) {
                                                                if (_problem!
                                                                            .length +
                                                                        _loops[
                                                                            i] >
                                                                    1) {
                                                                  _loops[i]--;
                                                                }
                                                              }
                                                              _roll[i].animateTo(
                                                                  _roll[i]
                                                                          .position
                                                                          .maxScrollExtent -
                                                                      110,
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                  curve: Curves
                                                                      .easeOut);

                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.black,
                                                              child: const Icon(
                                                                  Icons.remove,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 30),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            _loops[i]++;
                                                            setState(() {});
                                                            _roll[i].animateTo(
                                                                _roll[i]
                                                                        .position
                                                                        .maxScrollExtent +
                                                                    110,
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                curve: Curves
                                                                    .easeOut);
                                                          },
                                                          child: Container(
                                                            color: Colors.black,
                                                            child: const Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                                size: 30),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                );
                                              }),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 100,
                                        width: 600,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: spcButton(
                                                        doThisQuick: () {},
                                                        child: Row(
                                                          children: const [
                                                            Text("Kendala"),
                                                            Spacer(),
                                                            Icon(
                                                                FontAwesomeIcons
                                                                    .bandAid,
                                                                size: 15),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                                tombolEdit(i),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: spcButton(
                                                        doThisQuick: () {
                                                          int total = _loops[i];
                                                          if (_problem !=
                                                              null) {
                                                            total += _problem!
                                                                .length;
                                                          }
                                                          String send = "[";
                                                          for (int j = 0;
                                                              j < total;
                                                              j++) {
                                                            send +=
                                                                '{"Permasalahan" : "${_salahs[i][j].text}", "Penanganan" : "${_solusis[i][j].text}", "status" : "${_kelars[i][j]}"}';
                                                            if (j + 1 !=
                                                                total) {
                                                              send += ",";
                                                            }
                                                          }
                                                          send += "]";
                                                          _proses(
                                                              widget.list![i]
                                                                  ['KodePel'],
                                                              send,
                                                              i);
                                                        },
                                                        child: Row(
                                                          children: const [
                                                            Text("Prosess"),
                                                            Spacer(),
                                                            Icon(
                                                                FontAwesomeIcons
                                                                    .briefcase,
                                                                size: 15),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                                tombohHapus(i),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                                  ))
                              : Card(
                                  key: const ValueKey<String>("key3"),
                                  color: widget.color1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const ListTile(
                                          trailing: Text("Photo",
                                              style: TextStyle(fontSize: 30)),
                                          leading: Icon(FontAwesomeIcons.image,
                                              size: 35),
                                        ),
                                        SizedBox(
                                            height: 200,
                                            width: 600,
                                            child: Center(
                                              child: (widget.list![i]
                                                              ['image'] !=
                                                          null &&
                                                      !checkDanger(i))
                                                  ? Image.network(
                                                      "http://${widget.ipIs}/jaringan/conn/uploads/${widget.list![i]['image']}")
                                                  : checkDanger(i)
                                                      ? _img(i)
                                                      : const Icon(
                                                          Icons.camera,
                                                          size: 160,
                                                        ),
                                            )),
                                        SizedBox(
                                            height: 150,
                                            width: 600,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 10,
                                                          ),
                                                          child: spcButton(
                                                            doThisQuick: () =>
                                                                pickImage(
                                                                    ImageSource
                                                                        .gallery,
                                                                    i),
                                                            child: Row(
                                                              children: const [
                                                                Text("Gallery"),
                                                                Spacer(),
                                                                Icon(
                                                                    FontAwesomeIcons
                                                                        .photoVideo,
                                                                    size: 15),
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 10),
                                                          child: spcButton(
                                                            doThisQuick: () =>
                                                                pickImage(
                                                                    ImageSource
                                                                        .camera,
                                                                    i),
                                                            child: Row(
                                                              children: const [
                                                                Text("Camera"),
                                                                Spacer(),
                                                                Icon(
                                                                    FontAwesomeIcons
                                                                        .cameraRetro,
                                                                    size: 15),
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: spcButton(
                                                    child: Row(
                                                      children: const [
                                                        Text("Simpan"),
                                                        Spacer(),
                                                        Icon(
                                                            FontAwesomeIcons
                                                                .solidSave,
                                                            size: 15),
                                                      ],
                                                    ),
                                                    doThisQuick: () async {
                                                      _uploadImage(
                                                          _myImg(i),
                                                          widget.list![i]
                                                              ['KodePel'],
                                                          context);
                                                    },
                                                  ),
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _proses(String iD, String galau, int i) async {
    try {
      List<dynamic>? kdpaham;
      int persen = 0;
      if (galau != "") {
        kdpaham = jsonDecode(galau);
        int dalam = 100 ~/ kdpaham!.length;
        int counter = 0;
        for (int u = 0; u < kdpaham.length; u++) {
          if (kdpaham[u]['status'] == 'true') {
            persen += dalam;
            counter++;
          }
        }
        if (counter == kdpaham.length) {
          persen = 100;
        }
      }

      Uri dophp =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doProsess.php");
      final respone = await http.post(dophp, body: {
        'action': 'makeMasalah',
        'key': 'RumputJatuh',
        'user': widget.user.email,
        'problem': galau,
        'persen': persen.toString(),
        'ids': iD,
        'tgl': DateTime.now().toString()
      });
      _loops[i] = 0;
      if (respone.body == "SucessSucess") {
        if (persen == 100) {
          await http.post(dophp, body: {
            'action': 'QuickComplete',
            'key': 'RumputJatuh',
            'id': iD,
            'tgl': DateTime.now().toString()
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Progress Berhasil Disimpan")));
        widget.refresh();
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

  Widget tombohHapus(int i) => Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: spcButton(
                child: Row(
                  children: const [
                    Text("Delete"),
                    Spacer(),
                    Icon(FontAwesomeIcons.trash, size: 15),
                  ],
                ),
                doThisQuick: () async {
                  await delData(widget.list![i]['KodePel']);
                  widget.refresh();
                })),
      );

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
      for (int i = 0; i < _fronts.length; i++) {
        _fronts[i] = true;
        _traps[i] = true;
      }
      try {
        Uri dophp =
            Uri.parse("http://${widget.ipIs}/jaringan/conn/doLayanan.php");
        final respone = await http.post(dophp, body: {
          'action': 'delData',
          'jenis': 'layanan',
          'key': 'CacingBernyanyi',
          'user': widget.user.email,
          'id': iD,
          'tgl': DateTime.now().toString()
        });
        if (respone.body == "SucessSucess") {
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

  Future<List> _getProblem(String kelas, int i) async {
    try {
      Uri dophp =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doProsess.php");
      final respone = await http.post(dophp, body: {
        'action': 'getMasalah',
        'kelas': kelas,
        'key': 'RumputJatuh',
      });
      return jsonDecode(respone.body);
    } catch (e) {
      if (_loops[i] == 0) {
        _loops[i]++;
      }
      return <String>[];
    }
  }

  Future pickImage(ImageSource lead, int i) async {
    try {
      final imageP = await ImagePicker().getImage(source: lead);
      if (imageP == null) return;

      final imageTempo = File(imageP.path);
      setState(() {
        if (i == 0) image = imageTempo;
        if (i == 1) image2 = imageTempo;
        if (i == 2) image3 = imageTempo;
        if (i == 3) image4 = imageTempo;
        if (i == 4) image5 = imageTempo;
        if (i == 5) image6 = imageTempo;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to Pick Image : $e');
    }
  }

  Future _uploadImage(File foto, String target, BuildContext context) async {
    try {
      Uri dophp =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doProsess.php");
      final request = http.MultipartRequest('POST', dophp);
      request.fields['action'] = "Upload";
      request.fields['key'] = "RumputJatuh";
      request.fields['target'] = target;
      var pic = await http.MultipartFile.fromPath("image", foto.path);
      request.files.add(pic);
      final response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Foto Berhasil Di Upload")));
      } else {
        debugPrint("Fail to Upload");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool checkDanger(int i) {
    switch (i) {
      case 0:
        if (image == null) {
          return false;
        } else {
          return true;
        }
      case 1:
        if (image2 == null) {
          return false;
        } else {
          return true;
        }
      case 2:
        if (image3 == null) {
          return false;
        } else {
          return true;
        }
      case 3:
        if (image4 == null) {
          return false;
        } else {
          return true;
        }
      case 4:
        if (image5 == null) {
          return false;
        } else {
          return true;
        }
      default:
        if (image6 == null) {
          return false;
        } else {
          return true;
        }
    }
  }

  Widget _img(int i) {
    late File myImg;
    switch (i) {
      case 0:
        myImg = image!;
        break;
      case 1:
        myImg = image2!;
        break;
      case 2:
        myImg = image3!;
        break;
      case 3:
        myImg = image4!;
        break;
      case 4:
        myImg = image5!;
        break;
      default:
        myImg = image6!;
    }
    return Image.file(
      myImg,
    );
  }

  File _myImg(int i) {
    late File myImg;
    switch (i) {
      case 0:
        myImg = image!;
        break;
      case 1:
        myImg = image2!;
        break;
      case 2:
        myImg = image3!;
        break;
      case 3:
        myImg = image4!;
        break;
      case 4:
        myImg = image5!;
        break;
      default:
        myImg = image6!;
    }
    return myImg;
  }

  Widget tombolEdit(int i) => Expanded(
        child: Container(
            margin: EdgeInsets.only(left: 10, right: (widget.able[1]) ? 0 : 10),
            child: spcButton(
              doThisQuick: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InsideGanEdit(
                            widget.list![i]['KodePel'],
                            "layanan",
                            user: widget.user,
                            ipIs: widget.ipIs,
                            instansi: widget.list![i]['instansi'],
                            kontak: widget.list![i]['kontak_instansi'],
                            nama: widget.list![i]['nama'],
                            lapor: widget.list![i]['deskripsi'],
                            date: widget.list![i]['tanggal'],
                            lanjut: widget.list![i]['tindakLanjut'],
                            ePet: widget.list![i]['petugas'],
                            ePet2: (widget.list![i]['petugas_2'] != null)
                                ? widget.list![i]['petugas_2']
                                : "",
                          ),
                        ));
              },
              child: Row(
                children: const [
                  Text("Edit"),
                  Spacer(),
                  Icon(FontAwesomeIcons.pencilAlt, size: 15),
                ],
              ),
            )),
      );
}
