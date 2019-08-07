import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';

class TransitionPage extends StatefulWidget {
  @override
  _TransitionPageState createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage> {
  AppBloc _appBloc;
  Calendar calendar;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _appBloc ??= BlocProvider.of(context).appBloc;
    _appBloc.checkExistingUserAndCalendar();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StreamedWidget(
            stream: _appBloc.selectedCalendar,
            builder: (context, snapshot) {
              return Container(
                  child: RawMaterialButton(
                onPressed: snapshot.data != null
                    ? () {
                        _appBloc.defineStep(StartUp.agenda);
                      }
                    : () {},
                child: Text(
                  'Go To Calendar',
                ),
              ));
            }),
        RaisedButton(
          child: Text('sign out'),
          onPressed: _appBloc.signOut,
        ),
      ],
    );
  }
}
