import 'package:flutter/material.dart';
import 'package:network_kominfo/model/users.dart';

typedef UserMenuFunc = void Function(String action);

class Header extends StatefulWidget {
  final UserMenuFunc menuFunc;
  final String ipIs;
  final Users _user;
  final bool hide;
  const Header(this._user,
      {Key? key, required this.ipIs, required this.menuFunc, this.hide = false})
      : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
        child: Row(
          children: [
            if (!widget.hide)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    widget.menuFunc("expand");
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.menu,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            const Spacer(),
            Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget._user.name!,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    PopupMenuButton(
                      offset: const Offset(0, 55),
                      itemBuilder: (context) {
                        var list = <PopupMenuEntry<Object>>[];
                        list.add(
                          const PopupMenuItem(
                            child: Text("User Menu"),
                            value: 1,
                          ),
                        );
                        list.add(
                          const PopupMenuDivider(
                            height: 10,
                          ),
                        );
                        list.add(
                          PopupMenuItem(
                            onTap: () {
                              widget.menuFunc("toSetting");
                            },
                            child: const ListTile(
                              leading: Icon(Icons.settings),
                              trailing: Text("Setting User",
                                  style: TextStyle(color: Colors.black)),
                            ),
                            value: 2,
                          ),
                        );

                        list.add(
                          PopupMenuItem(
                            onTap: () {
                              widget.menuFunc("Logout");
                            },
                            child: const ListTile(
                              leading: Icon(Icons.logout),
                              trailing: Text("Log Out",
                                  style: TextStyle(color: Colors.black)),
                            ),
                            value: 4,
                          ),
                        );
                        return list;
                      },
                      child: Hero(
                        tag: "DogTag",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: (widget._user.pp != null)
                              ? Image.network(
                                  "http://${widget.ipIs}/jaringan/conn/uploads/pp/${widget._user.pp}",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
