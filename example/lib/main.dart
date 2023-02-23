import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_vehicle_keyboard/flutter_vehicle_keyboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  /// 键盘的整体回调，根据不同的按钮事件来进行相应的逻辑实现
  // void _onKeyDown(KeyDownEvent data) {
  //   debugPrint("keyEvent:" + data.key);
  //
  //   if (data.isClose() || data.isCommit()) {
  //     setState(() {
  //       showKeyboard = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome());
  }
}

class MyHome extends StatelessWidget {
  bool showKeyboard = true;

  TextEditingController controller = new TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('仿12123车牌输入键盘'),
      ),
      body: new Center(
          child: Column(
        children: <Widget>[
          VehicleField(
            focusNode: focusNode,
            autoSwitchLetterKeyBoard: true,
          ),
          RaisedButton(
            child: Text("隐藏/显示"),
            onPressed: () {
              showKeyboard = !showKeyboard;
              if (showKeyboard) {
                focusNode.requestFocus();
              } else {
                focusNode.unfocus();
              }
              // setState(() {
              //   showKeyboard = !showKeyboard;
              // });
            },
          )
        ],
      )),
    );
  }
}
