import 'package:flutter/material.dart';
import 'package:network_kominfo/pages/baru/petpages/petpage.dart';
import 'package:network_kominfo/pages/main_action.dart';
import 'package:network_kominfo/model/users.dart';
import 'package:network_kominfo/mysql/logingear.dart';
import 'package:network_kominfo/widgetsutils/bckground.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';

class LoginPage extends StatefulWidget {
  final String iP;
  const LoginPage({Key? key, required this.iP}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bool _correct = false;
  late bool _isObscure, _wrongPass, _wrongMail;
  String _add = "";

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  InputBorder _textboxbor(bool detrue) => UnderlineInputBorder(
      borderSide: BorderSide(color: (detrue) ? Colors.red : Colors.blueAccent));

  void falsify() {
    _isObscure = true;
    _wrongPass = false;
    _wrongMail = false;
  }

  @override
  void initState() {
    falsify();
    PhpConnect(
        party: (val) {
          _add = val;
        },
        rain: (val) {},
        antony: (val) {},
        form: () {
          setState(() {});
        }).checkAdmin(context, widget.iP);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? ipAdd = widget.iP;
    double tinggi = MediaQuery.of(context).size.height,
        lebar = MediaQuery.of(context).size.width;
    debugPrint(lebar.toString());
    return Scaffold(
      body: Stack(
        children: [
          const Background(
            pilih: 0,
            logged: false,
          ),
          SizedBox(
            height: tinggi,
            width: lebar,
            child: Padding(
              padding: EdgeInsets.only(
                  left: (lebar > 409)
                      ? lebar > 499
                          ? lebar / 8.5
                          : (lebar / 9 - lebar / 12)
                      : (lebar / 9 - lebar / 9.5)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Logo Kominfo saat landscape
                    if (tinggi < lebar)
                      Container(
                        margin: const EdgeInsets.all(50),
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage('assets/img/l_kominfo.png'))),
                      ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 12,
                          ),
                          if (tinggi > lebar)
                            Container(
                              margin: const EdgeInsets.only(bottom: 45),
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                          'assets/img/l_kominfo.png'))),
                            ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(20),
                            height: 300,
                            width: (lebar < 380) ? lebar : 380,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(colors: [
                                  Colors.blue.shade50,
                                  Colors.blue.shade100
                                ])),
                            child: ListView(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text("Email"),
                                ),
                                SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30, right: 30),
                                          child: SizedBox(
                                            width: 300,
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              controller: _email,
                                              decoration: InputDecoration(
                                                  focusedBorder:
                                                      _textboxbor(_wrongMail),
                                                  enabledBorder:
                                                      _textboxbor(_wrongMail),
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black26),
                                                  hintText: (_wrongMail)
                                                      ? "Email Salah!"
                                                      : "Email Here..."),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Password"),
                                          const SizedBox(
                                            width: 40,
                                          ),
                                          SizedBox(
                                            width: 220,
                                            child: TextField(
                                                decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                        icon: Icon(_isObscure
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off),
                                                        onPressed: () {
                                                          setState(() {
                                                            _isObscure =
                                                                !_isObscure;
                                                          });
                                                        }),
                                                    focusedBorder:
                                                        _textboxbor(_wrongPass),
                                                    enabledBorder:
                                                        _textboxbor(_wrongPass),
                                                    hintStyle: const TextStyle(
                                                        color: Colors.black26),
                                                    hintText: (_wrongPass)
                                                        ? ((_pass.text.length <
                                                                7)
                                                            ? "Password Kurang Panjang"
                                                            : "Password Salah")
                                                        : "Password Here..."),
                                                obscuringCharacter: '+',
                                                obscureText: _isObscure,
                                                controller: _pass),
                                          )
                                        ],
                                      )),
                                ),
                                SizedBox(height: tinggi / 15),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      bottom: 16,
                                    ),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          if (_email.text != "" &&
                                              _pass.text != "") {
                                            loading(context);
                                            PhpConnect(
                                                    form: () {},
                                                    party: (iPad) {},
                                                    rain: (list) {
                                                      falsify();
                                                      if (list != null) {
                                                        _wrongPass = true;
                                                      } else {
                                                        _wrongMail = true;
                                                      }
                                                      setState(() {});
                                                    },
                                                    antony: (huma) {
                                                      if (huma.email!
                                                              .toLowerCase() ==
                                                          "admin@kominfo.bjb") {
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (route) =>
                                                                            MainAction(
                                                                              aiPhi: widget.iP,
                                                                              user: huma,
                                                                            )));
                                                      } else {
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (route) =>
                                                                            DashPetugas(
                                                                              iP: widget.iP,
                                                                              user: huma,
                                                                            )));
                                                      }
                                                    })
                                                .doLogin(
                                                    ipAdd,
                                                    widget.iP,
                                                    _email,
                                                    _pass,
                                                    _correct,
                                                    context);
                                          }
                                        },
                                        child: const Text("Login"))),
                              ],
                            ),
                          ),
                          if (tinggi > lebar)
                            Container(
                              height: 200,
                              width: 150,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage('assets/img/gg.gif'))),
                            )
                        ],
                      ),
                    ),
                    if (tinggi < lebar)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (route) => MainAction(
                                        aiPhi: widget.iP,
                                        user: dummy,
                                      )));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(30),
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage('assets/img/gg.gif'))),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
          if (_add == "NoAdd")
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                  onPressed: () {
                    PhpConnect(
                            party: (val) {
                              _add = val;
                            },
                            rain: (val) {},
                            antony: (val) {},
                            form: () {})
                        .checkAdmin(context, widget.iP);
                  },
                  child: const Text("Add Admin")),
            )
        ],
      ),
    );
  }
}
