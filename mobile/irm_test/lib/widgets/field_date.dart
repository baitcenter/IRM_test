import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class FieldDate extends StatefulWidget {
  final String hintTextKey;
  final String labelTextKey;
  final String userData;
  final Function updater;
  final String format;
  final int controlLength;

  const FieldDate(
      {Key key,
      this.hintTextKey,
      this.labelTextKey,
      this.userData,
      this.updater,
      this.format,
      this.controlLength})
      : super(key: key);
  @override
  _FieldDateState createState() => _FieldDateState();
}

class _FieldDateState extends State<FieldDate> {
  TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = MaskedTextController(mask: widget.format);
    _controller.text = widget.userData;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _dateField(),
    );
  }

  List<Widget> _dateField() {
    return [
      Text(widget.labelTextKey, style: TextStyle(color: Colors.red)),
      Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.blueGrey))),
        child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (date) {
              print(date);
              print(date.length);
              if (date.length == widget.controlLength) {
                widget.updater(date);
              }
            },
            controller: _controller,
            autocorrect: false,
            style: TextStyle(color: Colors.blue),
            decoration: InputDecoration(
                hintText: widget.hintTextKey,
                // hintStyle:
                border: InputBorder.none)),
      ),
    ];
  }
}
