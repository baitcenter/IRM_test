import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/startup/login/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  final Stream submitButtonStream;
  final Function inputData;
  final Function submitData;
  final String hintText;
  final LoginBloc loginBloc;
  const LoginScreen({
    Key key,
    this.submitButtonStream,
    this.inputData,
    this.submitData,
    this.hintText,
    this.loginBloc,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    widget.loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Spacer(flex: 1),
            Text(widget.hintText, style: TextStyle(color: Colors.orange)),
            TextField(
              controller: _textEditingController,
              onChanged: (text) {
                widget.inputData(text);
              },
            ),
            SizedBox(height: 15),
            _submitButton(),
            Spacer(flex: 1),
          ],
        ),
      ),
    ));
  }

  Widget _submitButton() {
    return StreamedWidget(
        stream: widget.submitButtonStream,
        builder: (context, snapshot) {
          return RaisedButton(
              child: Text('Submit'),
              onPressed: snapshot.data
                  ? () {
                      print('submitting ${_textEditingController.text}');
                      widget.submitData();
                      _textEditingController.clear();
                    }
                  : null);
        });
  }
}

enum LoginSteps { phone, sms }
