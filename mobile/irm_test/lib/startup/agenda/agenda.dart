import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/calendar/in_app_calendar/in_app_calendar.dart';
import 'package:irm_test/startup/agenda/agenda_bloc.dart';

class Agenda extends StatefulWidget {
  final AgendaBloc agendaBloc;

  const Agenda({Key key, this.agendaBloc}) : super(key: key);
  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  StreamSubscription _eventsListener;
  DateTime today;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    widget.agendaBloc.setToday(today);
    _eventsListener ??= widget.agendaBloc.events.listen((events) {
      print('events:$events');
    });
  }

  @override
  void dispose() {
    _eventsListener.cancel();
    widget.agendaBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamedWidget(
        stream: widget.agendaBloc.events,
        builder: (context, snapshot) {
          return InAppCalendar(
            events: snapshot.data,
            today: today,
          );
        });
  }
}
