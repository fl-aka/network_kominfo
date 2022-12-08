//Ini Adalah File Menu Utama Akun Admin

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:network_kominfo/pages/extra_page/userseting.dart';
import 'package:network_kominfo/mysql/inmainaction.dart';
import 'package:network_kominfo/pages/login_page.dart';
import 'package:network_kominfo/widgetsutils/bckground.dart';
import 'package:network_kominfo/widgetsutils/chooser.dart';
import 'package:network_kominfo/widgetsutils/header.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/model/users.dart';

class MainAction extends StatefulWidget {
  final String aiPhi;
  final Users user;
  const MainAction({Key? key, required this.aiPhi, required this.user})
      : super(key: key);

  @override
  _MainActionState createState() => _MainActionState();
}

class _MainActionState extends State<MainAction> {
  int _pilih = 1;
  bool _expnaded = false,
      _exp = false,
      _tile = false,
      _tiles = false,
      _tile1 = false,
      _tile2 = false,
      _pop = false,
      _renNow = false,
      _ren = false;
  bool _toSetting = false, _logOut = false;
  Users? _user;
  String _aIPhi = "";
  DateTime _lastTime = DateTime.now();
  Map<String, dynamic>? inInbox = jsonDecode('{"yan":"0", "gan":"0"}');

  void pindahPage(BuildContext context) async {
    if (_user != null && _toSetting) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (builder) => UserSetting(
                user: _user!,
                ipIs: _aIPhi,
              )));
      _toSetting = false;
    }
    if (_logOut) {
      _logOut = false;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (builder) => LoginPage(
                iP: _aIPhi,
              )));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _user = widget.user;

    _aIPhi = widget.aiPhi;
  }

  @override
  Widget build(BuildContext context) {
    _user!.status = "twomni";
    double lebarA = _expnaded
        ? 300
        : _exp
            ? 60
            : 0;
    Widget twin = GestureDetector(
      onPanUpdate: (details) async {
        if (DateTime.now()
            .isAfter(_lastTime.add(const Duration(milliseconds: 500)))) {
          _lastTime = DateTime.now();

          if (details.delta.dx < -2) {
            _ren = false;
            _renNow = false;
            _exp = false;
          }
          if (details.delta.dx > 2) {
            _ren = false;
            _renNow = false;
            if (lebarA == 0) {
              _exp = true;
              _expnaded = false;
            } else if (lebarA == 60) {
              _expnaded = true;
              _exp = false;
            }
          }
          if (details.delta.dy > 2) {
            if (_pop) _pop = false;
          }
          setState(() {});
        }
      },
      child: Chooser(_user, _pilih, _aIPhi, exp: _exp, pop: _pop, onDash: (i) {
        _pilih = i;

        setState(() {});
      }, report: (val) {
        _pop = val;
        setState(() {});
      }),
    );

    Color warna =
        _expnaded ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0);

    final tinggi = MediaQuery.of(context).size.height;

    if (_toSetting) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => pindahPage(context));
    }

    if (_logOut) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => pindahPage(context));
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Background(pilih: _pilih, logged: true),
          ),
          twin,
          Header(
            _user!,
            ipIs: _aIPhi,
            menuFunc: (func) async {
              if (func == "Logout") {
                _pilih = 1;
                _user = dummy;
                _ren = false;
                _renNow = false;
                _logOut = true;
                await Future.delayed(const Duration(milliseconds: 300));
              }
              if (func == "expand") {
                _ren = false;
                _renNow = false;
                if (_expnaded) {
                  _expnaded = false;
                } else if (!_exp) {
                  _expnaded = true;
                }
              }
              if (func == "toSetting") {
                _ren = false;
                _exp = false;
                _toSetting = true;
              }
              setState(() {});
            },
          ),
          GestureDetector(
            onPanUpdate: (details) {
              if (DateTime.now()
                  .isAfter(_lastTime.add(const Duration(milliseconds: 500)))) {
                _lastTime = DateTime.now();
                _renNow = false;
                _ren = false;
                if (details.delta.dx < -1) {
                  setState(() {
                    _expnaded = false;
                    _exp = true;
                  });
                }
              }
            },
            onTap: () {
              if (_expnaded) {
                _renNow = false;
                _ren = false;
                setState(() {
                  if (_expnaded) {
                    _expnaded = false;
                    _exp = true;
                  }
                });
              }
            },
            child: Container(
                height: tinggi,
                width: _expnaded ? MediaQuery.of(context).size.width : 0,
                decoration: BoxDecoration(color: warna)),
          ),
          Row(
            children: [
              GestureDetector(
                onPanUpdate: (details) {
                  if (DateTime.now().isAfter(
                      _lastTime.add(const Duration(milliseconds: 500)))) {
                    _lastTime = DateTime.now();

                    if (details.delta.dx < -1) {
                      _ren = false;
                      _renNow = false;
                      _exp = false;
                      _expnaded = false;
                    }
                    if (details.delta.dx > 0) {
                      _ren = false;
                      _renNow = false;
                      if (lebarA == 60) {
                        _exp = false;
                        _expnaded = true;
                      } else if (lebarA == 300) {
                        _renNow = true;
                      }
                    }
                    setState(() {});
                  }
                },
                onTap: () {
                  if (lebarA == 60) {
                    _ren = true;
                  } else if (lebarA == 300) {
                    _renNow = true;
                  }
                  setState(() {});
                },
                child: AnimatedContainer(
                    onEnd: () async {
                      if (!_exp && !_expnaded) {
                        _renNow = false;
                        _ren = false;
                      }
                      if (_exp) {
                        _renNow = false;
                        _ren = true;
                      }
                      if (_expnaded) {
                        _renNow = true;
                        _ren = false;
                      }
                      await Future.delayed(const Duration(milliseconds: 285));
                      setState(() {});
                    },
                    duration: const Duration(milliseconds: 320),
                    height: tinggi,
                    width: lebarA,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.blueAccent,
                              Colors.white,
                              Colors.white,
                              Colors.white
                            ]),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        border: Border.all()),
                    child: ListView(children: [
                      AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          height: _exp ? 100 : 200,
                          width: 100,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                        begin: const Offset(-1, 0),
                                        end: const Offset(0, 0))
                                    .animate(animation),
                                child: Align(
                                    alignment: Alignment.center, child: child),
                              );
                            },
                            child: (_exp)
                                ? Container(
                                    key: const ValueKey<String>('Key1'),
                                    margin: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: AssetImage(
                                                'assets/img/l_bjb.png'))),
                                  )
                                : Container(
                                    key: const ValueKey<String>('Key2'),
                                    margin: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: AssetImage(
                                                'assets/img/gg.gif')))),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.blue.shade200,
                              Colors.blueAccent,
                            ]),
                          )),
                      const Divider(
                        height: 1,
                        thickness: 3,
                        color: Colors.black38,
                      ),
                      if (_renNow || _ren)
                        Container(
                          color: Colors.white,
                          child: FutureBuilder<Map<String, dynamic>>(
                              future: ActionLawsuit(action: (_, __) {})
                                  .inBoxPep(widget.aiPhi),
                              builder: (context, ss) {
                                inInbox = ss.data;
                                return Stack(
                                  children: [
                                    ExpansionTile(
                                      initiallyExpanded: _tiles,
                                      onExpansionChanged: (val) {
                                        _tiles = !_tiles;
                                        setState(() {});
                                      },
                                      trailing: const Text(""),
                                      title: (_ren)
                                          ? Container(
                                              child: pilihIcon(
                                                "Inbox",
                                                tile: _tiles,
                                              ),
                                            )
                                          : ListTile(
                                              mouseCursor:
                                                  SystemMouseCursors.click,
                                              trailing: (_tiles)
                                                  ? null
                                                  : Container(
                                                      height: 35,
                                                      width: 35,
                                                      child: Center(
                                                          child: Text(
                                                        (inInbox != null)
                                                            ? (int.parse(
                                                                        inInbox![
                                                                            'yan']!) +
                                                                    int.parse(
                                                                        inInbox![
                                                                            "gan"]!) +
                                                                    int.parse(
                                                                        inInbox![
                                                                            "bar"]!))
                                                                .toString()
                                                            : "0",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      )),
                                                      decoration: BoxDecoration(
                                                          color: (inInbox !=
                                                                  null)
                                                              ? ((int.parse(inInbox!["yan"]!) +
                                                                          int.parse(inInbox![
                                                                              "gan"]!) +
                                                                          int.parse(inInbox![
                                                                              "bar"]!)) >
                                                                      0)
                                                                  ? Colors.red
                                                                  : Colors.grey
                                                              : Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                    ),
                                              title: const Text("Inbox"),
                                              leading: pilihIcon("Inbox"),
                                            ),
                                      children: [
                                        if (_renNow)
                                          menuItem(17, "Inbox Pemasangan Baru",
                                              ekor: Container(
                                                height: 35,
                                                width: 35,
                                                child: Center(
                                                    child: Text(
                                                  (inInbox != null)
                                                      ? inInbox!["bar"]!
                                                      : "0",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                )),
                                                decoration: BoxDecoration(
                                                    color: (inInbox != null)
                                                        ? (int.parse(inInbox![
                                                                    "bar"]!) >
                                                                0)
                                                            ? Colors.red
                                                            : Colors.grey
                                                        : Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                              )),
                                        if (_ren)
                                          _menuIcon(17, "Inbox Pemasangan Baru",
                                              stack: Container(
                                                height: 15,
                                                width: 15,
                                                child: Center(
                                                    child: Text(
                                                  (inInbox != null)
                                                      ? inInbox!["bar"]!
                                                      : "0",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                )),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: (inInbox != null)
                                                        ? (int.parse(inInbox![
                                                                    "bar"]!) >
                                                                0)
                                                            ? Colors.red
                                                            : Colors.grey
                                                        : Colors.grey),
                                              )),
                                        if (_renNow)
                                          menuItem(14, "Inbox Layanan",
                                              ekor: Container(
                                                height: 35,
                                                width: 35,
                                                child: Center(
                                                    child: Text(
                                                  (inInbox != null)
                                                      ? inInbox!["yan"]!
                                                      : "0",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                )),
                                                decoration: BoxDecoration(
                                                    color: (inInbox != null)
                                                        ? (int.parse(inInbox![
                                                                    "yan"]!) >
                                                                0)
                                                            ? Colors.red
                                                            : Colors.grey
                                                        : Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                              )),
                                        if (_ren)
                                          _menuIcon(14, "Inbox Layanan",
                                              stack: Container(
                                                height: 15,
                                                width: 15,
                                                child: Center(
                                                    child: Text(
                                                  (inInbox != null)
                                                      ? inInbox!["yan"]!
                                                      : "0",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                )),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: (inInbox != null)
                                                        ? (int.parse(inInbox![
                                                                    "yan"]!) >
                                                                0)
                                                            ? Colors.red
                                                            : Colors.grey
                                                        : Colors.grey),
                                              )),
                                        if (_renNow)
                                          menuItem(16, "Inbox Gangguan",
                                              ekor: Container(
                                                height: 35,
                                                width: 35,
                                                child: Center(
                                                    child: Text(
                                                  (inInbox != null)
                                                      ? inInbox!["gan"]!
                                                      : "0",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                )),
                                                decoration: BoxDecoration(
                                                    color: (inInbox != null)
                                                        ? (int.parse(inInbox![
                                                                    "gan"]!) >
                                                                0)
                                                            ? Colors.red
                                                            : Colors.grey
                                                        : Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                              )),
                                        if (_ren)
                                          _menuIcon(16, "Inbox Gangguan",
                                              stack: Container(
                                                height: 15,
                                                width: 15,
                                                child: Center(
                                                    child: Text(
                                                  (inInbox != null)
                                                      ? inInbox!["gan"]!
                                                      : "0",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                )),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: (inInbox != null)
                                                        ? (int.parse(inInbox![
                                                                    "gan"]!) >
                                                                0)
                                                            ? Colors.red
                                                            : Colors.grey
                                                        : Colors.grey),
                                              )),
                                      ],
                                    ),
                                    if (!_tiles && _ren)
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        height: 15,
                                        width: 15,
                                        child: Center(
                                            child: Text(
                                          (inInbox != null)
                                              ? (int.parse(inInbox!["yan"]!) +
                                                      int.parse(
                                                          inInbox!["gan"]!) +
                                                      int.parse(
                                                          inInbox!["bar"]!))
                                                  .toString()
                                              : "0",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        )),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: (inInbox != null)
                                                ? (int.parse(inInbox!["yan"]!) +
                                                            int.parse(inInbox![
                                                                "bar"]!) +
                                                            int.parse(inInbox![
                                                                "gan"]!) >
                                                        0)
                                                    ? Colors.red
                                                    : Colors.grey
                                                : Colors.grey),
                                      )
                                  ],
                                );
                              }),
                        ),
                      if (_renNow || _ren)
                        Container(
                          color: Colors.white,
                          child: ExpansionTile(
                            initiallyExpanded: _tile2,
                            onExpansionChanged: (val) {
                              _tile2 = !_tile2;
                              setState(() {});
                            },
                            trailing: const Text(""),
                            title: (_ren)
                                ? pilihIcon("Add Admin", tile: _tile2)
                                : ListTile(
                                    mouseCursor: SystemMouseCursors.click,
                                    title: const Text("Add Data Admin"),
                                    leading: pilihIcon("Add Admin"),
                                  ),
                            children: [
                              if (_renNow) menuItem(31, "Pemasangan Baru"),
                              if (_ren) _menuIcon(31, "Pemasangan Baru"),
                              if (_renNow) menuItem(6, "Pengajuan Layanan"),
                              if (_ren) _menuIcon(6, "Pengajuan Layanan"),
                              if (_renNow) menuItem(7, "Pelaporan Gangguan"),
                              if (_ren) _menuIcon(7, "Pelaporan Gangguan"),
                            ],
                          ),
                        ),
                      if (_renNow) menuItem(8, "Kalender"),
                      if (_ren) _menuIcon(8, "Kalender"),
                      if (_renNow || _ren)
                        ExpansionTile(
                          initiallyExpanded: _tile,
                          onExpansionChanged: (val) {
                            _tile = !_tile;
                            setState(() {});
                          },
                          trailing: const Text(""),
                          title: (_ren)
                              ? pilihIcon("Progress", tile: _tile)
                              : ListTile(
                                  mouseCursor: SystemMouseCursors.click,
                                  title: const Text("Progress"),
                                  leading: pilihIcon("Progress"),
                                ),
                          children: [
                            if (_renNow)
                              menuItem(18, "Progress Pemasangan Baru"),
                            if (_ren) _menuIcon(18, "Progress Pemasangan Baru"),
                            if (_renNow) menuItem(9, "Progress Layanan"),
                            if (_ren) _menuIcon(9, "Progress Layanan"),
                            if (_renNow) menuItem(10, "Progress Gangguan"),
                            if (_ren) _menuIcon(10, "Progress Gangguan"),
                          ],
                        ),
                      if (_user != null)
                        if (_renNow || _ren)
                          ExpansionTile(
                            initiallyExpanded: _tile1,
                            onExpansionChanged: (val) {
                              _tile1 = !_tile1;
                              setState(() {});
                            },
                            trailing: const Text(""),
                            title: (_ren)
                                ? pilihIcon("Setting Admin", tile: _tile1)
                                : ListTile(
                                    mouseCursor: SystemMouseCursors.click,
                                    title: const Text("Setting Admin"),
                                    leading: pilihIcon("Setting Admin"),
                                  ),
                            children: [
                              if (_renNow) menuItem(11, "Atur Opsi Pelaporan"),
                              if (_ren) _menuIcon(11, "Atur Opsi Pelaporan"),
                              if (_renNow) menuItem(12, "Data Instansi"),
                              if (_ren) _menuIcon(12, "Data Instansi"),
                              if (_renNow) menuItem(13, "Tambah Petugas"),
                              if (_ren) _menuIcon(13, "Tambah Petugas"),
                            ],
                          ),
                      if (_renNow) menuItem(15, "Report"),
                      if (_ren) _menuIcon(15, "Report"),
                    ])),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget _menuIcon(int sang, String text, {Widget? stack}) => GestureDetector(
        onTap: () {
          if (_pilih != sang) {
            setState(() {
              _pop = false;
              _pilih = sang;
            });
          }
        },
        child: Stack(
          children: [
            Container(
              padding: (_pilih == sang)
                  ? const EdgeInsets.all(15)
                  : const EdgeInsets.all(13),
              decoration: BoxDecoration(
                  borderRadius: (_pilih == sang)
                      ? BorderRadius.circular(10)
                      : BorderRadius.circular(0),
                  color:
                      (_pilih == sang) ? Colors.blue.shade100 : Colors.white),
              child: pilihIcon(text),
            ),
            if (stack != null) stack,
          ],
        ),
      );

  Widget menuItem(int sang, String text, {Widget? ekor}) => GestureDetector(
        onTap: () {
          if (_pilih != sang) {
            setState(() {
              _pop = false;
              _pilih = sang;
            });
          }
        },
        child: Container(
          margin: (_pilih == sang)
              ? const EdgeInsets.all(5)
              : const EdgeInsets.all(0),
          decoration: BoxDecoration(
              borderRadius: (_pilih == sang)
                  ? BorderRadius.circular(10)
                  : BorderRadius.circular(0),
              color: (_pilih == sang) ? Colors.blue.shade100 : Colors.white),
          child: ListTile(
            mouseCursor: SystemMouseCursors.click,
            trailing: (ekor != null) ? ekor : null,
            title: Text(text),
            leading: pilihIcon(text),
          ),
        ),
      );

  Future<bool> _onBackPressed() async {
    if (_pilih == 1 && !_exp && !_expnaded) {
      return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Kembali Ke Awal Aplikasi?"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Iya")),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Tidak")),
                    ],
                  )) ??
          false;
    } else {
      if (_pop && !_exp && !_expnaded) {
        _pop = !_pop;
      }
      if (_exp) {
        if (_pilih == 1) {
          _exp = false;
          _ren = false;
        }
      }
      if (!_pop && !_expnaded) {
        _pilih = 1;
      }
      if (_expnaded) {
        _expnaded = false;
        _renNow = false;
      }
      setState(() {});
      return false;
    }
  }
}
