import 'package:flutter/material.dart';

class FieldAttendee extends StatefulWidget {
  final List<String> attendees;
  final Function onChanged;
  final Function onPressed;

  const FieldAttendee(
      {Key key,
      @required this.attendees,
      @required this.onChanged,
      @required this.onPressed})
      : assert(attendees != null),
        assert(onChanged != null),
        assert(onPressed != null),
        super(key: key);
  @override
  _FieldAttendeeState createState() => _FieldAttendeeState();
}

class _FieldAttendeeState extends State<FieldAttendee> {
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
        child: Text('Attendees:'),
      ),
      DropdownButton<String>(
        items: widget.attendees.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: widget.onChanged,
      ),
      RaisedButton(
        child: Text('Add attendee'),
        onPressed: widget.onPressed,
      ),
    ]);
  }
}
