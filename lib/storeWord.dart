import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'models/memo.dart';
import 'dart:math';

class StoreWord extends StatefulWidget {
  @override
  _StoreWordState createState() => _StoreWordState();
}

class _StoreWordState extends State<StoreWord> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(width*0.03, height*0.01, width*0.05, height*0.01),
                child: Row(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.arrow_back),
                    onPressed: (){
                      Navigator.pop(context);
                    },),
                    Text('내가 저장한 아무말', style: TextStyle(
                      fontSize: 18,
                    ),)
                  ],
                ),
              ),
              FutureBuilder(
                future: loadMemo(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Memo item = snapshot.data[index];
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
                                        "Are you sure you wish to delete this item?"),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text("DELETE")),
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("CANCEL"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              print(direction);
                              deleteMemo(item.id);
                              //setState(() {});
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("'${item.title}' 이 삭제되었습니다.")));
                            },
                            child: Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(width * 0.05,
                                      height * 0.01, width * 0.05, height * 0.01),
                                  width: width * 0.9,
                                  height: height * 0.1,
                                  child: Text(
                                    item.title,
                                    style: TextStyle(fontSize: 15, color: Colors.white),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                        image: AssetImage('images/background2.jpg'),
                                        fit: BoxFit.cover),
                                  ),
                                )));
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          )
        ),
      ),
    );
  }

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();
    return await sd.memos();
  }

  Future<void> deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id);
  }
}
