part of flutter_vehicle_keyboard;

class VehicleField extends StatefulWidget {
  /// 车牌位数（含省份简称）
  final int vehicleLength;

  /// 输入一位省份后，自动切换到字母键盘
  final bool autoSwitchLetterKeyBoard;

  /// 输入完设定位数车牌后，自动隐藏键盘（默认位数为8位字母）
  final bool autoHideKeyBoard;

  /// 显示键盘
  bool showKeyBoard;

  final FocusNode focusNode;

  VehicleField(
      {Key key,
      this.vehicleLength = 8,
      this.autoHideKeyBoard = false,
      this.autoSwitchLetterKeyBoard = true,
      this.showKeyBoard,
      this.focusNode})
      : super(key: key);

  @override
  State<VehicleField> createState() => _VehicleFieldState();
}

class _VehicleFieldState extends State<VehicleField> {
  FocusNode _focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode;
    }

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
        widget.showKeyBoard = true;
      } else {
        this._overlayEntry.remove();
        widget.showKeyBoard = false;
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    // var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              left: 0,
              bottom: 0,
              width: size.width,
              child: Material(
                  elevation: 4.0,
                  child: VehicleKeyboard(
                    controller,
                    focusNode: _focusNode,
                    vehicleLength: widget.vehicleLength,
                    autoHideKeyBoard: widget.autoHideKeyBoard,
                    autoSwitchLetterKeyBoard: widget.autoSwitchLetterKeyBoard,
                  )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: this._focusNode,
      controller: controller,
      showCursor: true,
      readOnly: true,
      decoration: InputDecoration(labelText: '请输入车牌'),
    );
  }
}

class NoKeyboardEditableText extends EditableText {
  NoKeyboardEditableText(
      {@required TextEditingController controller,
      TextStyle style = const TextStyle(),
      Color cursorColor = Colors.black,
      bool autofocus = false,
      Color selectionColor})
      : super(
            controller: controller,
            focusNode: NoKeyboardEditableTextFocusNode(),
            style: style,
            cursorColor: cursorColor,
            autofocus: autofocus,
            selectionColor: selectionColor,
            backgroundCursorColor: Colors.black);

  @override
  EditableTextState createState() {
    return NoKeyboardEditableTextState();
  }
}

class NoKeyboardEditableTextState extends EditableTextState {
  @override
  Widget build(BuildContext context) {
    Widget widget = super.build(context);
    return Container(
      decoration:
          UnderlineTabIndicator(borderSide: BorderSide(color: Colors.blueGrey)),
      child: widget,
    );
  }

  @override
  void requestKeyboard() {
    super.requestKeyboard();
    //hide keyboard
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}

class NoKeyboardEditableTextFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    // prevents keyboard from showing on first focus
    return false;
  }
}