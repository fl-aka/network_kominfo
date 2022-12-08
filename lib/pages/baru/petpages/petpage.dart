import 'package:flutter/material.dart';
import 'package:network_kominfo/model/users.dart';
import 'package:network_kominfo/pages/baru/petpages/chooser_pet.dart';
import 'package:network_kominfo/pages/extra_page/userseting.dart';
import 'package:network_kominfo/pages/login_page.dart';
import 'package:network_kominfo/widgetsutils/bckground.dart';
import 'package:network_kominfo/widgetsutils/header.dart';

class DashPetugas extends StatefulWidget {
  final Users user;
  final String iP;
  const DashPetugas({Key? key, required this.user, required this.iP})
      : super(key: key);

  @override
  _DashPetugasState createState() => _DashPetugasState();
}

class _DashPetugasState extends State<DashPetugas> {
  int _pilih = 99;
  int _con = 1;
  DateTime _lastTime = DateTime.now();
  bool _exp = false, _ren = false, _logOut = false, _toSetting = false;
  @override
  Widget build(BuildContext context) {
    double lebarA = _exp ? 60 : 0;
    double tinggi = MediaQuery.of(context).size.height;
    if (_toSetting) {
      WidgetsBinding.instance.addPostFrameCallback((_) => pindahPage(context));
    }

    if (_logOut) {
      WidgetsBinding.instance.addPostFrameCallback((_) => pindahPage(context));
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: GestureDetector(
          onPanUpdate: (details) async {
            if (DateTime.now()
                .isAfter(_lastTime.add(const Duration(milliseconds: 500)))) {
              _lastTime = DateTime.now();
              _ren = false;
              if (details.delta.dx < -1) {
                if (lebarA == 0) {
                  _ren = true;
                  _exp = true;
                } else if (lebarA == 60) {
                  _exp = false;
                }
              }
              if (details.delta.dx > 0) {
                _exp = false;
              }
              setState(() {});
            }
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Background(
                  pilih: _pilih,
                  logged: true,
                ),
              ),
              ChooserPet(widget.user, _con, widget.iP, onPass: (val) {
                _con = val;
                setState(() {});
              }, context: context),
              Header(widget.user, ipIs: widget.iP, hide: true,
                  menuFunc: (func) async {
                if (func == "Logout") {
                  _pilih = 9;
                  _ren = false;
                  _logOut = true;
                  await Future.delayed(const Duration(milliseconds: 300));
                }

                if (func == "toSetting") {
                  _ren = false;
                  _exp = false;
                  _toSetting = true;
                }
                setState(() {});
              }),
              Positioned(
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                        color: Colors.white, border: Border.all()),
                    height: tinggi,
                    width: lebarA,
                    child: (_ren)
                        ? ListView(
                            children: [
                              for (int i = 1; i <= 5; i++)
                                GestureDetector(
                                  onTap: () {
                                    if (i == 1) {
                                      _pilih = 99;
                                    }
                                    if (i == 2) {
                                      _pilih = 1;
                                    }
                                    if (i == 3) {
                                      _pilih = 2;
                                    }
                                    if (i == 4) {
                                      _pilih = 6;
                                    }
                                    if (i == 5) {
                                      _pilih = 9;
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 17,
                                        right: 17,
                                        top: 13,
                                        bottom: 13),
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8, top: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: AlignmentDirectional.topStart,
                                            colors: [
                                              Colors.blueAccent.shade200,
                                              Colors.amber
                                            ])),
                                    child: Text(i.toString(),
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                )
                            ],
                          )
                        : null,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (_con != 1) {
      _con = 1;
      setState(() {});
      return false;
    }
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
  }

  void pindahPage(BuildContext context) async {
    if (_toSetting) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (builder) => UserSetting(
                user: widget.user,
                ipIs: widget.iP,
              )));
      _toSetting = false;
    }
    if (_logOut) {
      _logOut = false;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (builder) => LoginPage(
                iP: widget.iP,
              )));
    }
  }
}
