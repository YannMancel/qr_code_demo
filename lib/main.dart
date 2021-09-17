import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const kTitle = 'QR Code Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(title: kTitle),
    );
  }
}
