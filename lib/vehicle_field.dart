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

  /// focus node
  final FocusNode? focusNode;

  /// text editing controller
  final TextEditingController? controller;

  /// TextFieldProps
  final TextAlign? textAlign;

  /// 字体样式
  final TextStyle? textStyle;

  /// 是否可用
  final bool enabled;

  final InputDecoration? inputDecoration;

  final ValueChanged<String>? onChanged;

  VehicleField({
    Key? key,
    this.controller,
    this.vehicleLength = 8,
    this.autoHideKeyBoard = false,
    this.autoSwitchLetterKeyBoard = true,
    this.showKeyBoard = false,
    this.focusNode,
    this.textAlign,
    this.inputDecoration,
    this.textStyle,
    this.enabled = true,
    this.onChanged,
  }) : super(key: key);

  @override
  State<VehicleField> createState() => _VehicleFieldState();
}

class _VehicleFieldState extends State<VehicleField> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    }

    if (widget.controller != null) {
      _controller = widget.controller!;
    }

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = this._createOverlayEntry();
        Overlay.of(context)?.insert(this._overlayEntry!);
        widget.showKeyBoard = true;
      } else {
        try {
          _overlayEntry?.remove();
        } catch (e) {}
        widget.showKeyBoard = false;
      }
    });

    /// 监听内容变化
    _controller.addListener(() {
      widget.onChanged?.call(_controller.text);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    var size = renderBox?.size ?? Size.zero;
    // var offset = renderBox.localToGlobal(Offset.zero);
    double width = MediaQuery.of(context).size.width;

    print(width);

    return OverlayEntry(
        builder: (context) => Positioned(
              left: 0,
              bottom: 0,
              width: width,
              child: Material(
                  elevation: 4.0,
                  child: VehicleKeyboard(
                    _controller,
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
      style: widget.textStyle ?? TextStyle(fontSize: 14, color: Colors.black87),
      enabled: widget.enabled,
      focusNode: this._focusNode,
      controller: _controller,
      textAlign: widget.textAlign ?? TextAlign.start,
      showCursor: true,
      readOnly: true,
      decoration: widget.inputDecoration ?? InputDecoration(labelText: '请输入车牌'),
    );
  }
}
