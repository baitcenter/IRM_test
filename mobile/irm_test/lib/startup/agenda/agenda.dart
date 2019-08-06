import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:irm_test/calendar/in_app_calendar/in_app_calendar.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/startup/agenda/agenda_bloc.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';
import 'package:irm_test/z_services/service_provider.dart';

class Agenda extends StatefulWidget {
  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  StreamSubscription _eventsListener;
  DateTime today;
  AppBloc _appBloc;
  CalendarService _calendarService;
  AgendaBloc _agendaBloc;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appBloc ??= BlocProvider.of(context).appBloc;
    _calendarService ??= ServiceProvider.of(context).calendarService;
    _agendaBloc ??= AgendaBloc(
      _calendarService,
      _appBloc,
    );
    _agendaBloc.setToday(today);
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
