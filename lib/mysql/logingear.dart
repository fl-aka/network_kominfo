import 'dart:convert';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:network_kominfo/model/users.dart';

typedef Huma = void Function(Users droid);
typedef Func = void Function(String iPad);
typedef Vail = void Function(List<dynamic>? vail);
typedef Holo = void Function();

class PhpConnect {
  final Func party;
  final Vail rain;
  final Huma antony;
  final Holo form;
  const PhpConnect(
      {Key? key,
      required this.party,
      required this.rain,
      required this.antony,
      required this.form});

  Future<void> doConnect(
      TextEditingController _ip, BuildContext context, bool connect) async {
    try {
      Uri dophp = Uri.parse("http://${_ip.text}/jaringan/conn/do.php");
      final respone = await http
          .post(dophp, body: {'key': 'KucingBeintalu', 'action': 'connect'});
      if (respone.body == '"Connected"') {
        party(_ip.text);
        connect = true;
      } else {
        int r = 0;
        for (int i = 0; i < _ip.text.length; i++) {
          if (_ip.text[i] == '.') r = i;
        }
        _ip.text = _ip.text.substring(0, r + 1);
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (builder) => AlertDialog(
                  content: Text(respone.body),
                  title: const Text("Error"),
                ));
      }
    } catch (e) {
      if (!connect) {
        int r = 0;
        for (int i = 0; i < _ip.text.length; i++) {
          if (_ip.text[i] == '.') r = i;
        }
        _ip.text = _ip.text.substring(0, r + 1);
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (builder) => AlertDialog(
                  content: Text(e.toString()),
                  title: const Text("Error"),
                ));
      }
    }
  }

  Future<void> checkAdmin(BuildContext context, String iP) async {
    try {
      Uri dophp = Uri.parse("http://$iP/jaringan/conn/do.php");
      final respone = await http.post(dophp, body: {
        'key': 'KucingBeintalu',
        'action': 'cekAdmin',
      });

      String feedback = respone.body;
      if (feedback == '0') {
        final pass = TextEditingController();
        party("NoAdd");
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: 270,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Akun Admin Tidak Terdeteksi di Server",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      const Text(
                        "Masukan Password Untuk Akun Admin :",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: pass,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Masukan Password",
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: ElevatedButton(
                          style: ButtonStyle(backgroundColor:
                              MaterialStateProperty.resolveWith(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.red;
                            }
                            return Colors.lightBlue;
                          })),
                          onPressed: () async {
                            try {
                              String hashed = DBCrypt().hashpw(pass.text,
                                  r'$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa');
                              Uri docari =
                                  Uri.parse("http://$iP/jaringan/conn/do.php");
                              final respone = await http.post(docari, body: {
                                'action': 'addAddmin',
                                'key': 'KucingBeintalu',
                                'tgl': DateTime.now().toString(),
                                'password': hashed
                              });
                              String reply = respone.body;

                              if (reply == 'Success') {
                                form();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Admin Berhasil Di Tambahkan")));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (builder) => AlertDialog(
                                          content: Text(reply),
                                          title: const Text("Gagal"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("OK"))
                                          ],
                                        ));
                              }
                            } catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (builder) => AlertDialog(
                                        content: Text(e.toString()),
                                        title: const Text("Error"),
                                      ));
                            }
                          },
                          child: const Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> doLogin(
    String? ipAdd,
    String _ip,
    TextEditingController _email,
    TextEditingController _pass,
    bool _correct,
    BuildContext context,
  ) async {
    try {
      ipAdd = _ip;
      Uri dophp = Uri.parse("http://$ipAdd/jaringan/conn/do.php");
      final respone = await http.post(dophp, body: {
        'key': 'KucingBeintalu',
        'action': 'getData',
        'email': _email.text,
      });

      List<dynamic>? list = jsonDecode(respone.body);

      String emails = _email.text.toLowerCase();

      for (int i = 0; i < list!.length; i++) {
        bool decrypt = DBCrypt().checkpw(_pass.text, list[i]['password']);
        if (emails == list[i]['email'].toString().toLowerCase() && decrypt) {
          _correct = true;
          Users loginIn = Users(
            list[i]['name'],
            list[i]['email'],
            list[i]['email_verified_at'],
            list[i]['remember_token'],
            DateTime.parse(list[i]['created_at']),
            DateTime.parse(list[i]['updated_at']),
            pp: list[i]['pp'],
          );
          Navigator.pop(context);
          antony(loginIn);
        }
      }

      if (!_correct) {
        rain(list);

        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (builder) => const AlertDialog(
                  content: Text("Username or Password salah"),
                  title: Text("Gagal"),
                ));
      }
    } catch (e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (builder) => AlertDialog(
                content: Text(e.toString()),
                title: const Text("Error"),
              ));
    }
  }
}
