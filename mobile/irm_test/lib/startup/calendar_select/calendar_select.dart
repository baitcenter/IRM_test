import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';

class CalendarSelect extends StatefulWidget {
  @override
  _CalendarSelectState createState() => _CalendarSelectState();
}

class _CalendarSelectState extends State<CalendarSelect> {
  AppBloc _appBloc;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _appBloc ??= BlocProvider.of(context).appBloc;
    _appBloc.retrieveCalendars();
  }

  @override
  Widget build(BuildContext context) {
    return StreamedWidget(
        noDataChild: Container(color: Colors.amber),
        stream: _appBloc.calendars,
        builder: (context, snapshot) {
          if (snapshot.data.length != 0) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, position) {
                  return RawMaterialButton(
                    fillColor: Colors.pink,
                    child: Text(
                      snapshot.data[position].name,
                    ),
                    onPressed: () {
                      //TO DO : save name and Calendar to DB
                      _appBloc.selectCalendar(snapshot.data[position]);
                      _appBloc.createUserInDB();
                    },
                  );
                });
          }
          return Container(color: Colors.purple);
        });
  }
}
