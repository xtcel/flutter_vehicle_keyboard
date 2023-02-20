library flutter_vehicle_keyboard;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

part 'vehicle_field.dart';

/// 车牌键盘
class VehicleKeyboard extends StatefulWidget {
  TextEditingController controller;

   VehicleKeyboard(this.controller, {Key key}) : super(key: key);

  @override
  State<VehicleKeyboard> createState() => _VehicleKeyboardState();
}

class _VehicleKeyboardState extends State<VehicleKeyboard> {
  double keyWidth = 30;
  final double textSize = 20;

  List<List<String>> _provinceRowStrings = [
    ['京', '津', '渝', '沪', '冀', '晋', '辽', '吉', '黑', '苏'],
    ['浙', '皖', '闽', '赣', '鲁', '豫', '鄂', '湘', '粤', '琼'],
    ['川', '贵', '云', '陕', '甘', '青', '蒙', '桂', '宁', '新'],
  ];
  List<String> _provinceKeyBoardLastRowStrings = ['藏', '使', '领', '警', '学', '港', '澳', ];

  List<List<String>> _letterRowStrings = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ];
  List<String> _letterKeyBoardThirdRowStrings = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
  List<String> _letterKeyBoardLastRowStrings = ['Z', 'X', 'C', 'V', 'B', 'N', 'M', ];

  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: 280,
        color: Colors.white,
        child: Column(
        children: [
          _buildTopToolsBar(),
          // _buildProvinceKeyBoard(),
          _buildLetterKeyBoard(),
        ],
    ),
      );
  }

  /// 顶部工具栏
  Widget _buildTopToolsBar() {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: () {

          }, child: Text("完成"))
        ],
      ),
    );
  }

  /// 省简称
  Widget _buildProvinceKeyBoard() {
    return Container(
      height: 210,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ... _provinceRowStrings.map((e) => _buildProvinceRow(e)).toList(),
            _buildProvinceLastRow(),
          ]
      ),
    );
  }

  Widget _buildProvinceRow(List<String> provinces) {
    return Container(
      height: 50,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            ... provinces.map((province) => _buildSignleKeyButton(province)).toList()
          ]
      ),
    );
  }

  Widget _buildSignleKeyButton(String name) {
    return Container(
      width: keyWidth,
      child: RaisedButton(
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: textSize, color: Colors.black),
        ),
        color: Colors.white,
        textTheme: ButtonTextTheme.accent,
        textColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(5)),
        onPressed: () {
          _onKeyDown(new KeyDownEvent(name));
          // widget.callback(new KeyDownEvent(name));
          // widget.controller.text += name;
        },
      ),
    );
  }

  /// 省键盘最后一行（切换/藏使领警学港澳/回删）
  Widget _buildProvinceLastRow() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(width: 55, child: RaisedButton(onPressed: () {}, child: Text("ABC"))),
          ... _provinceKeyBoardLastRowStrings.map((province) => _buildSignleKeyButton(province)).toList(),
          Container(width: 55, child: RaisedButton(onPressed: () {}, child: Icon(Icons.arrow_back_rounded))),
          // IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_rounded),),
        ],
      ),
    );
  }

  /// 字母+数字键盘
  Widget _buildLetterKeyBoard() {
    return Container(
      height: 210,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ... _letterRowStrings.map((e) => _buildProvinceRow(e)).toList(),
            _buildLetterThirdRow(),
            _buildLetterLastRow(),
          ]
      ),
    );
  }

  /// 第三行字母
  Widget _buildLetterThirdRow() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      height: 50,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            ... _letterKeyBoardThirdRowStrings.map((province) => _buildSignleKeyButton(province)).toList()
          ]
      ),
    );
  }

  /// 字母键盘最后一行
  Widget _buildLetterLastRow() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(width: 55, child: RaisedButton(onPressed: () {}, child: Text("省份"))),
          ... _letterKeyBoardLastRowStrings.map((province) => _buildSignleKeyButton(province)).toList(),
          Container(width: 55, child: RaisedButton(onPressed: () {}, child: Icon(Icons.arrow_back_rounded))),
          // IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_rounded),),
        ],
      ),
    );
  }

    /// 键盘的整体回调，根据不同的按钮事件来进行相应的逻辑实现
  void _onKeyDown(KeyDownEvent data) {
    debugPrint("pressKey:" + data.key);

    if (data.isDelete()) {
      widget.controller.text =
          widget.controller.text.substring(0, widget.controller.text.length - 1);
      // switchContent(widget.controller);
    } else if (data.isMore()) {
      // setState(() {
      //   height = maxHeight;
      //   isFirst = false;
      // });

    } else if (data.isProvince()) {
      // setState(() {
      //   isFirst = true;
      //   height = minHeight;
      // });
    } else {
      widget.controller.text += data.key;
      /// 保持光标
      lastCursor(textEditingController: widget.controller);
      // switchContent(widget.controller);
    }
  }

  lastCursor({@required TextEditingController textEditingController}){
    /// 保持光标在最后
    final length = textEditingController.text.length;
    textEditingController.selection = TextSelection(baseOffset:length , extentOffset:length);
  }

  delCursor({@required TextEditingController textEditingController}){
    if(textEditingController != null && textEditingController.value.text != "")
      textEditingController.text = textEditingController.text.substring(0,textEditingController.text.length - 1);
  }
}

/// 点击事件
class KeyDownEvent {
  //当前点击的按钮所代表的值
  String key;

  KeyDownEvent(this.key);

  bool isDelete() => this.key == "del";

  bool isMore() => this.key == "more";

  bool isProvince() => this.key == "province";

  bool isClose() => this.key == "close";

  bool isCommit() => this.key == "commit";
}


class FlutterVehicleKeyboard {
  /// 显示键盘
  static bool showKeyboard({ BuildContext context, TextEditingController controller}) {
    showModalBottomSheet(
        context: context,
        elevation: 0.0,
        builder: (BuildContext context) {
          return VehicleKeyboard(controller);
        });
    return true;
  }
}
