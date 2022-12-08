//Halaman Pertama
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_kominfo/pages/baru/new_baru.dart';
import 'package:network_kominfo/pages/baru/new_layanan.dart';
import 'package:network_kominfo/mysql/logingear.dart';
import 'package:network_kominfo/pages/login_page.dart';
import 'package:network_kominfo/widgetsutils/bckground.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';

class NewAct extends StatefulWidget {
  const NewAct({Key? key}) : super(key: key);

  @override
  State<NewAct> createState() => _NewActState();
}

class _NewActState extends State<NewAct> {
  bool connect = false;
  late FocusNode _inIp;

  List<dynamic>? layanan;
  List<dynamic>? gangguan;

  final TextEditingController _ip = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inIp = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _inIp.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          const Background(pilih: -1),
          dashboard(tinggi, lebar, context),
        ],
      ),
    );
  }

  Container dashboard(double tinggi, double lebar, BuildContext context) =>
      Container(
        padding: const EdgeInsets.only(top: 30.0),
        child: ListView(children: [
          Wrap(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Kominfo Network",
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
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
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            height: (tinggi > 200) ? tinggi - 195 : tinggi,
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.only(
                      left: 15, right: 10, top: 12, bottom: 12),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          (connect)
                              ? const Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Icon(
                                    Icons.verified,
                                    color: Colors.green,
                                  ),
                                )
                              : const CircularProgressIndicator(),
                          SizedBox(
                            width: (connect) ? 15 : 20,
                          ),
                          SizedBox(
                            width: (lebar - 260 > 0) ? lebar - 260 : lebar,
                            child: TextField(
                                focusNode: _inIp,
                                style: TextStyle(
                                    color: (connect)
                                        ? Colors.green
                                        : Colors.black),
                                enabled: (connect) ? false : true,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 8, bottom: 30),
                                    hintStyle: const TextStyle(
                                        height: 3, color: Colors.black26),
                                    hintText: "IP",
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.green),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                controller: _ip),
                          ),
                          SizedBox(
                            width: connect ? 10 : 20,
                          ),
                          ElevatedButton(
                            child: (connect)
                                ? const Text("Disconnect")
                                : const Text("Connect"),
                            style: ButtonStyle(backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (connect) {
                                return Colors.red;
                              } else {
                                return Colors.blue;
                              }
                            })),
                            onPressed: () async {
                              if (!connect) {
                                if (_ip.text != "") {
                                  loading(context);
                                  PhpConnect(
                                    form: () {},
                                    antony: (huma) {},
                                    rain: (vail) {},
                                    party: (iPad) {
                                      connect = true;
                                      _ip.text = iPad;
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                  ).doConnect(_ip, context, connect);
                                }
                              } else {
                                connect = false;
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      )),
                  height: 80,
                  width: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          colors: [Colors.blue.shade50, Colors.blue.shade100])),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: 130,
                    width: lebar - 45,
                    child: GestureDetector(
                      onTap: () async {
                        if (connect) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) => NewLaporBaru(
                                    ipIs: _ip.text,
                                  )));
                        } else {
                          if (!connect) {
                            _inIp.requestFocus();
                            showDialog(
                                context: context,
                                builder: (builder) => const AlertDialog(
                                      content: Text(
                                          "Mohon Konekan ke Database dulu"),
                                      title: Text("Belum Konek"),
                                    ));
                          }
                        }
                      },
                      child: box(
                          "PEMASANGAN BARU",
                          const Icon(
                            Icons.send,
                            size: 35,
                            color: Colors.white,
                          ),
                          lebar),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 130,
                        width: lebar / 2.25,
                        child: GestureDetector(
                          onTap: () async {
                            if (connect) {
                              layanan = await _dataSetLay(_ip.text);
                              if (layanan != null && layanan!.isNotEmpty) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (builder) => NewLaporLayan(
                                          ipIs: _ip.text,
                                          layanan: true,
                                          data: layanan,
                                        )));
                              } else {
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
                                          content: const Text(
                                              "Tolong informasikan ke Admin server untuk menambah data permasalahan : Layanan"),
                                          title: const Text(
                                              "Data Isi Permasalahan Kosong"),
                                        ));
                              }
                            } else {
                              if (!connect) {
                                _inIp.requestFocus();
                                showDialog(
                                    context: context,
                                    builder: (builder) => const AlertDialog(
                                          content: Text(
                                              "Mohon Konekan ke Database dulu"),
                                          title: Text("Belum Konek"),
                                        ));
                              }
                            }
                          },
                          child: box(
                              "PERMINTAAN LAYANAN",
                              const Icon(
                                Icons.send,
                                size: 35,
                                color: Colors.white,
                              ),
                              lebar),
                        ),
                      ),
                      SizedBox(
                        width: (lebar / 8 - 55 > 0) ? lebar / 8 - 55 : 0,
                      ),
                      SizedBox(
                        height: 130,
                        width: lebar / 2.25,
                        child: GestureDetector(
                          onTap: () async {
                            if (connect) {
                              gangguan = await _dataSetGan(_ip.text);
                              if (gangguan != null && gangguan!.isNotEmpty) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (builder) => NewLaporLayan(
                                          ipIs: _ip.text,
                                          layanan: false,
                                          data: gangguan,
                                        )));
                              } else {
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
                                          content: const Text(
                                              "Tolong informasikan ke Admin server untuk menambah data permasalahan : Gangguan"),
                                          title: const Text(
                                              "Data Isi Permasalahan Kosong"),
                                        ));
                              }
                            } else {
                              if (!connect) {
                                _inIp.requestFocus();
                                showDialog(
                                    context: context,
                                    builder: (builder) => const AlertDialog(
                                          content: Text(
                                              "Mohon Konekan ke Database dulu"),
                                          title: Text("Belum Konek"),
                                        ));
                              }
                            }
                          },
                          child: box(
                              "PELAPORAN GANGGUAN",
                              const Icon(
                                Icons.send,
                                size: 35,
                                color: Colors.white,
                              ),
                              lebar),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: (tinggi > 700) ? tinggi - 700 : tinggi / 8,
                ),
                GestureDetector(
                    onTap: () {
                      //if (connect) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => LoginPage(
                                iP: _ip.text,
                              )));
                      // } else {
                      //   if (!connect) {
                      //     _inIp.requestFocus();
                      //     showDialog(
                      //         context: context,
                      //         builder: (builder) => const AlertDialog(
                      //               content:
                      //                   Text("Mohon Konekan ke Database dulu"),
                      //               title: Text("Belum Konek"),
                      //             ));
                      //   }
                      // }
                    },
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, offset: Offset(5, 4))
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.only(
                          left: 20, bottom: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: const [Text("LOGIN"), Text("")],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Icon(
                                    Icons.person,
                                    size: 45,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Login Petugas",
                              style: TextStyle(color: Colors.blue.shade600),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ]),
      );

  Container box(String text, Icon icon, double lebar) {
    String deskripsi = (text == "PERMINTAAN LAYANAN")
        ? "Ajukan Permintaan"
        : (text == "PEMASANGAN BARU")
            ? "Pemasangan Baru"
            : "Laporkan Gangguan";

    return Container(
      width: (lebar <= 720) ? lebar / 1.2 : lebar / 4.7,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(5, 4))
        ],
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(left: 20, bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: const [Text("FORM"), Text("")],
                ),
              ),
              const Spacer(),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50)),
                  child: icon),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              deskripsi,
              style: TextStyle(color: Colors.blue.shade600),
            ),
          ),
        ],
      ),
    );
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
}
