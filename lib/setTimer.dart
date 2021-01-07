import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';
import 'models/alarm.dart';
import 'db_alarm.dart';
import 'package:crypto/crypto.dart';
import 'HomeScreen.dart';

class SetTimer extends StatefulWidget {
  SetTimer({Key key}) : super(key: key);
  

  @override
  _SetTimerState createState() => _SetTimerState();
}

class _SetTimerState extends State<SetTimer> {
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(47, 128, 237, 1),
          onPressed: (){
            showPickerArray(context);
          },
          child: Icon(Icons.add),

        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Container(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(width*0.03, height*0.01, width*0.05, height*0.01),
                child: Row(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.arrow_back),
                      onPressed: (){
                        Navigator.pop(context);
                      },),
                    Text('알람 시간 설정', style: TextStyle(
                      fontSize: 22,
                    ),)
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: loadAlarm(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Alarm item = snapshot.data[index];
                          return Dismissible(
                              background: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.delete),
                              ),
                              secondaryBackground: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.delete),
                              ),
                              confirmDismiss: (DismissDirection direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirm"),
                                      content: const Text(
                                          "정말 알람을 삭제하시겠습니까?"),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text("삭제")),
                                        FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("취소"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                _flutterLocalNotificationsPlugin.cancel(int.parse(item.alarmId));
                                deleteAlarm(item.id);
                                //setState(() {});
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("${item.hour}시 ${item.min}분 알람이 삭제되었습니다.")));
                              },
                               child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(width * 0.05,
                                     height * 0.01, width * 0.05, height * 0.01),
                                    padding: EdgeInsets.only(left:width*0.07),
                                    width: width,
                                    height: height * 0.1,
                                    child: Text(
                                      "${int.parse(item.hour)>12 ?
                                      (int.parse(item.hour)-12>9 ? int.parse(item.hour)-12 : '0${(int.parse(item.hour)-12).toString()}')
                                          : item.hour}:${item.min} ${int.parse(item.hour)>11 ? 'PM' : 'AM'}",
                                      style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w400),
                                    ),
                                    decoration: BoxDecoration(
                                      boxShadow:  [BoxShadow(
                                          color: Color.fromRGBO(111, 207, 151, 0.25),
                                          offset: Offset(0,4),
                                          blurRadius: 4
                                      )],
                                      color: Color.fromRGBO(47, 128, 237, 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ));
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  showPickerArray(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(TimeData), isArray: true),
        hideHeader: true,
        title: new Text("알림시각선택 (시간/분)"),
        confirmText: '설정',
        cancelText: '취소',
        onConfirm: (Picker picker, List value) {
          var _currId = Str2Int(DateTime.now().toString());  // 알람의 id
          var _hour = int.parse(picker.getSelectedValues()[0]);
          var _min = int.parse(picker.getSelectedValues()[1]);

          // db 에 알람정보 저장
          saveDB(picker.getSelectedValues()[0], picker.getSelectedValues()[1], _currId.toString()); // string
          // 알람 설정
          _dailyAtTimeNotification(_currId, _hour, _min);  // int
          setState((){});
        }
    ).showDialog(context);
  }


  Future<void> _dailyAtTimeNotification(_id, _hour, _min) async {
    print(_hour);
    print(_min);
    var time = Time(_hour, _min, 0);
    var android = AndroidNotificationDetails(
        'amumal', '오늘의 아무말', 'description',
        importance: Importance.max, priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),

    );

    var ios = IOSNotificationDetails();
    var detail = NotificationDetails(android: android, iOS: ios);

    var arr = func1();
    var author = arr[1];
    var title = arr[2];
    var text = arr[0];


    await _flutterLocalNotificationsPlugin.showDailyAtTime(
      _id,
      '$author, <$title>',   // author, <title>
      text,  // text
      time,
      detail,
      payload: '오늘의 한문장',   // ???
    );
  }

  Future<void> saveDB(_hour, _min, _currId) async{
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

  int Str2Int(String text){
    var bytes = utf8.encode(text);
    var _int = 5*bytes[25]+2*bytes[24]+bytes[23]+5*bytes[2]+2*bytes[4];
    return _int;
  }

  Future<List<Alarm>> loadAlarm() async {
    DBHelper sd = DBHelper();
    return await sd.alarms();
  }

  Future<void> deleteAlarm(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteAlarm(id);
  }

  final TimeData = '''
    [
        [
            "00",
            "01",
            "02",
            "03",
            "04",
            "05",
            "06",
            "07",
            "08",
            "09",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "16",
            "17",
            "18",
            "19",
            "20",
            "21",
            "22",
            "23"
        ],
        [
            "00",
            "01",
            "02",
            "03",
            "04",
            "05",
            "06",
            "07",
            "08",
            "09",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "16",
            "17",
            "18",
            "19",
            "20",
            "21",
            "22",
            "23",
            "24",
            "25",
            "26",
            "27",
            "28",
            "29",
            "30",
            "31",
            "32",
            "33",
            "34",
            "35",
            "36",
            "37",
            "38",
            "39",
            "40",
            "41",
            "42",
            "43",
            "44",
            "45",
            "46",
            "47",
            "48",
            "49",
            "50",
            "51",
            "52",
            "53",
            "54",
            "55",
            "56",
            "57",
            "58",
            "59"
        ]
    ]
        ''';
}