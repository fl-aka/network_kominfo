import 'package:flutter/material.dart';

typedef CallService = void Function(int i);

class Dashboard extends StatelessWidget {
  final CallService? onCall;
  const Dashboard({
    Key? key,
    required this.onCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;
    return dashboard(tinggi, lebar);
  }

  Container dashboard(double tinggi, double lebar) => Container(
        padding: const EdgeInsets.only(top: 70.0),
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Wrap(
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
                      width: 210,
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
                          Text("/ "),
                          Text(
                            "Dashboards ",
                            style: TextStyle(color: Colors.blue),
                          ),
                          Text("/ Data Selesai")
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            height: tinggi - 270,
            width: lebar,
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: ListView(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          onCall!(5);
                        },
                        child: box(
                            "REPORT",
                            const Icon(
                              Icons.crop_square,
                              size: 45,
                              color: Colors.white,
                            ),
                            lebar),
                      ),
                      if (lebar > 720)
                        GestureDetector(
                          onTap: () {
                            onCall!(2);
                          },
                          child: box(
                              "LAYANAN",
                              const Icon(
                                Icons.crop_square,
                                size: 45,
                                color: Colors.white,
                              ),
                              lebar),
                        ),
                      if (lebar > 720)
                        GestureDetector(
                          onTap: () {
                            onCall!(3);
                          },
                          child: box(
                              "LAPORAN",
                              const Icon(
                                Icons.crop_square,
                                size: 45,
                                color: Colors.white,
                              ),
                              lebar),
                        ),
                      if (lebar > 720)
                        GestureDetector(
                          onTap: () {
                            onCall!(4);
                          },
                          child: box(
                              "PROGRES",
                              const Icon(
                                Icons.crop_square,
                                size: 45,
                                color: Colors.white,
                              ),
                              lebar),
                        ),
                    ],
                  ),
                ),
                
                
                if (lebar <= 720)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            onCall!(2);
                          },
                          child: box(
                              "LAYANAN",
                              const Icon(
                                Icons.crop_square,
                                size: 45,
                                color: Colors.white,
                              ),
                              lebar),
                        ),
                      ],
                    ),
                  ),
                if (lebar <= 720)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            onCall!(3);
                          },
                          child: box(
                              "LAPORAN",
                              const Icon(
                                Icons.crop_square,
                                size: 45,
                                color: Colors.white,
                              ),
                              lebar),
                        ),
                      ],
                    ),
                  ),
                if (lebar <= 720)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            onCall!(4);
                          },
                          child: box(
                              "PROGRES",
                              const Icon(
                                Icons.crop_square,
                                size: 45,
                                color: Colors.white,
                              ),
                              lebar),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ]),
      );

  Container box(String text, Icon icon, double lebar) {
    String deskripsi = (text == "LAYANAN")
        ? "Layanan Terpasang"
        : (text == "LAPORAN")
            ? "Laporan Gangguan"
            : (text == "PROGRES")
                ? "Petugas"
                : (text == "REPORT")
                    ? "Pemasagan Baru"
                    : "";

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: const [Text("DATA"), Text("")],
                ),
              ),
              const Spacer(),
              Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.indigo,
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
}
