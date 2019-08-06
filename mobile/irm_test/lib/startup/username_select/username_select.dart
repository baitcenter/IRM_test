import 'package:flutter/material.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';
import 'package:irm_test/widgets/field_string.dart';

class UserNameSelect extends StatelessWidget {
  final AppBloc appBloc;

  const UserNameSelect({Key key, this.appBloc})
      : assert(appBloc != null),
        super(key: key);

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
                  updater: appBloc.updateUserName,
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
        appBloc.defineStep(StartUp.calendarSelect);
      },
    );
  }
}
