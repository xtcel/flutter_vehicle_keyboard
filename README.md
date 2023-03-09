# flutter_vehicle_keyboard

Flutter Vehicle Keyboard

#### 仿交管12123车牌键盘
* 支持自动切换省份简称和字母键盘
* 支持输入完成自动关闭键盘
* 支持设置车牌长度
* 过滤字母“I”
  
## 开始使用

### 添加依赖
你可以使用一下命令将 flutter_vehicle_keyboard 的最新稳定版依赖添加至你的项目：
```
dependencies:
  flutter_vehicle_keyboard: ^replace-with-latest-version
```
使用示例：
```
import 'package:flutter_vehicle_keyboard/flutter_vehicle_keyboard.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String vehicleNumber = "";
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
          // VehicleField(
          //   focusNode: focusNode,
          //   autoSwitchLetterKeyBoard: true,
          //   controller: controller,
          // ),
          Container(
            padding: const EdgeInsets.all(10),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('车牌号码：'),
                Expanded(
                  child: VehicleField(
                    focusNode: focusNode,
                    autoSwitchLetterKeyBoard: true,
                    controller: controller,
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("隐藏/显示"),
                onPressed: () {
                  showKeyboard = !showKeyboard;
                  if (showKeyboard) {
                    focusNode.requestFocus();
                  } else {
                    focusNode.unfocus();
                  }
                },
              ),
              SizedBox(
                width: 10,
              ),
              RaisedButton(
                child: Text("获取车牌号"),
                onPressed: () {
                  vehicleNumber = controller.text;
                  setState(() {});
                },
              ),
            ],
          ),
          Text(vehicleNumber),
        ],
      )),
    );
  }
}

```
