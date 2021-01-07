import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'setting1.dart';
import 'setting2.dart';
import 'setSubject.dart';
import 'setTimer.dart';
import 'storeWord.dart';

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
        '/setSubject' : (context) => SetSubject(),
        '/setTimer' : (context) => SetTimer(),
        '/storeWord' : (context) => StoreWord()
      },
      theme: ThemeData(
        fontFamily: 'RidiBatang'
      ),
    );
  }
}
