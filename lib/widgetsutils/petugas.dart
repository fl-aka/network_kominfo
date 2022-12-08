import 'package:flutter/material.dart';
import 'package:network_kominfo/mysql/allforpetugas.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';

typedef TakePetugas = void Function(String a);

class PetugasList extends StatefulWidget {
  final String ipIs;
  final TakePetugas petugas1;
  final TakePetugas petugas2;
  const PetugasList(
      {Key? key,
      required this.ipIs,
      required this.petugas1,
      required this.petugas2})
      : super(key: key);

  @override
  _PetugasListState createState() => _PetugasListState();
}

class _PetugasListState extends State<PetugasList> {
  String _petugas = "", _ePetugas = "";
  String _petugas2 = "", _ePetugas2 = "";
  List<dynamic>? _vertList;
  final _cariCon = TextEditingController();
  bool _emptyVert = true, _cariOn = false;
  TextStyle insideBubble = const TextStyle(fontSize: 20, color: Colors.black);

  void adding() async {
    _vertList = await CapelessHero(action: (just) {
      _emptyVert = just;
    }).getPetugas(widget.ipIs, _cariCon);
    if (_vertList!.length > 5) {
      _cariOn = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _cariCon.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    adding();
    return FutureBuilder<List>(
      future: CapelessHero(action: (just) {
        _emptyVert = just;
      }).getPetugas(widget.ipIs, _cariCon),
      builder: (context, snapshot) {
        return Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  textMng("Nama Petugas : ", insideBubble),
                  Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        _petugas2 == "" ? _petugas : "$_petugas dan $_petugas2",
                        style: const TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue))
                ],
              ),
            ),
            (_emptyVert)
                ? Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          child: const Text(
                            "Tidak Ada Data Petugas",
                            style: TextStyle(color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (_vertList == null || _vertList!.isEmpty)
                          ? Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                "Petugas Tidak Ditemukan",
                                style: TextStyle(color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue))
                          : SizedBox(
                              height: 47,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      _vertList == null ? 0 : _vertList!.length,
                                  itemBuilder: (context, i) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (_petugas == "" && _petugas2 == "") {
                                          _ePetugas = _vertList![i]['email'];
                                          _petugas = _vertList![i]['name'];
                                        } else if (_petugas2 == "") {
                                          if (_petugas !=
                                              _vertList![i]['name']) {
                                            _ePetugas2 = _vertList![i]['email'];
                                            _petugas2 = _vertList![i]['name'];
                                          } else {
                                            _petugas = "";
                                            _ePetugas = "";
                                          }
                                        } else {
                                          if (_petugas ==
                                              _vertList![i]['name']) {
                                            _petugas = _petugas2;
                                            _ePetugas = _ePetugas2;
                                            _petugas2 = "";
                                            _ePetugas2 = "";
                                          }
                                          if (_petugas2 ==
                                              _vertList![i]['name']) {
                                            _petugas2 = "";
                                            _ePetugas2 = "";
                                          }
                                        }
                                        widget.petugas1(_ePetugas);
                                        widget.petugas2(_ePetugas2);
                                        setState(() {});
                                      },
                                      child: Tooltip(
                                        message: _vertList![i]['email'],
                                        child: Card(
                                          elevation: (_ePetugas ==
                                                      _vertList![i]['email'] ||
                                                  _ePetugas2 ==
                                                      _vertList![i]['email'])
                                              ? 0
                                              : 2,
                                          color: (_ePetugas ==
                                                      _vertList![i]['email'] ||
                                                  _ePetugas2 ==
                                                      _vertList![i]['email'])
                                              ? Colors.red
                                              : Colors.blue,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              _vertList![i]['name'],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                      if (_cariOn)
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 36,
                                width: 180,
                                child: TextField(
                                  onChanged: (val) {
                                    setState(() {});
                                  },
                                  textAlignVertical: TextAlignVertical.bottom,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.search,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      hintText: "Cari..."),
                                  controller: _cariCon,
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  )
          ],
        );
      },
    );
  }
}
