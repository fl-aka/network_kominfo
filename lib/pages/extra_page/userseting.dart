import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network_kominfo/model/users.dart';
import 'package:network_kominfo/widgetsutils/spcbutton.dart';

class UserSetting extends StatefulWidget {
  final Users user;
  final String ipIs;
  const UserSetting({Key? key, required this.user, required this.ipIs})
      : super(key: key);

  @override
  State<UserSetting> createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  File? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Setting"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Hero(
                        tag: "DogTag",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: (image != null)
                              ? Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: 200,
                                )
                              : (widget.user.pp != null)
                                  ? Image.network(
                                      "http://${widget.ipIs}/jaringan/conn/uploads/pp/${widget.user.pp}",
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.account_circle,
                                      size: 200, color: Colors.blue),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: GestureDetector(
                          onLongPress: () {
                            debugPrint(widget.user.email!);
                            if (image != null) {
                              _uploadImage(image!, widget.user.email!, context);
                            }
                          },
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Row(
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
                            )));
                          },
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 30.0, top: 20),
            child: Text(
              "Quotes :",
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
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
      Uri dophp = Uri.parse("http://${widget.ipIs}/jaringan/conn/do.php");
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
