import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:network_kominfo/pages/admin.dart';
import 'package:network_kominfo/pages/baru/new_baru.dart';
import 'package:network_kominfo/pages/baru/new_layanan.dart';
import 'package:network_kominfo/pages/dashBoardMenu/baru.dart';
import 'package:network_kominfo/pages/dashBoardMenu/layanan.dart';
import 'package:network_kominfo/pages/extra_page/waiting.dart';
import 'package:network_kominfo/model/users.dart';
import 'package:network_kominfo/pages/buatkasus.dart';
import 'package:network_kominfo/pages/buatpetugas.dart';
import 'package:network_kominfo/pages/dashboard.dart';
import 'package:network_kominfo/pages/inbox/inbox.dart';
import 'package:network_kominfo/pages/instansi/instansi.dart';
import 'package:network_kominfo/pages/kalender/kalender.dart';
import 'package:network_kominfo/pages/reportpage.dart';
import 'package:network_kominfo/pages/dashBoardMenu/gangguan.dart';
import 'package:http/http.dart' as http;
import 'package:network_kominfo/pages/tbl_prog/progress_bar.dart';
import 'package:network_kominfo/pages/tbl_prog/progress_gan.dart';
import 'package:network_kominfo/pages/tbl_prog/progress_lay.dart';

typedef ChangePage = void Function(int i);
typedef Popper = void Function(bool i);

class Chooser extends StatefulWidget {
  final ChangePage onDash;
  final Popper report;
  final Users? user;
  final int pilih;
  final bool exp;
  final bool pop;
  final String aiPi;
  const Chooser(this.user, this.pilih, this.aiPi,
      {Key? key,
      required this.onDash,
      required this.exp,
      required this.report,
      required this.pop})
      : super(key: key);

  @override
  State<Chooser> createState() => _ChooserState();
}

class _ChooserState extends State<Chooser> {
  List<dynamic> _lay = [];
  List<dynamic> _gan = [];
  Future<void> initLay() async {
    _lay = await _dataSetLay(widget.aiPi);
  }

  Future<void> initGan() async {
    _gan = await _dataSetGan(widget.aiPi);
  }

  Future<void> awaiy() async {
    await initLay();
    await initGan();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: awaiy(),
        builder: (context, ss) {
          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (context) {
              context.disallowIndicator();
              return false;
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: ((widget.pilih == 1)
                  ? Dashboard(
                      onCall: (i) {
                        widget.onDash(i);
                      },
                    )
                  : (widget.pilih == 2)
                      ? Layanan(ipIs: widget.aiPi)
                      : (widget.pilih == 3)
                          ? Gangguan(ipIs: widget.aiPi)
                          : (widget.pilih == 4)
                              ? AdminPage(
                                  mail: widget.user!.email!,
                                  ipIs: widget.aiPi,
                                )
                              : (widget.pilih == 5)
                                  ? Baru(ipIs: widget.aiPi)
                                  : (widget.pilih == 6)
                                      ? NewLaporLayan(
                                          key: const ValueKey<String>('lay'),
                                          ipIs: widget.aiPi,
                                          layanan: true,
                                          admin: true,
                                          data: _lay)
                                      : (widget.pilih == 7)
                                          ? NewLaporLayan(
                                              key:
                                                  const ValueKey<String>('gan'),
                                              ipIs: widget.aiPi,
                                              layanan: false,
                                              admin: true,
                                              data: _gan)
                                          : (widget.pilih == 8)
                                              ? Kalender(
                                                  exp: widget.exp,
                                                  ipIs: widget.aiPi,
                                                )
                                              : (widget.pilih == 9)
                                                  ? ProgressPage(
                                                      user: widget.user!,
                                                      exp: widget.exp,
                                                      ipIs: widget.aiPi)
                                                  : (widget.pilih == 10)
                                                      ? ProgressPageGan(
                                                          user: widget.user!,
                                                          exp: widget.exp,
                                                          ipIs: widget.aiPi)
                                                      : (widget.pilih == 11)
                                                          ? InKasus(
                                                              ip: widget.aiPi)
                                                          : (widget.pilih == 12)
                                                              ? Instansi(
                                                                  ipIs: widget
                                                                      .aiPi,
                                                                  exp: widget
                                                                      .exp,
                                                                )
                                                              : (widget.pilih ==
                                                                      13)
                                                                  ? InPetugas(
                                                                      ip: widget
                                                                          .aiPi,
                                                                      exp: widget
                                                                          .exp,
                                                                    )
                                                                  : (widget.pilih ==
                                                                          14)
                                                                      ? Inbox(
                                                                          key: const ValueKey<String>(
                                                                              "key1"),
                                                                          ipIs: widget
                                                                              .aiPi,
                                                                          layanan:
                                                                              1,
                                                                          exp: widget
                                                                              .exp)
                                                                      : (widget.pilih ==
                                                                              15)
                                                                          ? ReportPage(
                                                                              exp: widget.exp,
                                                                              iP: widget.aiPi,
                                                                              pop: widget.pop,
                                                                              report: (val) {
                                                                                widget.report(val);
                                                                              },
                                                                            )
                                                                          : (widget.pilih == 16)
                                                                              ? Inbox(key: const ValueKey<String>("key2"), ipIs: widget.aiPi, layanan: 2, exp: widget.exp)
                                                                              : (widget.pilih == 17)
                                                                                  ? Inbox(key: const ValueKey<String>("key0"), ipIs: widget.aiPi, layanan: 0, exp: widget.exp)
                                                                                  : (widget.pilih == 18)
                                                                                      ? ProgressPageBar(user: widget.user!, exp: widget.exp, ipIs: widget.aiPi)
                                                                                      : (widget.pilih == 31)
                                                                                          ? NewLaporBaru(
                                                                                              exp: widget.exp,
                                                                                              ipIs: widget.aiPi,
                                                                                              admin: true,
                                                                                            )
                                                                                          : const Waiter()),
            ),
          );
        });
  }

  Future<List> _dataSetLay(String ip) async {
    try {
      Uri dophp = Uri.parse("http://$ip/jaringan/conn/doPermasalahan.php");
      final respone = await http.post(dophp, body: {
        'action': 'getDataLay',
        'key': 'danLainLain',
      });
      return jsonDecode(respone.body);
    } catch (e) {
      return <String>[];
    }
  }

  Future<List> _dataSetGan(String ip) async {
    try {
      Uri dophp = Uri.parse("http://$ip/jaringan/conn/doPermasalahan.php");
      final respone = await http.post(dophp, body: {
        'action': 'getDataGan',
        'key': 'danLainLain',
      });
      return jsonDecode(respone.body);
    } catch (e) {
      return <String>[];
    }
  }
}
