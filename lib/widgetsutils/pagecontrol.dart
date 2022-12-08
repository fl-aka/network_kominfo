import 'package:flutter/material.dart';

typedef HalamanBaru = void Function(int i);

class PageControl extends StatelessWidget {
  final HalamanBaru newPage;
  final int maxPage;
  const PageControl(
    this.maxPage, {
    Key? key,
    required this.newPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 1; i <= maxPage; i++)
            GestureDetector(
              onTap: () {
                newPage(i);
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 17, right: 17, top: 13, bottom: 13),
                margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: AlignmentDirectional.topStart,
                        colors: [Colors.blueAccent.shade200, Colors.amber])),
                child: Text(i.toString(),
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}
