import 'package:flutter/material.dart';
import 'package:network_kominfo/model/users.dart';
import 'package:network_kominfo/mysql/inmainaction.dart';
import 'package:network_kominfo/pages/baru/petpages/inbox.dart';
import 'package:network_kominfo/pages/baru/petpages/progress.dart';
import 'package:network_kominfo/pages/extra_page/waiting.dart';
import 'package:network_kominfo/widgetsutils/robot.dart';

typedef ChangePage = void Function(int i);

class ChooserPet extends StatelessWidget {
  final ChangePage onPass;
  final Users? user;
  final int pilih;
  final String aiPi;
  final BuildContext context;
  const ChooserPet(this.user, this.pilih, this.aiPi,
      {Key? key, required this.onPass, required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: (pilih == 0)
            ? InboxPetMenu(email: user!.email!, ipIs: aiPi, layanan: 0)
            : (pilih == 1)
                ? dashboard(tinggi, lebar, context)
                : (pilih == 2)
                    ? InboxPetMenu(email: user!.email!, ipIs: aiPi, layanan: 1)
                    : (pilih == 3)
                        ? InboxPetMenu(
                            email: user!.email!, ipIs: aiPi, layanan: 2)
                        : (pilih == 4)
                            ? ProgressPagePet(
                                ipIs: aiPi, user: user!, layanan: 1)
                            : (pilih == 5)
                                ? ProgressPagePet(
                                    ipIs: aiPi, user: user!, layanan: 2)
                                : (pilih == 6)
                                    ? ProgressPagePet(
                                        ipIs: aiPi, user: user!, layanan: 0)
                                    : const Waiter());
  }

  Container dashboard(double tinggi, double lebar, BuildContext context) =>
      Container(
        width: lebar,
        height: tinggi,
        padding: const EdgeInsets.only(top: 60.0),
        child: ListView(children: [
          Wrap(
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
                          "Dashboards Petugas",
                          style: TextStyle(color: Colors.blue),
                        ),
                        Text("/ Default")
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            height: (tinggi > 200) ? tinggi - 200 : tinggi,
            width: lebar,
            margin:
                const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 35),
            child: ListView(
              children: [
                FutureBuilder<List>(
                    future: ActionLawsuit(action: (_, __) {})
                        .inBoxPet(aiPi, user!.email!),
                    builder: (context, ss) {
                      List<dynamic>? inInbox = ss.data;

                      return box(
                          "Inbox",
                          const Icon(
                            Icons.mail,
                            size: 35,
                            color: Colors.white,
                          ),
                          lebar,
                          data: inInbox,
                          anak2: [
                            GestureDetector(
                              onTap: () {
                                onPass(0);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: ListTile(
                                  mouseCursor: SystemMouseCursors.click,
                                  trailing: Container(
                                    height: 35,
                                    width: 35,
                                    child: Center(
                                        child: Text(
                                      (inInbox != null)
                                          ? inInbox[0]["bar"]
                                          : "0",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )),
                                    decoration: BoxDecoration(
                                        color: (inInbox != null)
                                            ? (int.parse(inInbox[0]["bar"]) > 0)
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  title: const Text("Inbox Pemasangan Baru"),
                                  leading: const Icon(Icons.mark_email_read),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                onPass(2);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: ListTile(
                                  mouseCursor: SystemMouseCursors.click,
                                  trailing: Container(
                                    height: 35,
                                    width: 35,
                                    child: Center(
                                        child: Text(
                                      (inInbox != null)
                                          ? inInbox[0]["yan"]
                                          : "0",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )),
                                    decoration: BoxDecoration(
                                        color: (inInbox != null)
                                            ? (int.parse(inInbox[0]["yan"]) > 0)
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  title: const Text("Inbox Layanan"),
                                  leading: const Icon(Icons.mark_email_read),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                onPass(3);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: ListTile(
                                  mouseCursor: SystemMouseCursors.click,
                                  trailing: Container(
                                    height: 35,
                                    width: 35,
                                    child: Center(
                                        child: Text(
                                      (inInbox != null)
                                          ? inInbox[0]["gan"]
                                          : "0",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )),
                                    decoration: BoxDecoration(
                                        color: (inInbox != null)
                                            ? (int.parse(inInbox[0]["gan"]) > 0)
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  title: const Text("Inbox Gangguan"),
                                  leading: const Icon(Icons.mark_email_read),
                                ),
                              ),
                            )
                          ]);
                    }),
                FutureBuilder<List>(
                    future: ActionLawsuit(action: (_, __) {})
                        .inBoxPetPro(aiPi, user!.email!),
                    builder: (context, ss) {
                      List<dynamic>? inInbox = ss.data;
                      return box(
                          "Progress",
                          const Icon(
                            Icons.work,
                            size: 35,
                            color: Colors.white,
                          ),
                          lebar,
                          data: inInbox,
                          anak2: [
                            GestureDetector(
                              onTap: () {
                                onPass(6);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: ListTile(
                                  mouseCursor: SystemMouseCursors.click,
                                  trailing: Container(
                                    height: 35,
                                    width: 35,
                                    child: Center(
                                        child: Text(
                                      (inInbox != null)
                                          ? inInbox[0]["bar"]
                                          : "0",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )),
                                    decoration: BoxDecoration(
                                        color: (inInbox != null)
                                            ? (int.parse(inInbox[0]["bar"]) > 0)
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  title: const Text("Progress Pemasangan Baru"),
                                  leading:
                                      pilihIcon("Progress Pemasangan Baru"),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                onPass(4);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: ListTile(
                                  mouseCursor: SystemMouseCursors.click,
                                  trailing: Container(
                                    height: 35,
                                    width: 35,
                                    child: Center(
                                        child: Text(
                                      (inInbox != null)
                                          ? inInbox[0]["yan"]
                                          : "0",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )),
                                    decoration: BoxDecoration(
                                        color: (inInbox != null)
                                            ? (int.parse(inInbox[0]["yan"]) > 0)
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  title: const Text("Progress Layanan"),
                                  leading: pilihIcon("Progress Layanan"),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                onPass(5);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: ListTile(
                                  mouseCursor: SystemMouseCursors.click,
                                  trailing: Container(
                                    height: 35,
                                    width: 35,
                                    child: Center(
                                        child: Text(
                                      (inInbox != null)
                                          ? inInbox[0]["gan"]
                                          : "0",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )),
                                    decoration: BoxDecoration(
                                        color: (inInbox != null)
                                            ? (int.parse(inInbox[0]["gan"]) > 0)
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  title: const Text("Progress Gangguan"),
                                  leading: pilihIcon("Progress Gangguan"),
                                ),
                              ),
                            )
                          ]);
                    }),
              ],
            ),
          ),
        ]),
      );

  Container box(String text, Icon icon, double lebar,
      {required List<Widget> anak2, List<dynamic>? data}) {
    String deskripsi = (text == "Inbox") ? "Inbox" : "All Progress";
    String actor = (text == "Inbox") ? "Pesan" : "Prosess";

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
      child: ExpansionTile(
        trailing: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(50)),
            child: icon),
        leading: null,
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            deskripsi,
            style: TextStyle(color: Colors.blue.shade600),
          ),
        ),
        children: anak2,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("MENU"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      (data != null)
                          ? "${int.parse(data[0]["yan"]) + int.parse(data[0]["bar"]) + int.parse(data[0]["gan"])} $actor"
                          : "0 $actor",
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
