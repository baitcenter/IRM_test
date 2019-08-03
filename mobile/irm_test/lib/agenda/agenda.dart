import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/agenda/agenda_bloc.dart';
import 'package:irm_test/in_app_calendar/in_app_calendar.dart';

class Agenda extends StatefulWidget {
  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  AgendaBloc _agendaBloc;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _agendaBloc ??= AgendaBloc();
    _agendaBloc.retrieveCalendars();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _agendaBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: StreamedWidget(
            noDataChild: Container(color: Colors.amber),
            stream: _agendaBloc.calendars,
            builder: (context, snapshot) {
              print('snapshot: ${snapshot.data}');
              if (snapshot.data.length != 0) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length ?? 1,
                    itemBuilder: (context, position) {
                      return RawMaterialButton(
                        fillColor: Colors.pink,
                        child: Text(
                          snapshot.data[position].name,
                        ),
                        onPressed: () {
                          _agendaBloc.selectCalendar(snapshot.data[position]);
                        },
                      );
                    });
              }
              return Container(color: Colors.purple);
            },
          ),
        ),
        SizedBox(height: 20),
        StreamedWidget(
            stream: _agendaBloc.selectedCalendar,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text(snapshot.data.name,
                            style: TextStyle(color: Colors.black)),
                      ),
                      Spacer(),
                      RawMaterialButton(
                        child: Text('add Event'),
                        fillColor: Colors.blue,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              );
            }),
        Expanded(flex: 3, child: InAppCalendar()),
      ],
    );
  }
}
