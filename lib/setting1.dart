import 'package:flutter/material.dart';
import 'main.dart';
import 'setting2.dart';

class Setting1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Setting1Screen(),
      routes: {
        '/setting1' : (context) => Setting1(),
        '/setting2' : (context) => Setting2(),
      },
    );
  }
}


class Setting1Screen extends StatefulWidget {
  @override
  _Setting1ScreenState createState() => _Setting1ScreenState();
}

class _Setting1ScreenState extends State<Setting1Screen> {
  List<bool> alarmState = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<String> subjects = [
    '테마1',
    '테마2',
    '테마3',
    '테마4',
    '테마5',
    '테마6'
  ];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(width*0.05, height*0.07, width*0.05, height*0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: width*0.02),
                    child: Text(
                      "관심있는 분야를\n선택해주세요",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: width*0.02, top: height*0.01, bottom: height*0.01),
                    child: Text(
                      "나중에 설정에서 변경할 수 있어요!\n",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    height: height*0.7,
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: width * 0.05,   // 가로 간격
                        mainAxisSpacing: height * 0.02,     // 세로 간격
                        childAspectRatio: 1,
                      ),
                      itemCount: subjects.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, int index) {
                        return FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: (){
                            setState(() {
                              alarmState[index] = !alarmState[index];
                            });
                          },
                          child: Container(
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.all(width*0.02),  // 글씨 패딩
                            height: height * 0.5,
                            width: width * 0.5,
                            child: Text(
                              subjects[index],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Color.fromRGBO(111, 207, 151, 0.25),
                                    offset: Offset(0,4),
                                    blurRadius: 4
                                )
                              ],
                              image: DecorationImage(
                                  colorFilter: ColorFilter.mode(Colors.orange.withOpacity(alarmState[index] ? 0.4 : 1), BlendMode.dstATop),
                                  image: AssetImage('images/background17.jpg'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(width*0.3, height*0.03, width*0.3, 0),
                    height: height*0.06,
                    child: FlatButton(
                      color: Colors.greenAccent,
                      child: Text('선택완료', style: TextStyle(
                        fontSize: 18,
                      ),),
                      onPressed: (){
                        Navigator.pushNamed(context, '/setting2');
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}