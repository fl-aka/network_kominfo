import 'dart:io';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';
import 'package:network_kominfo/widgetsutils/scroll_parent.dart';
import 'package:network_kominfo/widgetsutils/spcbutton.dart';

class InPetugas extends StatefulWidget {
  final String ip;
  final bool exp;
  const InPetugas({Key? key, required this.ip, required this.exp})
      : super(key: key);

  @override
  State<InPetugas> createState() => _InPetugasState();
}

class _InPetugasState extends State<InPetugas> {
  final _emailCon = TextEditingController();
  final _nikCon = TextEditingController();
  final _quotesCon = TextEditingController();
  final _namaCon = TextEditingController();
  final _skillCon = TextEditingController();
  final _passCon = TextEditingController();
  final _passVerCon = TextEditingController();
  final _jabCon = TextEditingController();

  final _email = FocusNode();
  final _minion = FocusNode();

  final _rollCon = ScrollController();
  bool _isObscure = true, _isObscureC = true, _isHonorer = false;
  File? image;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;

    TextStyle insideBubble = const TextStyle(fontSize: 16, color: Colors.black);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.only(top: 5, right: 5),
      margin: EdgeInsets.only(top: 40.0, left: widget.exp ? 50 : 20),
      child: ListView(
        controller: _rollCon,
        children: [
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
                    Text("/ "),
                    Text(
                      "Setting Admin ",
                      style: TextStyle(color: Colors.blue),
                    ),
                    Text("/ Buat Petugas")
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, right: 10),
                child: Container(
                  padding: const EdgeInsets.only(top: 50, left: 30, right: 10),
                  height: (tinggi >= 640) ? tinggi - 220 : 640,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          offset: Offset(3, 5),
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: ScrollParent(
                    controller: _rollCon,
                    child: ListView(
                      children: [
                        textMng("Email ", insideBubble),
                        textField(1, _emailCon, focus: _email),
                        textMng("Nama ", insideBubble),
                        textField(1, _namaCon),
                        textMng("NIP ", insideBubble),
                        textField(1, _nikCon,
                            enabled: !_isHonorer, mode: TextInputType.number),
                        Row(
                          children: [
                            Checkbox(
                                value: _isHonorer,
                                onChanged: (val) {
                                  _isHonorer = !_isHonorer;
                                  setState(() {});
                                }),
                            const Text("Honorer")
                          ],
                        ),
                        textMng("Jabatan ", insideBubble),
                        textField(1, _jabCon),
                        textMng("Password ", insideBubble),
                        textFieldPass(1, _passCon, _isObscure, action: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                        textMng("Password Verifikasi", insideBubble),
                        textFieldPass(1, _passVerCon, _isObscureC,
                            focus: _minion, action: () {
                          setState(() {
                            _isObscureC = !_isObscureC;
                          });
                        }),
                        const Divider(),
                        textMng("Informasi Tambahan", insideBubble),
                        const SizedBox(
                          height: 30,
                        ),
                        textMng("Foto Profile", insideBubble),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(200),
                              child: (image != null)
                                  ? Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: 200,
                                    )
                                  : const Icon(Icons.account_circle,
                                      size: 200, color: Colors.blue),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: spcButton(
                                    doThisQuick: () =>
                                        pickImage(ImageSource.gallery),
                                    child: Row(
                                      children: const [
                                        Text("Gallery"),
                                        Spacer(),
                                        Icon(FontAwesomeIcons.photoVideo,
                                            size: 15),
                                      ],
                                    ),
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: spcButton(
                                    doThisQuick: () =>
                                        pickImage(ImageSource.camera),
                                    child: Row(
                                      children: const [
                                        Text("Camera"),
                                        Spacer(),
                                        Icon(FontAwesomeIcons.cameraRetro,
                                            size: 15),
                                      ],
                                    ),
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        textMng("Skill ", insideBubble),
                        textField(5, _skillCon, maxs: 500),
                        textMng("Quotes ", insideBubble),
                        textField(5, _quotesCon, maxs: 500),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 50, left: 50, right: 50, bottom: 30),
                          child: ElevatedButton(
                              onPressed: () async {
                                loading(context);
                                submitButton(context);
                              },
                              child: const Text(
                                "Submit",
                                style: TextStyle(fontSize: 20),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 208, 225, 249),
                ),
                margin: const EdgeInsets.only(left: 20, top: 0.0),
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 110, 181, 192),
                      Color.fromARGB(255, 146, 170, 199)
                    ]),
                  ),
                  child: const Text(
                    "Tambah Petugas ",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> submitButton(BuildContext context) async {
    if (_emailCon.text != "" &&
        _namaCon.text != "" &&
        (_isHonorer || _nikCon.text != "") &&
        _jabCon.text != "" &&
        _passCon.text != "" &&
        _passCon.text == _passVerCon.text) {
      try {
        String hashed = DBCrypt().hashpw(_passCon.text,
            r'$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa');
        Uri doGo = Uri.parse("http://${widget.ip}/jaringan/conn/do.php");
        final respone = await http.post(doGo, body: {
          'action': 'addUser',
          'key': 'KucingBeintalu',
          'name': _namaCon.text,
          'email': _emailCon.text,
          'tgl': DateTime.now().toString(),
          'password': hashed
        });
        String reply = respone.body;

        if (reply == 'SucessSucess') {
          Uri doGoS =
              Uri.parse("http://${widget.ip}/jaringan/conn/doPetugas.php");
          final resz = await http.post(doGoS, body: {
            'action': 'addVert',
            'key': 'RahasiaIlahi',
            'nip': _nikCon.text,
            'skill': _skillCon.text,
            'jabatan': _jabCon.text,
            'email': _emailCon.text,
            'tgl': DateTime.now().toString(),
          });
          if (resz.body == "Sucess") {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Petugas Berhasil Di Tambahkan")));
            if (image != null) _uploadImage(image!, _emailCon.text, context);
            setEmpTb();
            setState(() {});
          } else {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (builder) => AlertDialog(
                      content:
                          Text("Gagal di Penambahan Petugas : ${resz.body}"),
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
        } else {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (builder) => AlertDialog(
                    content: Text("Gagal di Penambahan User : $reply"),
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
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (builder) => AlertDialog(
                  content: Text(e.toString()),
                  title: const Text("Error"),
                ));
      }
    } else {
      Navigator.of(context).pop();
      String error = "";
      if (_emailCon.text == "") {
        error += "Email Masih Kosong \n";
      }
      if (_namaCon.text == "") {
        error += "Nama Masih Kosong \n";
      }
      if (!_isHonorer && _nikCon.text == "") {
        error += "NIP Masih Kosong \n";
      }
      if (_jabCon.text == "") {
        error += "Jabatan Masih Kosong \n";
      }
      if (_passCon.text == "") {
        error += "Password Masih Kosong \n";
      }

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
                content: Text(error),
                title: const Text("Input Salah!"),
              ));
    }
  }

  void setEmpTb() {
    _emailCon.text = "";
    _nikCon.text = "";
    _quotesCon.text = "";
    _namaCon.text = "";
    _skillCon.text = "";
    _passCon.text = "";
    _passVerCon.text = "";
    _jabCon.text = "";

    _email.requestFocus();
    _rollCon.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeOut);
  }

  Future pickImage(ImageSource lead) async {
    try {
      final imageP = await ImagePicker().getImage(source: lead);
      if (imageP == null) return;

      final imageTempo = File(imageP.path);
      setState(() {
        image = imageTempo;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to Pick Image : $e');
    }
  }

  Future _uploadImage(File foto, String target, BuildContext context) async {
    try {
      Uri dophp = Uri.parse("http://${widget.ip}/jaringan/conn/do.php");
      final request = http.MultipartRequest('POST', dophp);
      request.fields['action'] = "Upload";
      request.fields['key'] = "KucingBeintalu";
      request.fields['target'] = target;
      var pic = await http.MultipartFile.fromPath("image", foto.path);
      request.files.add(pic);
      final response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Foto Berhasil Di Upload")));
      } else {
        debugPrint("Fail to Upload");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
