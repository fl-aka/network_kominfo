import 'package:flutter/material.dart';
import 'package:network_kominfo/pages/baru/newaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Layanan Jaringan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NewAct(),
    );
  }
}
