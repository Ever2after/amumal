import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';
import 'db_helper.dart';
import 'models/memo.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

final List<String> textSet = [
  '안녕하세요',
  '반갑습니다',
  '그렇고말고요',
  '암요 그렇죠',
  '아 ㅋㅋㅋㅋㅋ',
  '의미 없는 문장',
  '완전 랜덤한 문장',
  '으아아아아아아',
  '그와악 구와악',
];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _text = '안녕하세요';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return MaterialApp(
      title: '오늘의 아무말',
      home: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: height*0.1,
                  child: DrawerHeader(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: (){
                            _scaffoldKey.currentState.openDrawer();
                          }
                        ),
                        Text('설정', style: TextStyle(fontSize: 20),)
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.library_books),
                  title: Text('관심사 설정', style: TextStyle(fontSize: 20),),
                  onTap: () {
                    Navigator.pushNamed(context, '/setSubject');
                  }
                ),
                ListTile(
                  leading: Icon(Icons.timer),
                  title: Text('알림 시간 설정', style: TextStyle(fontSize: 20),),
                  onTap: (){
                    Navigator.pushNamed(context, '/setTimer');
                  },
                )
              ],
            ),
          ),
          body: Container(
              margin: EdgeInsets.fromLTRB(0, height * 0.05, 0, height * 0.05),
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.fromLTRB(width * 0.075, 0, width * 0.075, 0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            '오늘의 \n    아무말',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(height: height * 0.1),
                        ),
                        IconButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/storeWord');
                          },
                          icon: Icon(Icons.bookmark, size: height * 0.04),
                        ),
                        IconButton(
                          onPressed: (){
                            _scaffoldKey.currentState.openEndDrawer();
                          },
                            icon: Icon(
                              Icons.menu,
                              size: height * 0.04,
                        ))
                      ],
                    ),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                        height: height * 0.6,
                        viewportFraction: 1,
                        reverse: false,
                        onPageChanged: (index, reason) {
                          var rng = new Random();
                          this.setState(() {
                            _text = textSet[rng.nextInt(9)];
                          });
                        }),
                    items: [1, 2, 3, 4, 5].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(
                                0, height * 0.05, 0, height * 0.05),
                            padding: EdgeInsets.all(width * 0.2),
                            height: height * 0.5,
                            width: width * 0.85,
                            alignment: Alignment.center,
                            child: Text(
                              _text,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              image: DecorationImage(
                                  image: AssetImage('images/background3.jpg'),
                                  fit: BoxFit.cover),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/setting1');
                        },
                        child: Text('Setting1'),
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.pushNamed(context, '/setting2');
                        },
                        child: Text('Setting2'),
                      ),
                      FlatButton(
                        onPressed: (){
                          saveDB();
                          setState((){});
                        },
                        child: Icon(Icons.add),
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Future<void> saveDB() async{
    DBHelper sd = DBHelper();

    var fido = Memo(
      id : Str2Sha512(DateTime.now().toString()),
      title : _text,
      text : _text,
      createTime : DateTime.now().toString(),
      editTime : DateTime.now().toString(),
    );

    await sd.insertMemo(fido);
  }

  String Str2Sha512(String text) {
    var bytes = utf8.encode(text); // data being hashed
    var digest = sha512.convert(bytes);
    return digest.toString();
  }
}


