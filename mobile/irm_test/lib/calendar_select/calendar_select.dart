import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/blocs/agenda_bloc.dart';
import 'package:irm_test/blocs/bloc_provider.dart';

class CalendarSelect extends StatefulWidget {
  @override
  _CalendarSelectState createState() => _CalendarSelectState();
}

class _CalendarSelectState extends State<CalendarSelect> {
  AgendaBloc _agendaBloc;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _agendaBloc ??= BlocProvider.of(context).agendaBloc;
    _agendaBloc.retrieveCalendars();
  }

  @override
  Widget build(BuildContext context) {
    return StreamedWidget(
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
        });
  }
}
