part of flutter_vehicle_keyboard;

class VehicleField extends StatefulWidget {
  const VehicleField({Key key}) : super(key: key);

  @override
  State<VehicleField> createState() => _VehicleFieldState();
}

class _VehicleFieldState extends State<VehicleField> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {

        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);

      } else {
        this._overlayEntry.remove();
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
            child:
            VehicleKeyboard(controller)
            // ListView(
            //   padding: EdgeInsets.zero,
            //   shrinkWrap: true,
            //   children: <Widget>[
            //     ListTile(
            //       title: Text('Syria'),
            //     ),
            //     ListTile(
            //       title: Text('Lebanon'),
            //     )
            //   ],
            // ),
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: this._focusNode,
      controller: controller,
      // showCursor: true,
      // readOnly: true,
      decoration: InputDecoration(
          labelText: '请输入车牌'
      ),
    );
  }
}

class NoKeyboardEditableText extends EditableText {

  NoKeyboardEditableText({
    @required TextEditingController controller,
    TextStyle style = const TextStyle(),
    Color cursorColor = Colors.black,
    bool autofocus = false,
    Color selectionColor
  }):super(
      controller: controller,
      focusNode: NoKeyboardEditableTextFocusNode(),
      style: style,
      cursorColor: cursorColor,
      autofocus: autofocus,
      selectionColor: selectionColor,
      backgroundCursorColor: Colors.black
  );

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
      decoration: UnderlineTabIndicator(borderSide: BorderSide(color: Colors.blueGrey)),
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
