import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget spcButton(
    {required Widget child,
    required void Function()? doThisQuick,
    Duration long = const Duration(milliseconds: 50),
    Color? color = const Color.fromARGB(255, 250, 141, 98),
    double padding = 10}) {
  List<double> forces = [];
  forces.clear();
  for (int i = 0; i < 31; i++) {
    forces.add(i.toDouble());
  }
  double finale = 3;
  var _now = DateTime.now();
  return ChangeNotifierProvider<Durandal>(
    create: (context) => Durandal(),
    child: Consumer<Durandal>(
        builder: (context, durandal, _) => StreamBuilder(
            stream: Stream.periodic(durandal.duration),
            builder: (context, snapshot) {
              void ending() {
                for (int i = 0; i < 31; i++) {
                  forces[i] = i.toDouble();
                }
                finale = forces[30] / 10;
                durandal.isLong = true;
              }

              return GestureDetector(
                  onTapCancel: () => ending(),
                  onTapUp: (tapUpDetails) {
                    if (DateTime.now().isAfter(_now.add(long))) {
                      doThisQuick!();
                    }
                    ending();
                  },
                  onTapDown: (tappDetails) async {
                    _now = DateTime.now();
                    durandal.isLong = false;
                    forces[30] = forces[30] - 1;
                    finale = forces[30] / 10;
                    for (int i = 29; i > 0; i--) {
                      if (forces[i + 1] == i) {
                        finale = forces[i] / 10;
                        forces[i] = forces[i] - 1;
                      }
                    }
                    if (forces[1] == 0) {
                      finale = forces[0];
                    }
                  },
                  child: Card(
                    elevation: finale,
                    color: color,
                    child:
                        Padding(padding: EdgeInsets.all(padding), child: child),
                  ));
            })),
  );
}

class Durandal extends ChangeNotifier {
  bool _long = true;

  bool get isLong => _long;
  set isLong(bool value) {
    _long = value;
    notifyListeners();
  }

  Duration get duration =>
      (_long) ? const Duration(days: 1) : const Duration(milliseconds: 50);
}
