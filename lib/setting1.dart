import 'package:flutter/material.dart';

class Setting1 extends StatefulWidget {
  @override
  _Setting1State createState() => _Setting1State();
}

class _Setting1State extends State<Setting1> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('내용 작성...'),
        ),
      ),
    );
  }
}
