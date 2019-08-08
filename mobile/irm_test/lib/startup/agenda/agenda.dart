import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/calendar/in_app_calendar/in_app_calendar.dart';
import 'package:irm_test/z_blocs/agenda_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';

class Agenda extends StatefulWidget {
  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  StreamSubscription _eventsListener;
  DateTime today;
  AgendaBloc _agendaBloc;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _agendaBloc ??= BlocProvider.of(context).agendaBloc;
    _agendaBloc.setToday(today);
    print('today set');
    _eventsListener ??= _agendaBloc.events.listen((events) {
      print('events:$events');
    });
  }

  @override
  void dispose() {
    _eventsListener.cancel();
    _agendaBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamedWidget(
        noDataChild: Container(color: Colors.green),
        stream: _agendaBloc.events,
        builder: (context, snapshot) {
          return InAppCalendar(
            events: snapshot.data,
            today: today,
          );
        });
  }
}
