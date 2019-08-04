import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/blocs/bloc_provider.dart';
import 'package:irm_test/blocs/calendar_bloc.dart';
import 'package:irm_test/in_app_calendar/in_app_calendar.dart';

class Agenda extends StatefulWidget {
  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  CalendarBloc _calendarBloc;
  StreamSubscription _eventsListener;
  DateTime today;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    today = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _calendarBloc ??= BlocProvider.of(context).calendarBloc;
    _calendarBloc.setToday(today);
    _eventsListener ??= _calendarBloc.events.listen((events) {
      print('events:$events');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _eventsListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamedWidget(
        stream: _calendarBloc.events,
        builder: (context, snapshot) {
          print('snapshot: ${snapshot.data}');
          return InAppCalendar(
            events: snapshot.data,
            today: today,
          );
        });
  }
}
