library flutter_vehicle_keyboard;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

part 'vehicle_field.dart';

/// 车牌键盘
class VehicleKeyboard extends StatefulWidget {
  TextEditingController controller;

  /// 车牌位数（含省份简称）
  final int vehicleLength;

  /// 输入一位省份后，自动切换到字母键盘
  final bool autoSwitchLetterKeyBoard;

  /// 输入完设定位数车牌后，自动隐藏键盘（默认位数为8位字母）
  final bool autoHideKeyBoard;

  final FocusNode focusNode;

  VehicleKeyboard(this.controller,
      {Key key,
      this.vehicleLength = 8,
      this.autoHideKeyBoard = false,
      this.autoSwitchLetterKeyBoard = true,
      this.focusNode})
      : super(key: key);

  @override
  State<VehicleKeyboard> createState() => _VehicleKeyboardState();
}

class _VehicleKeyboardState extends State<VehicleKeyboard> {
  bool showProviceKeyBoard = true;

  double keyWidth = 30;
  final double textSize = 20;

  List<List<String>> _provinceRowStrings = [
    ['京', '津', '渝', '沪', '冀', '晋', '辽', '吉', '黑', '苏'],
    ['浙', '皖', '闽', '赣', '鲁', '豫', '鄂', '湘', '粤', '琼'],
    ['川', '贵', '云', '陕', '甘', '青', '蒙', '桂', '宁', '新'],
  ];
  List<String> _provinceKeyBoardLastRowStrings = [
    '藏',
    '使',
    '领',
    '警',
    '学',
    '港',
    '澳',
  ];

  List<List<String>> _letterRowStrings = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ];
  List<String> _letterKeyBoardThirdRowStrings = [
    'A',
    'S',
    'D',
    'F',
    'G',
    'H',
    'J',
    'K',
    'L'
  ];
  List<String> _letterKeyBoardLastRowStrings = [
    'Z',
    'X',
    'C',
    'V',
    'B',
    'N',
    'M',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      color: Colors.white,
      child: Column(
        children: [
          _buildTopToolsBar(),
          showProviceKeyBoard
              ? _buildProvinceKeyBoard()
              : _buildLetterKeyBoard(),
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
          TextButton(
              onPressed: () {
                widget.focusNode?.unfocus();
              },
              child: Text("完成"))
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
            ..._provinceRowStrings.map((e) => _buildKeysRow(e)).toList(),
            _buildProvinceLastRow(),
          ]),
    );
  }

  Widget _buildKeysRow(List<String> keys) {
    return Container(
      height: 50,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ...keys.map((key) => _buildSignleKeyButton(key)).toList()
      ]),
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
        disabledColor: Colors.black12,
        textTheme: ButtonTextTheme.accent,
        textColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(5)),
        onPressed: name == 'I'
            ? null
            : () {
                _onKeyDown(new KeyDownEvent(name));
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
          Container(
              width: 55,
              child: RaisedButton(
                  onPressed: () =>
                      _onKeyDown(new KeyDownEvent(KeyDownEvent.KEYNAME_LETTER)),
                  child: Text("ABC"))),
          ..._provinceKeyBoardLastRowStrings
              .map((province) => _buildSignleKeyButton(province))
              .toList(),
          Container(
              width: 55,
              child: RaisedButton(
                  onPressed: () => _onKeyDown(
                      new KeyDownEvent(KeyDownEvent.KEYNAME_BACKSPACE)),
                  child: Icon(Icons.arrow_back_rounded))),
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
            ..._letterRowStrings.map((e) => _buildKeysRow(e)).toList(),
            _buildLetterThirdRow(),
            _buildLetterLastRow(),
          ]),
    );
  }

  /// 第三行字母
  Widget _buildLetterThirdRow() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      height: 50,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        ..._letterKeyBoardThirdRowStrings
            .map((province) => _buildSignleKeyButton(province))
            .toList()
      ]),
    );
  }

  /// 字母键盘最后一行
  Widget _buildLetterLastRow() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              width: 55,
              child: RaisedButton(
                  onPressed: () => _onKeyDown(
                      new KeyDownEvent(KeyDownEvent.KEYNAME_PROVINCE)),
                  child: Text("省份"))),
          ..._letterKeyBoardLastRowStrings
              .map((province) => _buildSignleKeyButton(province))
              .toList(),
          Container(
              width: 55,
              child: RaisedButton(
                  onPressed: () => _onKeyDown(
                      new KeyDownEvent(KeyDownEvent.KEYNAME_BACKSPACE)),
                  child: Icon(Icons.arrow_back_rounded))),
          // IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_rounded),),
        ],
      ),
    );
  }

  /// 键盘的整体回调，根据不同的按钮事件来进行相应的逻辑实现
  void _onKeyDown(KeyDownEvent data) {
    debugPrint("pressKey:" + data.key);

    if (data.isBackSpaceKey()) {
      if (widget.controller.text.length == 0) {
        /// 无内容处理
        return;
      }

      widget.controller.text = widget.controller.text
          .substring(0, widget.controller.text.length - 1);

      /// 保持光标
      lastCursor(textEditingController: widget.controller);

      if (widget.controller.text.length == 0) {
        /// 输入第一位时显示省份键盘
        setState(() {
          showProviceKeyBoard = true;
        });
      }
    } else if (data.isLetterKey()) {
      setState(() {
        showProviceKeyBoard = false;
      });
    } else if (data.isProvinceKey()) {
      setState(() {
        showProviceKeyBoard = true;
      });
    } else {
      if (widget.controller.text.length >= widget.vehicleLength) {
        return;
      }

      widget.controller.text += data.key;

      /// 保持光标
      lastCursor(textEditingController: widget.controller);
      if (widget.autoHideKeyBoard &&
          (widget.controller.text.length == widget.vehicleLength)) {
        // 隐藏键盘
        widget.focusNode?.unfocus();
        return;
      }

      /// 输入完省份，切换到字母键盘
      if (data.key.contains(new RegExp(r'[\u4e00-\u9fa5]')) &&
          widget.autoSwitchLetterKeyBoard) {
        setState(() {
          showProviceKeyBoard = false;
        });
      }
    }
  }

  lastCursor({@required TextEditingController textEditingController}) {
    /// 保持光标在最后
    final length = textEditingController.text.length;
    textEditingController.selection =
        TextSelection(baseOffset: length, extentOffset: length);
  }

  delCursor({@required TextEditingController textEditingController}) {
    if (textEditingController != null && textEditingController.value.text != "")
      textEditingController.text = textEditingController.text
          .substring(0, textEditingController.text.length - 1);
  }
}

/// 点击事件
class KeyDownEvent {
  static const KEYNAME_BACKSPACE = 'backspace';
  static const KEYNAME_CLOSE = 'close';
  static const KEYNAME_CONFIRM = 'confirm';
  static const KEYNAME_PROVINCE = 'province';
  static const KEYNAME_LETTER = 'letter';

  //当前点击的按钮所代表的值
  String key;

  KeyDownEvent(this.key);

  bool isBackSpaceKey() => this.key == KEYNAME_BACKSPACE;

  bool isProvinceKey() => this.key == KEYNAME_PROVINCE;

  bool isCloseKey() => this.key == KEYNAME_CLOSE;

  bool isConfirmKey() => this.key == KEYNAME_CONFIRM;

  bool isLetterKey() => this.key == KEYNAME_LETTER;
}

class FlutterVehicleKeyboard {
  /// 显示键盘
  static bool showKeyboard(
      {BuildContext context, TextEditingController controller}) {
    showModalBottomSheet(
        context: context,
        elevation: 0.0,
        builder: (BuildContext context) {
          return VehicleKeyboard(controller);
        });
    return true;
  }
}
