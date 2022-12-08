import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef Setstasis = void Function();

Future<bool> _deny() async {
  return false;
}

Future<void> loading(BuildContext context) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
            onWillPop: _deny,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                height: 150,
                width: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image:
                                        AssetImage('assets/img/loading.gif')))),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 20.0),
                        child: Text("Loading..."),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
}

Widget noDataSizedBox() => const Center(
      child: Text(
        "Belum Ada Data",
        style: TextStyle(fontSize: 20, color: Colors.black54),
      ),
    );
Widget noPesanSizedBox() => const Center(
      child: Text(
        "Belum Ada Pesan",
        style: TextStyle(fontSize: 20, color: Colors.black54),
      ),
    );

Padding textMng(String text, TextStyle style) => Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: Text(
        text,
        style: style,
      ),
    );
Padding textField(int maxLn, TextEditingController con,
        {FocusNode? focus,
        bool? enabled,
        TextInputType? mode,
        int maxs = 30}) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLength: maxs,
        keyboardType: mode,
        enabled: (enabled != null) ? enabled : true,
        focusNode: (focus != null) ? focus : null,
        maxLines: maxLn,
        style: const TextStyle(fontSize: 18),
        controller: con,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );

Padding textFieldPass(int maxLn, TextEditingController con, bool _isObscure,
    {required Function action, FocusNode? focus}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      focusNode: (focus != null) ? focus : null,
      maxLines: maxLn,
      maxLength: 20,
      style: const TextStyle(fontSize: 18),
      controller: con,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.black26),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              action();
            }),
      ),
      obscuringCharacter: '+',
      obscureText: _isObscure,
    ),
  );
}

Color getBlueColor() {
  int random = 0 + Random().nextInt(4);
  Color randCol;
  switch (random) {
    case 1:
      randCol = const Color.fromARGB(255, 146, 170, 199);
      break;
    case 2:
      randCol = const Color.fromARGB(255, 208, 225, 249);
      break;
    case 3:
      randCol = const Color.fromARGB(255, 110, 181, 192);
      break;
    default:
      randCol = const Color.fromARGB(255, 174, 194, 198);
  }
  return randCol;
}

class AniRotBu extends StatelessWidget {
  final int i;
  final Widget child;
  const AniRotBu(
    this.i, {
    Key? key,
    required this.rotate,
    required this.child,
    required List<bool> fronts,
  })  : _fronts = fronts,
        super(key: key);

  final Animation<double> rotate;
  final List<bool> _fronts;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: rotate,
        child: child,
        builder: (context, child) {
          final angles =
              (_fronts[i]) ? min(rotate.value, pi / 2) : rotate.value;
          return Transform(
            transform: Matrix4.rotationY(angles),
            child: child,
            alignment: Alignment.center,
          );
        });
  }
}

Icon pilihIcon(String text, {bool tile = false, bool black = false}) {
  Icon returnIcon;
  switch (text) {
    case 'Dashboard':
      returnIcon = const Icon(
        FontAwesomeIcons.server,
        color: Colors.grey,
      );
      break;
    case 'Pemasangan Baru':
      returnIcon = Icon(
        FontAwesomeIcons.newspaper,
        color: black ? Colors.black : Colors.grey,
      );
      break;
    case 'Pengajuan Layanan':
      returnIcon = Icon(
        Icons.signal_wifi_4_bar,
        color: black ? Colors.black : Colors.grey,
      );
      break;
    case 'Pelaporan Gangguan':
      returnIcon = Icon(
        Icons.warning,
        color: black ? Colors.black : Colors.grey,
      );
      break;
    case 'Kalender':
      returnIcon = Icon(
        FontAwesomeIcons.calendarAlt,
        color: black ? Colors.black : Colors.grey,
      );
      break;
    case 'Progress Layanan':
      returnIcon = Icon(
        FontAwesomeIcons.projectDiagram,
        color: black ? Colors.black : Colors.grey,
      );
      break;
    case 'Progress Gangguan':
      returnIcon = Icon(
        FontAwesomeIcons.tools,
        color: black ? Colors.black : Colors.grey,
      );
      break;
    case 'Progress Pemasangan Baru':
      returnIcon = Icon(
        FontAwesomeIcons.robot,
        color: black ? Colors.black : Colors.grey,
      );
      break;
    case 'Atur Opsi Pelaporan':
      returnIcon = Icon(
        FontAwesomeIcons.stickyNote,
        color: black ? Colors.black : Colors.grey,
      );
      break;
    case 'Data Instansi':
      returnIcon = Icon(
        FontAwesomeIcons.building,
        color: black ? Colors.black : Colors.grey,
      );
      break;
    case 'Tambah Petugas':
      returnIcon = Icon(
        FontAwesomeIcons.chessKnight,
        color: black ? Colors.black : Colors.grey,
      );
      break;
    case 'Inbox':
      returnIcon = const Icon(
        FontAwesomeIcons.inbox,
        color: Colors.grey,
      );
      break;
    case 'Inbox Pemasangan Baru':
    case 'Inbox Layanan':
    case 'Inbox Gangguan':
      returnIcon = const Icon(
        FontAwesomeIcons.listAlt,
        color: Colors.grey,
      );
      break;
    case 'Report':
      returnIcon = const Icon(
        FontAwesomeIcons.bookReader,
        color: Colors.grey,
      );
      break;
    case 'Progress':
      returnIcon = Icon(
        FontAwesomeIcons.spinner,
        color: (tile) ? Colors.blue : Colors.grey,
      );
      break;
    case "Setting Admin":
      returnIcon = Icon(
        FontAwesomeIcons.chessKing,
        color: tile ? Colors.blue : Colors.grey,
      );
      break;
    case "Add Admin":
      returnIcon = Icon(
        FontAwesomeIcons.penFancy,
        color: tile ? Colors.blue : Colors.grey,
      );
      break;
    default:
      returnIcon = const Icon(
        FontAwesomeIcons.watchmanMonitoring,
        color: Colors.grey,
      );
      break;
  }

  return returnIcon;
}

double pasWidth(String vendor) {
  double pas = 0;
  for (int z = 0; z < vendor.length; z++) {
    switch (vendor[z]) {
      case 'A':
        pas += 19;
        break;
      case 'B':
        pas += 20;
        break;
      case 'C':
        pas += 18;
        break;
      case 'D':
        pas += 19.8;
        break;
      case 'E':
        pas += 19.6;
        break;
      case 'F':
        pas += 15.6;
        break;
      case 'G':
        pas += 20;
        break;
      case 'H':
        pas += 20.8;
        break;
      case 'I':
        pas += 8.1;
        break;
      case 'J':
        pas += 18;
        break;
      case 'K':
        pas += 19.5;
        break;
      case 'L':
        pas += 16;
        break;
      case 'M':
        pas += 25;
        break;
      case 'N':
        pas += 23;
        break;
      case 'O':
        pas += 19.5;
        break;
      case 'P':
        pas += 19.5;
        break;
      case 'Q':
        pas += 20;
        break;
      case 'R':
        pas += 19.5;
        break;
      case 'S':
        pas += 17;
        break;
      case 'T':
        pas += 18.5;
        break;
      case 'U':
        pas += 18.5;
        break;
      case 'V':
        pas += 20.5;
        break;
      case 'W':
        pas += 26;
        break;
      case 'X':
        pas += 19;
        break;
      case 'Y':
        pas += 18;
        break;
      case 'Z':
        pas += 19;
        break;
      case 'a':
        pas += 14.5;
        break;
      case 'b':
        pas += 17;
        break;
      case 'c':
        pas += 16.5;
        break;
      case 'd':
        pas += 16.5;
        break;
      case 'e':
        pas += 16.5;
        break;
      case 'f':
        pas += 11.5;
        break;
      case 'g':
        pas += 15;
        break;
      case 'h':
        pas += 16.5;
        break;

      case 'i':
        pas += 7.5;
        break;
      case 'j':
        pas += 7.5;
        break;

      case 'k':
        pas += 13;
        break;
      case 'l':
        pas += 7.5;
        break;
      case 'm':
        pas += 26;
        break;
      case 'n':
        pas += 17;
        break;
      case 'o':
        pas += 16.5;
        break;
      case 'p':
        pas += 17.38;
        break;
      case 'q':
        pas += 17.38;
        break;
      case 'r':
        pas += 12.3;
        break;
      case 's':
        pas += 18;
        break;
      case 't':
        pas += 17;
        break;
      case 'u':
        pas += 15;
        break;
      case 'v':
        pas += 15.5;
        break;
      case 'w':
        pas += 22.5;
        break;
      case 'x':
        pas += 14.5;
        break;
      case 'y':
        pas += 14.5;
        break;
      case 'z':
        pas += 14.5;
        break;
      case '1':
        pas += 14.5;
        break;
      case '2':
        pas += 19.5;
        break;
      case '3':
        pas += 18;
        break;
      case '4':
        pas += 18.5;
        break;
      case '5':
        pas += 17;
        break;
      case '6':
        pas += 17;
        break;
      case '7':
        pas += 16.5;
        break;
      case '8':
        pas += 16.5;
        break;
      case '9':
        pas += 16.5;
        break;
      case '0':
        pas += 17;
        break;
      case '@':
        pas += 27;
        break;
      default:
        pas += 0;
    }
  }
  return pas;
}
