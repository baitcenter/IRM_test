import 'package:flutter/material.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';
import 'package:irm_test/widgets/field_string.dart';

class UserNameSelect extends StatefulWidget {
  @override
  _UserNameSelectState createState() => _UserNameSelectState();
}

class _UserNameSelectState extends State<UserNameSelect> {
  AppBloc _appBloc;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _appBloc ??= BlocProvider.of(context).appBloc;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Spacer(flex: 1),
            Container(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FieldString(
                  hintTextKey: 'Choose a user name',
                  labelTextKey: 'User name',
                  userData: '',
                  updater: _appBloc.updateUserName,
                ),
              ),
            ),
            _confirmButton(context),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget _confirmButton(BuildContext context) {
    return RaisedButton(
      child: Text('save user name'),
      //TO DO: prevent multiple button presses for same event
      onPressed: () {
        _appBloc.defineStep(StartUp.calendarSelect);
      },
    );
  }
}
