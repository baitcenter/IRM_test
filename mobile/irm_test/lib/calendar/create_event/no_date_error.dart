import 'package:flutter/material.dart';

class NoDateError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(flex: 1),
          Container(
            child: Text('Please fill in all date and time fields'),
          ),
          SizedBox(height: 7),
          RaisedButton(
            child: Text('Back to form'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Spacer(flex: 1),
        ],
      ),
    ));
  }
}
