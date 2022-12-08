import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:network_kominfo/mysql/historydata.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/spcbutton.dart';

class InstansiList extends StatefulWidget {
  final List<dynamic>? list;
  final String ipIs;
  final Color color1;
  final Setstasis refresh;
  final ScrollController controller;
  const InstansiList(
    this.color1, {
    Key? key,
    required this.list,
    required this.ipIs,
    required this.refresh,
    required this.controller,
  }) : super(key: key);

  @override
  State<InstansiList> createState() => _InstansiListState();
}

class _InstansiListState extends State<InstansiList> {
  late Color statis;

  @override
  void initState() {
    statis = widget.color1;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<bool> _fronts = [
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
    return ListView.builder(
        scrollDirection: (tinggi < lebar) ? Axis.horizontal : Axis.vertical,
        itemCount: widget.list == null ? 0 : widget.list!.length,
        itemBuilder: (context, i) {
          String devil = widget.list![i]['nama_instansi'];
          double pas = pasWidth(devil);
          if (pas == 0) {
            pas = 100;
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: GestureDetector(
              onTap: () {
                _fronts[i] = !_fronts[i];
                setState(() {});
              },
              child: AnimatedSwitcher(
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                  return AniRotBu(i,
                      child: child, rotate: rotate, fronts: _fronts);
                },
                duration: const Duration(milliseconds: 500),
                child: !_fronts[i]
                    ? SizedBox(
                        key: const ValueKey<String>("key2"),
                        height: 300,
                        width: 500,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                              color: widget.color1,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 20.0),
                                      child: ListTile(
                                        leading: Text("Ubah Data",
                                            style: TextStyle(fontSize: 30)),
                                        trailing: Icon(FontAwesomeIcons.upload,
                                            size: 35),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Nama Instansi"),
                                          SizedBox(
                                            width: lebar - 100,
                                            child: SingleChildScrollView(
                                              reverse: true,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    widget.list![i]
                                                        ['nama_instansi'],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Alamat"),
                                          SizedBox(
                                            width: lebar - 100,
                                            child: SingleChildScrollView(
                                              reverse: true,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    widget.list![i]['tempat'],
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
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Kontak Instansi"),
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
                                                  Text((widget.list![i]
                                                              ['kontak'] !=
                                                          null)
                                                      ? widget.list![i]
                                                          ['kontak']
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
                                          const Text("Tanggal Daftar"),
                                          const Spacer(),
                                          Text(widget.list![i]['created_at']
                                              .toString()
                                              .substring(0, 10))
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                ),
                                SizedBox(
                                  height: 300,
                                  width: 500,
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                              width: 120,
                                              child: spcButton(
                                                doThisQuick: () {},
                                                child: Row(
                                                  children: const [
                                                    Text("Ubah"),
                                                    Spacer(),
                                                    Icon(
                                                        FontAwesomeIcons
                                                            .recycle,
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
                        ),
                      )
                    : SizedBox(
                        key: const ValueKey<String>("key1"),
                        height: 300,
                        width: 500,
                        child: Card(
                          color: statis,
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
                                        leading: SizedBox(
                                          width: (widget.list![i]
                                                          ['nama_instansi']
                                                      .toString()
                                                      .length <
                                                  8)
                                              ? pas
                                              : 130,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text(
                                                    widget.list![i]
                                                        ['nama_instansi'],
                                                    style: const TextStyle(
                                                        fontSize: 30)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        trailing: const Icon(
                                            FontAwesomeIcons.building,
                                            size: 35),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Alamat"),
                                          SizedBox(
                                            width: lebar - 100,
                                            child: SingleChildScrollView(
                                              reverse: true,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    widget.list![i]['tempat'],
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
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Kontak Instansi"),
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
                                                  Text((widget.list![i]
                                                              ['kontak'] !=
                                                          null)
                                                      ? widget.list![i]
                                                          ['kontak']
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
                                          const Text("Tanggal Daftar"),
                                          const Spacer(),
                                          Text(widget.list![i]['created_at']
                                              .toString()
                                              .substring(0, 10))
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                ),
                                SizedBox(
                                  height: 300,
                                  width: 500,
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                              width: 120,
                                              child: spcButton(
                                                doThisQuick: () {},
                                                child: Row(
                                                  children: const [
                                                    Text("Hapus"),
                                                    Spacer(),
                                                    Icon(
                                                        FontAwesomeIcons
                                                            .bookDead,
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
                        ),
                      ),
              ),
            ),
          );
        });
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
      try {
        Uri dophp =
            Uri.parse("http://${widget.ipIs}/jaringan/conn/doLayanan.php");
        final respone = await http.post(dophp, body: {
          'action': 'delData',
          'jenis': 'layanan',
          'key': 'CacingBernyanyi',
          'user': "Admin",
          'id': iD,
          'tgl': DateTime.now().toString()
        });
        if (respone.body == "SucessSucess") {
          _fronts = [true, true, true, true, true, true];
          Navigator.of(context).pop();
          widget.refresh();
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

  Future<void> tombolEdit(int i) async {
    try {
      Uri dophp =
          Uri.parse("http://${widget.ipIs}/jaringan/conn/doLayanan.php");
      final respone = await http.post(dophp, body: {
        'action': 'upPetugas',
        'key': 'CacingBernyanyi',
        'kodePel': widget.list![i]['IdPelaporan'],
        'tgl': DateTime.now().toString()
      });
      if (respone.body == "SucessSucess") {
        const HisAction()
            .kirimPet(widget.ipIs, widget.list![i]['KodePel'], context);
        Navigator.of(context).pop();
        _fronts = [true, true, true, true, true, true];
        widget.refresh();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Data Telah Dikirim")));
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
