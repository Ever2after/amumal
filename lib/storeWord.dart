import 'package:flutter/material.dart';
import 'db_memo.dart';
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
      theme: ThemeData(
        fontFamily: 'RidiBatang',
      ),
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
                      fontSize: 22,
                    ),)
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
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
                                alignment: Alignment.centerLeft,
                                child: Text("${item.author}, <${item.title}>", style: TextStyle(
                                  fontSize: 18,
                                ),)
                              ),
                              secondaryBackground: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.delete),
                              ),
                              confirmDismiss: (DismissDirection direction) async {
                                if(direction == DismissDirection.endToStart){
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm"),
                                        content: const Text(
                                            "정말 문장을 삭제하시겠습니까?"),
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
                                }
                                else return false;
                              },
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                print(direction);
                                deleteMemo(item.id);
                                //setState(() {});
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("'${item.author}, <${item.title}>' 이 삭제되었습니다.")));
                              },
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.all(0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(24))
                                        ),
                                        content: Stack(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.all(width * 0.1),
                                              height: height * 0.6,
                                              width: width * 0.85,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.circular(24),
                                                image: DecorationImage(
                                                    image:
                                                    AssetImage(item.image),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(width * 0.1),
                                              height: height * 0.6,
                                              width: width * 0.85,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(24),
                                                  color: Colors.white,
                                                  gradient: LinearGradient(
                                                      begin: FractionalOffset.topCenter,
                                                      end: FractionalOffset.bottomCenter,
                                                      colors: [
                                                        Colors.black.withOpacity(0.2),
                                                        Colors.black.withOpacity(0.4),
                                                        Colors.black.withOpacity(0.4),
                                                        Colors.black.withOpacity(0.2),
                                                      ],
                                                      stops: [
                                                        0,
                                                        0.2,
                                                        0.9,
                                                        1
                                                      ])),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(width * 0.1),
                                              height: height * 0.6,
                                              width: width * 0.85,
                                              alignment: Alignment.bottomCenter,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  SingleChildScrollView(
                                                    child: Text(
                                                      item.text,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                          height: 1.5,
                                                          fontWeight: FontWeight.w200),
                                                    ),
                                                  ),
                                                  Container(
                                                      width: width*0.85,
                                                      child: Text(
                                                        '\n${item.author}, <${item.title}>',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            height: 1.5,
                                                            fontWeight: FontWeight.w200),
                                                        textAlign: TextAlign.right,
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: height*0.01,
                                              right: width * 0.01,
                                              child: IconButton(
                                                icon: Icon(Icons.close, color: Colors.white,),
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            )
                                          ],
                                        )
                                      );
                                    }
                                  );
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(width * 0.05,
                                              height * 0.01, width * 0.05, height * 0.01),
                                          padding: EdgeInsets.fromLTRB(width*0.07, height*0.02, width*0.07, height*0.02),
                                          width: width * 0.9,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              item.text,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 15, color: Colors.white),
                                            ),
                                          ),
                                          Text(
                                            "${item.author}, <${item.title}>",
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          )
                                        ],
                                      ),
                                          decoration: BoxDecoration(
                                            boxShadow:  [BoxShadow(
                                                color: Color.fromRGBO(111, 207, 151, 0.25),
                                                offset: Offset(0,4),
                                                blurRadius: 4
                                            )],
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(
                                                image: AssetImage(item.image),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(width * 0.05,
                                          height * 0.01, width * 0.05, height * 0.01),
                                      padding: EdgeInsets.fromLTRB(width*0.07, height*0.02, width*0.07, height*0.02),
                                      width: width * 0.9,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              item.text,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 15, color: Colors.white),
                                            ),
                                          ),
                                          Text(
                                            "${item.author}, <${item.title}>",
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          )
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24),
                                          color: Colors.white,
                                          gradient: LinearGradient(
                                              begin: FractionalOffset.topCenter,
                                              end: FractionalOffset.bottomCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.2),
                                                Colors.black.withOpacity(0.4),
                                                Colors.black.withOpacity(0.4),
                                                Colors.black.withOpacity(0.2),
                                              ],
                                              stops: [
                                                0,
                                                0.2,
                                                0.9,
                                                1
                                              ])),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(width * 0.05,
                                          height * 0.01, width * 0.05, height * 0.01),
                                      padding: EdgeInsets.fromLTRB(width*0.07, height*0.02, width*0.07, height*0.02),
                                      width: width * 0.9,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              item.text,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 15, color: Colors.white),
                                            ),
                                          ),
                                          Text(
                                            "${item.author}, <${item.title}>",
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          );
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
