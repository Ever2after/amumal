import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';

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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
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
                        icon: Icon(Icons.bookmark, size: height * 0.04),
                      ),
                      IconButton(
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
                                image: AssetImage('images/example.jpg'),
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
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
