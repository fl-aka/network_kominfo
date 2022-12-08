import 'package:flutter/material.dart';

class Waiter extends StatelessWidget {
  const Waiter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "On Progress",
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
