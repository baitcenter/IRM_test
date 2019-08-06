import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';

class CalendarSelect extends StatelessWidget {
  final AppBloc appBloc;

  const CalendarSelect({Key key, this.appBloc})
      : assert(appBloc != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    appBloc.retrieveCalendars();
    return StreamedWidget(
        noDataChild: Container(color: Colors.amber),
        stream: appBloc.calendars,
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
                      appBloc.selectCalendar(snapshot.data[position]);
                      appBloc.createUserInDB();
                    },
                  );
                });
          }
          return Container(color: Colors.purple);
        });
  }
}
