import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:network_kominfo/mysql/inmainaction.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/spcbutton.dart';

class ItemList extends StatefulWidget {
  final String jenis;
  final List<dynamic>? list;
  final String ipIs;
  final Setstasis refresh;
  const ItemList(this.jenis,
      {Key? key, required this.list, required this.ipIs, required this.refresh})
      : super(key: key);

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final List<bool> _fronts = [true, true, true, true, true, true];
  File? image, image2, image3, image4, image5, image6;
  late String actor;

  @override
  void initState() {
    if (widget.jenis == "Layanan") {
      actor = "Pengajuan";
    } else if (widget.jenis == "Gangguan") {
      actor = "Pelaporan";
    } else {
      actor = "Pemasangan";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color inCol = getBlueColor();
    return ListView.builder(
        itemCount: widget.list == null ? 0 : widget.list!.length,
        itemBuilder: (context, i) {
          String devil = widget.list![i]['instansi'];
          double pas = pasWidth(devil);
          if (pas == 0) {
            pas = 100;
          }
          return GestureDetector(
            onTap: () {
              _fronts[i] = !_fronts[i];
              setState(() {});
            },
            child: SizedBox(
              height: 400,
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    final rotate =
                        Tween(begin: pi, end: 0.0).animate(animation);
                    return AniRotBu(i,
                        child: child, rotate: rotate, fronts: _fronts);
                  },
                  child: _fronts[i]
                      ? AnimatedContainer(
                          decoration: BoxDecoration(
                            color: inCol,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          duration: const Duration(milliseconds: 500),
                          key: const ValueKey<String>("key1"),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                ListTile(
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
                                  leading: const Icon(FontAwesomeIcons.building,
                                      size: 35),
                                ),
                                const Spacer(),
                                ListTile(
                                  leading: Text(actor),
                                  trailing: Text(widget.list![i]['deskripsi']),
                                ),
                                ListTile(
                                  leading: Text("Tanggal $actor"),
                                  trailing: Text(widget.list![i]['tanggal']),
                                ),
                                ListTile(
                                  leading: const Text("Tanggal Selesai "),
                                  trailing: Text(widget.list![i]['selesai']),
                                ),
                                ListTile(
                                  leading: const Text("Petugas "),
                                  trailing: Text(widget.list![i]['petugas']),
                                ),
                                const Spacer(),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Tap Untuk Melihat Foto")
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : AnimatedContainer(
                          decoration: BoxDecoration(
                            color: inCol,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          duration: const Duration(milliseconds: 500),
                          key: const ValueKey<String>("key2"),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                const ListTile(
                                  trailing: Text("Photo",
                                      style: TextStyle(fontSize: 30)),
                                  leading:
                                      Icon(FontAwesomeIcons.image, size: 35),
                                ),
                                SizedBox(
                                    height: 250,
                                    width: 600,
                                    child: Center(
                                      child: (widget.list![i]['image'] !=
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: spcButton(
                                              child: Row(
                                                children: const [
                                                  Text(
                                                      "Kembalikan ke Progress"),
                                                  Spacer(),
                                                  Icon(
                                                      FontAwesomeIcons.backward,
                                                      size: 15),
                                                ],
                                              ),
                                              doThisQuick: () async {
                                                ActionLawsuit(
                                                        action: (val, s) {})
                                                    .kembali(
                                                        widget.ipIs,
                                                        widget.list![i]
                                                            ['KodePel'],
                                                        context);
                                                widget.refresh();
                                              })),
                                    ),
                                  ],
                                ),
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
}
