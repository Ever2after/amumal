import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading.dart';
import 'first.dart';
import 'notFirst.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String pageState = 'default';

  Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isFirstTime = prefs.getBool('first_time');
    if (isFirstTime != null && !isFirstTime) {  // 처음이 아닐때
      prefs.setBool('first_time', false);
      return false;
    } else {      // 처음일때
      prefs.setBool('first_time', false);
      return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<bool>(
      future: isFirstTime(),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
            if(snapshot.hasData){
              if(snapshot.data){    // 처음실행
                return First();
              }
              else {
                return NotFirst();
              }
            }
            else {
              return Center(
                child: Loading(),
              );
            }
      },
    );
  }
}





