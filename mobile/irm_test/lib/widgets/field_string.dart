import 'package:flutter/material.dart';

class FieldString extends StatefulWidget {
  //using "key" names for later localization
  final String hintTextKey;
  final String labelTextKey;
  final String userData;
  final Function updater;

  const FieldString(
      {Key key,
      this.hintTextKey,
      this.labelTextKey,
      this.userData,
      this.updater})
      : super(key: key);

  @override
  _FieldStringState createState() => _FieldStringState();
}

class _FieldStringState extends State<FieldString> {
  TextEditingController textController = TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textController.text = widget.userData;
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _stringField(),
    );
  }

  List<Widget> _stringField() {
    return [
      Text(widget.labelTextKey, style: TextStyle(color: Colors.red)),
      Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.blueGrey))),
        child: TextField(
            onChanged: (text) {
              widget.updater(text);
            },
            controller: textController,
            autocorrect: false,
            style: TextStyle(color: Colors.blue),
            decoration: InputDecoration(
                hintText: widget.hintTextKey,
                // hintStyle: ,
                border: InputBorder.none)),
      ),
    ];
  }
}
