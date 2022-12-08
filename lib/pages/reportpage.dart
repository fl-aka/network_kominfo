import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:network_kominfo/dpdf/pdf_api.dart';
import 'package:network_kominfo/dpdf/pdf_invoice.dart';
import 'package:network_kominfo/mysql/laporan.dart';
import 'package:network_kominfo/widgetsutils/scroll_parent.dart';
import 'package:network_kominfo/widgetsutils/spcbutton.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';

typedef Popper = void Function(bool i);

class ReportPage extends StatefulWidget {
  final bool exp;
  final bool pop;
  final String iP;
  final Popper report;
  const ReportPage(
      {Key? key,
      required this.exp,
      required this.iP,
      required this.pop,
      required this.report})
      : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _rollCon = ScrollController();
  int _pop = 0;
  bool _ren = false;
  List<dynamic> _data = [];

  @override
  Widget build(BuildContext context) {
    if (!widget.pop) {
      _ren = false;
    }
    final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;

    return SizedBox(
      height: tinggi,
      width: lebar,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 90.0),
            child: ListView(
              controller: _rollCon,
              children: [
                Stack(
                  children: [
                    Container(
                      height: (tinggi >= 180) ? tinggi - 180 : tinggi,
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
                      child: ScrollParent(
                          controller: _rollCon,
                          child: ListView(children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                "Dashboard",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            _rowBox(pilihIcon("Pemasangan Baru", black: true),
                                "Report Pemasangan Baru", func: () {
                              _popAndSwitch(4);
                            }),
                            _rowBox(pilihIcon("Pengajuan Layanan", black: true),
                                "Report Layanan Selesai", func: () {
                              _popAndSwitch(1);
                            }),
                            _rowBox(
                                pilihIcon("Pelaporan Gangguan", black: true),
                                "Report Gangguan Selesai", func: () {
                              _popAndSwitch(2);
                            }),
                            _rowBox(const Icon(FontAwesomeIcons.chessKnight),
                                "Report Petugas", func: () {
                              _popAndSwitch(3);
                            }),
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                "Inbox",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            _rowBox(const Icon(Icons.inbox), "Inbox Admin",
                                func: () {
                              _popAndSwitch(5);
                            }),
                            _rowBox(const Icon(FontAwesomeIcons.mailBulk),
                                "Inbox Petugas", func: () {
                              _popAndSwitch(6);
                            }),
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                "Kalender",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            _rowBox(pilihIcon("Kalender", black: true),
                                "Data Bulanan", func: () {
                              _popAndSwitch(7);
                            }),
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                "Progress",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            _rowBox(
                                pilihIcon("Progress Pemasangan Baru",
                                    black: true),
                                "Progress Pemasangan Baru", func: () async {
                              _popAndSwitch(10);
                            }),
                            _rowBox(pilihIcon("Progress Layanan", black: true),
                                "Progress Layanan", func: () async {
                              _popAndSwitch(8);
                            }),
                            _rowBox(pilihIcon("Progress Gangguan", black: true),
                                "Progress Gangguan", func: () async {
                              _popAndSwitch(9);
                            }),
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                "Opsi",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            _rowBox(
                                pilihIcon("Atur Opsi Pelaporan", black: true),
                                "Opsi-opsi Layanan", func: () {
                              _popAndSwitch(11);
                            }),
                            _rowBox(
                                pilihIcon("Atur Opsi Pelaporan", black: true),
                                "Opsi-opsi Gangguan", func: () {
                              _popAndSwitch(12);
                            }),
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                "Instansi",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            _rowBox(pilihIcon("Data Instansi", black: true),
                                "Report Data Instansi", func: () {
                              _popAndSwitch(13);
                            }),
                          ])),
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
                        child: const Text(
                          "All Report",
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              left: 0,
              bottom: 0,
              child: AnimatedContainer(
                onEnd: () {
                  _ren = false;
                  if (widget.pop) {
                    _ren = true;
                  }
                  setState(() {});
                },
                duration: const Duration(milliseconds: 430),
                width: lebar,
                height: widget.pop ? 315 : 0,
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black26, offset: Offset(5, -4)),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: _ren
                    ? (_pop == 1 || _pop == 2)
                        ? FutureBuilder<List<dynamic>>(
                            future: _pop == 1
                                ? const ReportAction()
                                    .getLayananComData(widget.iP)
                                : const ReportAction()
                                    .geGangguanComData(widget.iP),
                            builder: (con, ss) {
                              if (ss.connectionState == ConnectionState.done) {
                                _data = ss.data!;
                              }
                              if (_data.isNotEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    rowFz(
                                        (_pop == 1)
                                            ? pilihIcon("Pengajuan Layanan",
                                                black: true)
                                            : pilihIcon("Pelaporan Gangguan",
                                                black: true),
                                        (_pop == 1)
                                            ? "Report Layanan Selesai"
                                            : "Report Gangguan Selesai"),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: spcButton(
                                          child: Row(
                                            children: const [
                                              Text("Print"),
                                              Spacer(),
                                              Icon(FontAwesomeIcons.print,
                                                  size: 15),
                                            ],
                                          ),
                                          doThisQuick: () async {
                                            final pdFile = await PdfInvoiceApi
                                                .generateLaporanSelesai(
                                                    _data, widget.iP);
                                            PdfApi.openFile(pdFile);
                                          }),
                                    ),
                                  ],
                                );
                              }
                              if (ss.connectionState == ConnectionState.done &&
                                  _data.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    rowFz(
                                        (_pop == 1)
                                            ? pilihIcon("Pengajuan Layanan",
                                                black: true)
                                            : pilihIcon("Pelaporan Gangguan",
                                                black: true),
                                        (_pop == 1)
                                            ? "Report Layanan Selesai"
                                            : "Report Gangguan Selesai"),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 30),
                                      child: Text("Tidak Ada Data"),
                                    )
                                  ],
                                );
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  CircularProgressIndicator(),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text("Memuat Data"),
                                  )
                                ],
                              );
                            },
                          )
                        : (_pop == 3 || _pop == 6)
                            ? FutureBuilder<List<dynamic>>(
                                future: _pop == 3
                                    ? const ReportAction()
                                        .getLPetugasData(widget.iP)
                                    : const ReportAction()
                                        .getAllInboxPet(widget.iP),
                                builder: (con, ss) {
                                  if (ss.connectionState ==
                                      ConnectionState.done) {
                                    _data = ss.data!;
                                  }
                                  if (_data.isNotEmpty) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        rowFz(
                                            (_pop == 3)
                                                ? const Icon(FontAwesomeIcons
                                                    .chessKnight)
                                                : const Icon(
                                                    FontAwesomeIcons.mailBulk),
                                            (_pop == 3)
                                                ? "Report Petugas"
                                                : "Inbox Semua Petugas"),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: spcButton(
                                              child: Row(
                                                children: const [
                                                  Text("Print"),
                                                  Spacer(),
                                                  Icon(FontAwesomeIcons.print,
                                                      size: 15),
                                                ],
                                              ),
                                              doThisQuick: () async {
                                                late final File pdFile;
                                                if (_pop == 3) {
                                                  pdFile = await PdfInvoiceApi
                                                      .generateLaporanSelesai(
                                                          _data, widget.iP,
                                                          pEtugas: true);
                                                } else {
                                                  pdFile = await PdfInvoiceApi
                                                      .generateInboxAllPet(
                                                    _data,
                                                  );
                                                }
                                                PdfApi.openFile(pdFile);
                                              }),
                                        ),
                                      ],
                                    );
                                  }
                                  if (ss.connectionState ==
                                          ConnectionState.done &&
                                      _data.isEmpty) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        rowFz(
                                            (_pop == 3)
                                                ? const Icon(FontAwesomeIcons
                                                    .chessKnight)
                                                : const Icon(
                                                    FontAwesomeIcons.mailBulk),
                                            (_pop == 3)
                                                ? "Report Petugas"
                                                : "Inbox Semua Petugas"),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: Text("Tidak Ada Data"),
                                        )
                                      ],
                                    );
                                  }
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      CircularProgressIndicator(),
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text("Memuat Data"),
                                      )
                                    ],
                                  );
                                },
                              )
                            : _pop == 4
                                ? FutureBuilder<List<dynamic>>(
                                    future: const ReportAction()
                                        .geBaruComData(widget.iP),
                                    builder: (con, ss) {
                                      if (ss.connectionState ==
                                          ConnectionState.done) {
                                        _data = ss.data!;
                                      }
                                      if (_data.isNotEmpty) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            rowFz(
                                                pilihIcon("Pemasangan Baru",
                                                    black: true),
                                                "Report Pemasangan Baru Selesai"),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: spcButton(
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
                                                  doThisQuick: () async {
                                                    final pdFile =
                                                        await PdfInvoiceApi
                                                            .generateNeoLaporanSelesai(
                                                                _data,
                                                                widget.iP);
                                                    PdfApi.openFile(pdFile);
                                                  }),
                                            ),
                                          ],
                                        );
                                      }
                                      if (ss.connectionState ==
                                              ConnectionState.done &&
                                          _data.isEmpty) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            rowFz(
                                                pilihIcon("Pemasangan Baru",
                                                    black: true),
                                                "Report Pemasangan Baru Selesai"),
                                            const Padding(
                                              padding: EdgeInsets.only(top: 30),
                                              child: Text("Tidak Ada Data"),
                                            )
                                          ],
                                        );
                                      }
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          CircularProgressIndicator(),
                                          Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text("Memuat Data"),
                                          )
                                        ],
                                      );
                                    },
                                  )
                                : (_pop == 5)
                                    ? FutureBuilder<List<dynamic>>(
                                        future: const ReportAction()
                                            .getInboxAdm(widget.iP),
                                        builder: (con, ss) {
                                          if (ss.connectionState ==
                                              ConnectionState.done) {
                                            _data = ss.data!;
                                          }
                                          if (_data.isNotEmpty) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                rowFz(
                                                    pilihIcon("Inbox",
                                                        black: true),
                                                    "Inbox Admin"),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: spcButton(
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
                                                      doThisQuick: () async {
                                                        final pdFile =
                                                            await PdfInvoiceApi
                                                                .generateInboxAdm(
                                                                    _data);
                                                        PdfApi.openFile(pdFile);
                                                      }),
                                                ),
                                              ],
                                            );
                                          }
                                          if (ss.connectionState ==
                                                  ConnectionState.done &&
                                              _data.isEmpty) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                rowFz(
                                                    pilihIcon("Inbox",
                                                        black: true),
                                                    "Inbox Admin"),
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 30),
                                                  child: Text("Tidak Ada Data"),
                                                )
                                              ],
                                            );
                                          }
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              CircularProgressIndicator(),
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text("Memuat Data"),
                                              )
                                            ],
                                          );
                                        },
                                      )
                                    : (_pop == 7)
                                        ? FutureBuilder<List<dynamic>>(
                                            future: const ReportAction()
                                                .getKalender(widget.iP),
                                            builder: (con, ss) {
                                              if (ss.connectionState ==
                                                  ConnectionState.done) {
                                                _data = ss.data!;
                                              }
                                              if (_data.isNotEmpty) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    rowFz(
                                                        pilihIcon("Kalender",
                                                            black: true),
                                                        "Data Bulanan"),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: spcButton(
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
                                                          doThisQuick:
                                                              () async {
                                                            final pdFile =
                                                                await PdfInvoiceApi
                                                                    .generateKalender(
                                                                        _data);
                                                            PdfApi.openFile(
                                                                pdFile);
                                                          }),
                                                    ),
                                                  ],
                                                );
                                              }
                                              if (ss.connectionState ==
                                                      ConnectionState.done &&
                                                  _data.isEmpty) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    rowFz(
                                                        pilihIcon("Kalender",
                                                            black: true),
                                                        "Data Bulanan"),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 30),
                                                      child: Text(
                                                          "Tidak Ada Data"),
                                                    )
                                                  ],
                                                );
                                              }
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  CircularProgressIndicator(),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: Text("Memuat Data"),
                                                  )
                                                ],
                                              );
                                            },
                                          )
                                        : (_pop == 8 || _pop == 9 || _pop == 10)
                                            ? FutureBuilder<List<dynamic>>(
                                                future: _pop == 8
                                                    ? const ReportAction()
                                                        .getProgLayData(
                                                            widget.iP)
                                                    : _pop == 9
                                                        ? const ReportAction()
                                                            .getProgGanData(
                                                                widget.iP)
                                                        : const ReportAction()
                                                            .getProgBarData(
                                                                widget.iP),
                                                builder: (con, ss) {
                                                  if (ss.connectionState ==
                                                      ConnectionState.done) {
                                                    _data = ss.data!;
                                                  }
                                                  if (_data.isNotEmpty) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        rowFz(
                                                            (_pop == 8)
                                                                ? pilihIcon(
                                                                    "Progress Layanan",
                                                                    black: true)
                                                                : (_pop == 9)
                                                                    ? pilihIcon(
                                                                        "Progress Gangguan",
                                                                        black:
                                                                            true)
                                                                    : pilihIcon(
                                                                        "Progress Pemasangan Baru",
                                                                        black:
                                                                            true),
                                                            (_pop == 8)
                                                                ? "Progress Layanan"
                                                                : (_pop == 9)
                                                                    ? "Progress Gangguan"
                                                                    : "Progress Pemasangan Baru"),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: spcButton(
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
                                                              doThisQuick:
                                                                  () async {
                                                                final pdFile =
                                                                    await PdfInvoiceApi
                                                                        .generateProgress(
                                                                            _data);
                                                                PdfApi.openFile(
                                                                    pdFile);
                                                              }),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  if (ss.connectionState ==
                                                          ConnectionState
                                                              .done &&
                                                      _data.isEmpty) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        rowFz(
                                                            (_pop == 8)
                                                                ? pilihIcon(
                                                                    "Progress Layanan",
                                                                    black: true)
                                                                : (_pop == 9)
                                                                    ? pilihIcon(
                                                                        "Progress Gangguan",
                                                                        black:
                                                                            true)
                                                                    : pilihIcon(
                                                                        "Progress Pemasangan Baru",
                                                                        black:
                                                                            true),
                                                            (_pop == 8)
                                                                ? "Progress Layanan"
                                                                : (_pop == 9)
                                                                    ? "Progress Gangguan"
                                                                    : "Progress Pemasangan Baru"),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 30),
                                                          child: Text(
                                                              "Tidak Ada Data"),
                                                        )
                                                      ],
                                                    );
                                                  }
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      CircularProgressIndicator(),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child:
                                                            Text("Memuat Data"),
                                                      )
                                                    ],
                                                  );
                                                },
                                              )
                                            : FutureBuilder<List<dynamic>>(
                                                future: const ReportAction()
                                                    .getOpsiLay(
                                                        widget.iP,
                                                        (_pop == 11)
                                                            ? "OpsiLay"
                                                            : (_pop == 12)
                                                                ? "OpsiGan"
                                                                : "instansi"),
                                                builder: (con, ss) {
                                                  if (ss.connectionState ==
                                                      ConnectionState.done) {
                                                    _data = ss.data!;
                                                  }
                                                  if (_data.isNotEmpty) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        rowFz(
                                                            (_pop == 11 ||
                                                                    _pop == 12)
                                                                ? pilihIcon(
                                                                    "Atur Opsi Pelaporan",
                                                                    black: true)
                                                                : pilihIcon(
                                                                    "Data Instansi",
                                                                    black:
                                                                        true),
                                                            (_pop == 11)
                                                                ? "Opsi-opsi Layanan"
                                                                : (_pop == 12)
                                                                    ? "Opsi-opsi Gangguan"
                                                                    : "Report Data Instansi"),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: spcButton(
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
                                                              doThisQuick:
                                                                  () async {
                                                                final pdFile = await PdfInvoiceApi.generateOpsinInsta(
                                                                    _data,
                                                                    (_pop == 11)
                                                                        ? "layanan"
                                                                        : (_pop == 12)
                                                                            ? "gangguan"
                                                                            : "instansi");
                                                                PdfApi.openFile(
                                                                    pdFile);
                                                              }),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  if (ss.connectionState ==
                                                          ConnectionState
                                                              .done &&
                                                      _data.isEmpty) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        rowFz(
                                                            (_pop == 11 ||
                                                                    _pop == 12)
                                                                ? pilihIcon(
                                                                    "Atur Opsi Pelaporan",
                                                                    black: true)
                                                                : pilihIcon(
                                                                    "Data Instansi",
                                                                    black:
                                                                        true),
                                                            (_pop == 11)
                                                                ? "Opsi-opsi Layanan"
                                                                : (_pop == 12)
                                                                    ? "Opsi-opsi Gangguan"
                                                                    : "Report Data Instansi"),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 30),
                                                          child: Text(
                                                              "Tidak Ada Data"),
                                                        )
                                                      ],
                                                    );
                                                  }
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      CircularProgressIndicator(),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child:
                                                            Text("Memuat Data"),
                                                      )
                                                    ],
                                                  );
                                                },
                                              )
                    : null,
              ))
        ],
      ),
    );
  }

  Future<void> _popAndSwitch(int i) async {
    if (!widget.pop || _pop != i) {
      _pop = i;
      _data = [];
      if (widget.pop) {
        widget.report(false);
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 700));
      }
      widget.report(true);
      setState(() {});
    }
  }

  Widget _rowBox(Icon icon, String text, {required void Function() func}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 240,
            child: spcButton(
                child: Row(
                  children: [
                    icon,
                    Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: Text(text),
                    )
                  ],
                ),
                doThisQuick: () {
                  func();
                }),
          ),
        ],
      );
  Widget rowFz(
    Icon icon,
    String text,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Text(text),
          )
        ],
      );
}
