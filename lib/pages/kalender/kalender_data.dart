import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:network_kominfo/widgetsutils/toindo.dart';

class KalenderList extends StatefulWidget {
  final List<dynamic>? list;
  final String ipIs;
  final Color color1;
  final ScrollController controller;
  const KalenderList(
    this.color1, {
    Key? key,
    required this.list,
    required this.ipIs,
    required this.controller,
  }) : super(key: key);

  @override
  State<KalenderList> createState() => _KalenderListState();
}

class _KalenderListState extends State<KalenderList> {
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
    Color headerCol = Colors.blueAccent;
    double aHei = 40, bHei = 50, bWid = 65, cWid = 65, dWid = 90, eWid = 75;
    final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;
    return ListView.builder(
        scrollDirection: (tinggi < lebar) ? Axis.horizontal : Axis.vertical,
        itemCount: widget.list == null ? 0 : widget.list!.length,
        itemBuilder: (context, i) {
          return SizedBox(
            height: 380,
            width: 500,
            child: Card(
              color: widget.color1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ListTile(
                        trailing: Text(
                          toIndo(widget.list![i]['0'].toString()),
                          style: const TextStyle(fontSize: 30),
                        ),
                        leading: const Icon(FontAwesomeIcons.calendarCheck,
                            size: 35),
                      ),
                    ),
                    const Divider(),
                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: headerCol,
                                          border: Border.all(),
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20))),
                                      height: aHei,
                                      width: bWid,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: headerCol,
                                      ),
                                      height: aHei,
                                      width: dWid,
                                      padding: const EdgeInsets.all(5),
                                      child: const Text(
                                        "Pemasangan Baru",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: headerCol,
                                          border: Border.all()),
                                      height: aHei,
                                      width: cWid,
                                      padding: const EdgeInsets.all(5),
                                      child: const Text("Layanan",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    Container(
                                      height: aHei,
                                      width: eWid,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: headerCol,
                                          border: Border.all(),
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20))),
                                      child: const Text("Gangguan",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: headerCol,
                                          border: Border.all()),
                                      height: bHei,
                                      width: bWid,
                                      padding: const EdgeInsets.all(10),
                                      child: const Text("Semua Data",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all()),
                                      height: bHei,
                                      width: dWid,
                                      child: Center(
                                        child: Text(
                                          widget.list![i]['1'].toString(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all()),
                                      height: bHei,
                                      width: cWid,
                                      child: Center(
                                        child: Text(
                                          widget.list![i]['2'].toString(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all()),
                                      height: bHei,
                                      width: eWid,
                                      child: Center(
                                        child: Text(
                                          widget.list![i]['3'].toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: headerCol,
                                          border: Border.all()),
                                      height: bHei,
                                      width: bWid,
                                      padding: const EdgeInsets.all(10),
                                      child: const Text("Semua Selesai",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all()),
                                      height: bHei,
                                      width: dWid,
                                      child: Center(
                                        child: Text(
                                          widget.list![i]['4'].toString(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all()),
                                      height: bHei,
                                      width: cWid,
                                      child: Center(
                                        child: Text(
                                          widget.list![i]['5'].toString(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all()),
                                      height: bHei,
                                      width: eWid,
                                      child: Center(
                                        child: Text(
                                          widget.list![i]['6'].toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: headerCol,
                                      ),
                                      height: bHei,
                                      width: bWid,
                                      padding: const EdgeInsets.all(10),
                                      child: const Text("Semua Proses",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all()),
                                      height: bHei,
                                      width: dWid,
                                      child: Center(
                                        child: Text(
                                          (int.parse(widget.list![i]['1']) -
                                                  int.parse(
                                                      widget.list![i]['4']))
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all()),
                                      height: bHei,
                                      width: cWid,
                                      child: Center(
                                        child: Text(
                                          (int.parse(widget.list![i]['2']) -
                                                  int.parse(
                                                      widget.list![i]['5']))
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all()),
                                      height: bHei,
                                      width: eWid,
                                      child: Center(
                                        child: Text(
                                          (int.parse(widget.list![i]['3']) -
                                                  int.parse(
                                                      widget.list![i]['6']))
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Total Data Masuk : ${(int.parse(widget.list![i]['1']) + int.parse(widget.list![i]['2']) + int.parse(widget.list![i]['3'])).toString()}",
                        style: const TextStyle(fontSize: 25),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
