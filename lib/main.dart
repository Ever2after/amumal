import 'package:flutter/material.dart';
import 'home.dart';
import 'setting1.dart';
import 'setting2.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '오늘의 아무말',
      initialRoute: '/',
      routes: {
        '/' : (context) => Home(),
        '/setting1' : (context) => Setting1(),
        '/setting2' : (context) => Setting2(),
      },
      theme: ThemeData(

      ),
    );
  }
}