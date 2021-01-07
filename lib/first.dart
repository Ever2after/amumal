import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'dart:convert';
import 'models/alarm.dart';
import 'db_alarm.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  String pageState = 'setting';
  List<bool> alarmState = [
    false,
    false,
    false,
    false
  ];
  List<String> subjects = [
    '아침',
    '점심',
    '저녁',
    '밤'
  ];
  var _flutterLocalNotificationsPlugin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  // 알림을 눌렀을때 행해지는 행동 정의
  Future<void> onSelectNotification(String payload) async {
    debugPrint("$payload");
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Notification Payload'),
          content: Text('Payload: $payload'),
        ));
  }
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if(pageState=='setting') return SafeArea(
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
                    "알림을 받으실 시간대를\n선택해주세요",
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
                  height: height*0.5,
                  child: GridView.builder(
                    physics: ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: width * 0.05,   // 가로 간격
                      mainAxisSpacing: height * 0.02,     // 세로 간격
                      childAspectRatio: 1,
                    ),
                    itemCount: 4,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, int index) {
                      return FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: (){
                          setState(() {
                            alarmState[index] = !alarmState[index];
                            print(index);
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
                                image: AssetImage('images/alarm${index+1}.jpg'),
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
                    color: Colors.blue,
                    child: Text('선택완료', style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),),
                    onPressed: (){
                      // implement alarm setting
                      // id, hour, min
                      if(alarmState[0]){  // 아침
                        saveDB('0', '09', '00');
                        _dailyAtTimeNotification(0, 9, 0);
                      }
                      if(alarmState[1]){  // 점심
                        saveDB('1', '12', '30');
                        _dailyAtTimeNotification(0, 12, 30);
                      }
                      if(alarmState[2]){  // 저녁
                        saveDB('2', '18', '00');
                        _dailyAtTimeNotification(2, 18, 00);
                      }
                      if(alarmState[3]) { // 밤
                        saveDB('3', '21', '30');
                        _dailyAtTimeNotification(3, 21, 30);
                      }
                      setState(() {
                        pageState = 'default';
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    else return HomeScreen();
  }


  Future<void> _dailyAtTimeNotification(_id, _hour, _min) async {
    var time = Time(_hour, _min, 0);
    var android = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high);

    var ios = IOSNotificationDetails();
    var detail = NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.showDailyAtTime(
      _id,
      _id.toString(),
      '$_hour 시 $_min 분 알람입니다.',
      time,
      detail,
      payload: 'Hello Flutter',
    );
  }

  Future<void> saveDB(_currId, _hour, _min) async{
    DBHelper sd = DBHelper();

    var fido = Alarm(
      id : Str2Sha512(DateTime.now().toString()),
      hour : _hour,
      min : _min,
      alarmId : _currId,
      createTime : DateTime.now().toString(),
      editTime : DateTime.now().toString(),
    );

    await sd.insertAlarm(fido);
  }

  String Str2Sha512(String text) {
    var bytes = utf8.encode(text); // data being hashed
    var digest = sha512.convert(bytes);
    return digest.toString();
  }

}
