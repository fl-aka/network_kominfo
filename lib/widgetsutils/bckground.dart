import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final bool logged;
  final int pilih;
  const Background({Key? key, this.logged = false, required this.pilih})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;
    bool inputside = (pilih == 6 || pilih == 7 || pilih == 31) ? true : false;
    bool dashBoard =
        (pilih == 2 || pilih == 3 || pilih == 4 || pilih == 5) ? true : false;
    bool progSide = (pilih == 9 || pilih == 10 || pilih == 18) ? true : false;
    bool petpet = (pilih == 99 || pilih == 100) ? true : false;
    return SizedBox(
      height: tinggi,
      width: lebar,
      child: Stack(
        children: [
          AnimatedPositioned(
            left: petpet ? lebar / 2 : 0,
            top: (dashBoard || progSide) ? tinggi - tinggi / 3 : 0,
            duration: const Duration(seconds: 1),
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: petpet
                  ? tinggi / 2
                  : logged
                      ? tinggi
                      : (dashBoard || progSide)
                          ? tinggi / 3
                          : tinggi,
              width: lebar,
              decoration: (dashBoard || progSide || petpet)
                  ? BoxDecoration(
                      boxShadow: [
                          BoxShadow(
                              color: Colors.blue.shade100,
                              offset: petpet
                                  ? const Offset(0, 24)
                                  : const Offset(0, -24)),
                          BoxShadow(
                              color: Colors.blue.shade200,
                              offset: petpet
                                  ? const Offset(0, 12)
                                  : const Offset(0, -12)),
                        ],
                      borderRadius: BorderRadius.only(
                          bottomLeft: (petpet)
                              ? Radius.elliptical(lebar - 20, tinggi / 3)
                              : const Radius.elliptical(50, 10),
                          bottomRight: (petpet)
                              ? Radius.elliptical(lebar - 20, tinggi / 3)
                              : const Radius.elliptical(50, 10),

                          //+++++++++++++++++++++++++++++++++++++++++++//
                          topLeft: progSide
                              ? Radius.elliptical(0, lebar * 1.5)
                              : (inputside)
                                  ? const Radius.elliptical(0, 0)
                                  : const Radius.elliptical(50, 10),
                          topRight: progSide
                              ? Radius.elliptical(tinggi / 1.5, lebar * 1.5)
                              : (inputside)
                                  ? Radius.elliptical(lebar - 20, tinggi / 2)
                                  : const Radius.elliptical(50, 10)),
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.blue, Colors.blueAccent]))
                  : BoxDecoration(
                      color: logged
                          ? Colors.white
                          : (pilih == -1)
                              ? Colors.grey
                              : Colors.indigo,
                    ),
            ),
          ),
          ClipPath(
              clipper: BackgroundClipper(lebar, tinggi, logged: logged),
              child: AnimatedContainer(
                width: petpet ? lebar / 2 : lebar,
                height: (!logged)
                    ? tinggi * 0.55
                    : petpet
                        ? tinggi / 2
                        : (inputside)
                            ? tinggi
                            : tinggi / 2.5,
                duration: const Duration(seconds: 1),
                decoration: (logged)
                    ? BoxDecoration(
                        boxShadow: [
                            BoxShadow(
                                color: Colors.blue.shade100,
                                offset: const Offset(0, 24)),
                            BoxShadow(
                                color: Colors.blue.shade200,
                                offset: const Offset(0, 12)),
                          ],
                        borderRadius: BorderRadius.only(
                            bottomLeft: petpet
                                ? Radius.elliptical(0, tinggi / 3)
                                : progSide
                                    ? Radius.elliptical(
                                        tinggi / 1.5, lebar * 1.5)
                                    : (inputside)
                                        ? const Radius.elliptical(0, 0)
                                        : const Radius.elliptical(50, 10),
                            bottomRight: petpet
                                ? Radius.elliptical(lebar - 20, tinggi / 3)
                                : progSide
                                    ? Radius.elliptical(0, lebar * 1.5)
                                    : (inputside)
                                        ? Radius.elliptical(
                                            lebar - 20, tinggi / 2)
                                        : const Radius.elliptical(50, 10)),
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.blue, Colors.blueAccent]))
                    : BoxDecoration(
                        color: (pilih == -1)
                            ? Colors.indigo
                            : Colors.grey.shade300),
              )),
        ],
      ),
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  final bool logged;
  final double lebar;
  final double tinggi;
  BackgroundClipper(this.lebar, this.tinggi, {this.logged = true});
  @override
  Path getClip(Size size) {
    var path = Path();
    if (logged) {
      path.lineTo(0, tinggi);
      path.lineTo(lebar, tinggi);
      path.lineTo(lebar, 0);
    } else {
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height - (size.height * 0.15));
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
