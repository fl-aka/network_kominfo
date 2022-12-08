import 'dart:convert';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/spcbutton.dart';

class AdminPage extends StatefulWidget {
  final String ipIs;
  final String mail;
  const AdminPage({Key? key, required this.ipIs, required this.mail})
      : super(key: key);
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _lit = 0, _maxPage = 1;
  final _cariCon = TextEditingController(text: '');

  Future<void>? _setMaxPage() async {
    try {
      Uri docari = Uri.parse("http://${widget.ipIs}/jaringan/conn/do.php");
      final responecari = await http.post(docari,
          body: {'action': 'getJumlahData', 'key': 'KucingBeintalu'});

      double totalData = double.parse(responecari.body) - 1;
      _maxPage = totalData ~/ 6;
      if (totalData % 6 != 0 && totalData > 6) _maxPage++;
    } catch (e) {
      _maxPage = 1;
    }
  }

  Future<List> _dataSet() async {
    try {
      Uri dophp =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doPetugas.php");
      final respone = await http.post(dophp, body: {
        'action': 'getData',
        'key': 'RahasiaIlahi',
        'lit': _lit.toString(),
        'cari': _cariCon.text
      });
      return jsonDecode(respone.body);
    } catch (e) {
      debugPrint(e.toString());
      return <String>[];
    }
  }

  final List<Color> _colors = [];

  @override
  void initState() {
    for (int i = 0; i < 6; i++) {
      _colors.add(_getRandomColor());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tinggi = MediaQuery.of(context).size.height;
    var lebar = MediaQuery.of(context).size.width;
    return FutureBuilder<void>(
        future: _setMaxPage(),
        builder: (context, x) {
          return ListView(
            children: [
              const SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: (lebar > 400)
                        ? 320
                        : (lebar >= 80)
                            ? lebar - 80
                            : lebar,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: (lebar > 400) ? 270 : lebar - 130,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: _cariCon,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)))),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: const Icon(Icons.search))
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height - 180,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, offset: Offset(5, 4))
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                margin: const EdgeInsets.only(
                    top: 20, left: 20, right: 10, bottom: 5),
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    FutureBuilder<List>(
                        future: _dataSet(),
                        builder: (context, snapped) {
                          try {
                            if (snapped.hasError) {
                              return Center(
                                child: Text(snapped.toString()),
                              );
                            } else {
                              if (snapped.data!.isEmpty) {
                                return Padding(
                                  padding:
                                      EdgeInsets.only(bottom: tinggi - 290),
                                  child: noDataSizedBox(),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                ),
                                child: SizedBox(
                                    height: 550,
                                    width: 500,
                                    child: UserList(
                                      _colors,
                                      refresh: () {
                                        setState(() {});
                                      },
                                      mail: widget.mail,
                                      list: snapped.data,
                                      ipIs: widget.ipIs,
                                    )),
                              );
                            }
                          } catch (e) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: tinggi - 290),
                              child: noDataSizedBox(),
                            );
                          }
                        }),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 1; i <= _maxPage; i++)
                            GestureDetector(
                              onTap: () {
                                _lit = (6 * i) - 6;
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 17, right: 17, top: 13, bottom: 13),
                                margin: const EdgeInsets.all(10),
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
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  Color _getRandomColor() {
    int random = 0 + Random().nextInt(11);
    Color randCol;
    switch (random) {
      case 1:
        randCol = Colors.blue;
        break;
      case 2:
        randCol = Colors.red;
        break;
      case 3:
        randCol = Colors.yellow;
        break;
      case 4:
        randCol = Colors.green;
        break;
      case 5:
        randCol = Colors.pink;
        break;
      case 6:
        randCol = Colors.purpleAccent;
        break;
      case 7:
        randCol = Colors.redAccent;
        break;
      case 8:
        randCol = Colors.lightGreen;
        break;
      case 9:
        randCol = Colors.lime;
        break;
      case 10:
        randCol = Colors.orangeAccent;
        break;
      default:
        randCol = Colors.deepOrange;
    }

    return randCol;
  }
}

//Kode Untuk Daftar User
class UserList extends StatefulWidget {
  final List<dynamic>? list;
  final String ipIs;
  final String mail;
  final List<Color> colors;
  final Setstasis refresh;
  const UserList(
    this.colors, {
    Key? key,
    required this.list,
    required this.ipIs,
    required this.mail,
    required this.refresh,
  }) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  void initState() {
    super.initState();
  }

  final List<bool> _fronts = [
    true,
    true,
    true,
    true,
    true,
    true,
  ];

  @override
  Widget build(BuildContext context) {
    var tinggi = MediaQuery.of(context).size.height;
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: widget.list == null ? 0 : widget.list!.length,
        itemBuilder: (context, i) {
          bool inInt = _fronts[i];

          return FutureBuilder(builder: (context, snap) {
            return GestureDetector(
              onTap: () {
                _fronts[i] = !_fronts[i];
                setState(() {});
              },
              child: AnimatedSwitcher(
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                  return AnimatedBuilder(
                      animation: rotate,
                      child: child,
                      builder: (context, child) {
                        final angles =
                            (inInt) ? min(rotate.value, pi / 2) : rotate.value;
                        return Transform(
                          transform: Matrix4.rotationY(angles),
                          child: child,
                          alignment: Alignment.center,
                        );
                      });
                },
                duration: const Duration(milliseconds: 500),
                child: inInt
                    ? Container(
                        key: const ValueKey<String>("key1"),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: widget.colors[i],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView(
                            children: [
                              ListTile(
                                title: Text(widget.list![i]['name']),
                                leading: const Icon(
                                    FontAwesomeIcons.personBooth,
                                    size: 30),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child:
                                    Text("email : ${widget.list![i]['email']}"),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        key: const ValueKey<String>('Key2'),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: widget.colors[i],
                        ),
                        child: ListView(children: [
                          ListTile(
                              title: Text(widget.list![i]['name']),
                              leading: const Icon(
                                FontAwesomeIcons.chessKnight,
                                size: 30,
                                color: Colors.black,
                              )),
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: spcButton(
                                child: Row(
                                  children: const [
                                    Text("Petugas"),
                                    Spacer(),
                                    Icon(FontAwesomeIcons.chessKnight,
                                        size: 15),
                                  ],
                                ),
                                doThisQuick: () async {
                                  await vertAdd(context, i, tinggi);
                                }),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: spcButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Icon(FontAwesomeIcons.chessKnight,
                                        size: 13),
                                    Icon(Icons.arrow_forward_outlined,
                                        size: 13),
                                    Icon(FontAwesomeIcons.trash, size: 13),
                                  ],
                                ),
                                doThisQuick: () async {
                                  bool lanjut = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text(
                                                "Hapus Petugas Ini?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text("Iya")),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: const Text("Tidak")),
                                            ],
                                          ));
                                  if (lanjut) {
                                    try {
                                      Uri doHapus = Uri.parse(
                                          "http://${widget.ipIs}/jaringan/conn/doPetugas.php");
                                      final respone =
                                          await http.post(doHapus, body: {
                                        'action': 'hapHap',
                                        'key': 'RahasiaIlahi',
                                        'email': widget.mail,
                                        'id': widget.list![i]['email'],
                                        'tgl': DateTime.now().toString(),
                                      });
                                      String reply = respone.body;

                                      if (reply == 'SucessSucessSucess') {
                                        showDialog(
                                            context: context,
                                            builder: (builder) => AlertDialog(
                                                  content: Text(
                                                      "${widget.list![i]['name']} sekarang bukan petugas"),
                                                  title: const Text("Berhasil"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          for (int i = 0;
                                                              i < 6;
                                                              i++) {
                                                            _fronts[i] = true;
                                                          }
                                                          widget.refresh();
                                                        },
                                                        child: const Text("OK"))
                                                  ],
                                                ));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (builder) => AlertDialog(
                                                  content: Text(reply),
                                                  title: const Text("Gagal"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text("OK"))
                                                  ],
                                                ));
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
                                }),
                          ),
                        ])),
              ),
            );
          });
        });
  }

  Future<void> vertAdd(BuildContext context, int i, double tinggi) async {
    var inConNip = TextEditingController();
    var inConNKill = TextEditingController();
    var inConJab = TextEditingController();
    var inConMail = TextEditingController();
    var inConName = TextEditingController();
    var inConPass = TextEditingController();

    inConNip.text = widget.list![i]["nip"];
    inConNKill.text = widget.list![i]["skill"];
    inConJab.text = widget.list![i]["jabatan"];
    inConMail.text = widget.list![i]["email"];
    inConName.text = widget.list![i]["name"];

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: tinggi > 630 ? 630 : tinggi,
              padding: const EdgeInsets.all(21),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                        controller: inConName,
                        decoration: inputDec("Masukan Nama dia Disini")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                        controller: inConMail,
                        decoration: inputDec("Masukan Email dia Disini")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                        controller: inConNip,
                        decoration: inputDec("Masukan NIP Disini")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                        controller: inConNKill,
                        decoration: inputDec("Masukan Skill dia Disini")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                        controller: inConJab,
                        decoration: inputDec("Masukan Jabatan dia Disini")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      controller: inConPass,
                      decoration: inputDec("Masukan Password dia Disini"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: SizedBox(
                      width: 320,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor:
                            MaterialStateProperty.resolveWith(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.red;
                          }
                          return Colors.lightBlue;
                        })),
                        onPressed: () async {
                          try {
                            String password = DBCrypt().hashpw(inConPass.text,
                                r'$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa');
                            debugPrint(password);
                            Uri docari = Uri.parse(
                                "http://${widget.ipIs}/jaringan/conn/doPetugas.php");
                            final respone = await http.post(docari, body: {
                              'action': 'upVert',
                              'key': 'RahasiaIlahi',
                              'id': widget.list![i]['id'],
                              'email': inConMail.text,
                              'nip': inConNip.text,
                              'skill': inConNKill.text,
                              'jabatan': inConJab.text,
                              'name': inConName.text,
                              'pass': password,
                              'tgl': DateTime.now().toString(),
                            });
                            String reply = respone.body;

                            if (reply == 'SucessSucessSucess') {
                              showDialog(
                                  context: context,
                                  builder: (builder) => AlertDialog(
                                        content: const Text(
                                            "Data Berhasil di Update"),
                                        title: const Text("Berhasil"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                for (int i = 0; i < 6; i++) {
                                                  _fronts[i] = true;
                                                }
                                                setState(() {});
                                                widget.refresh();
                                              },
                                              child: const Text("OK"))
                                        ],
                                      ));
                            } else {
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
                            showDialog(
                                context: context,
                                builder: (builder) => AlertDialog(
                                      content: Text(e.toString()),
                                      title: const Text("Error"),
                                    ));
                          }
                        },
                        child: const Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  InputDecoration inputDec(String af) => InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        helperText: af,
      );
}
