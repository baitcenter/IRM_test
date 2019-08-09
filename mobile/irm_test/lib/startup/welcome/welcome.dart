import 'package:flutter/material.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  AppBloc _appBloc;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _appBloc ??= BlocProvider.of(context).appBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(flex: 1),
          Container(child: Text('Welcome to irm-test-app')),
          SizedBox(
            height: 5,
          ),
          RaisedButton(
            child: Text('Get started'),
            onPressed: () {
              _appBloc.defineStep(StartUp.login);
            },
          ),
          Spacer(flex: 2),
        ],
      ),
    ));
  }
}
