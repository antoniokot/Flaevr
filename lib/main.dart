import 'package:flutter/material.dart';
import 'pages/loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Color(0xff3d3d4e)),
      home: LoadingPage(),
    );
  }
}
