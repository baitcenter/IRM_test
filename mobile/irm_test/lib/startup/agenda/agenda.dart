import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:intl/intl.dart';
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
    //today = DateTime.now();
    var now = DateTime.now();
    var nowString = DateFormat('yyyy-MM-dd').format(now);
    today = DateTime.parse(nowString + ' 12:00:00.000Z');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _agendaBloc ??= BlocProvider.of(context).agendaBloc;
    _agendaBloc.setToday(today);
    _eventsListener ??= _agendaBloc.events.listen((events) {});
  }

  @override
  void dispose() {
    _eventsListener.cancel();
    _agendaBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InAppCalendar(
      today: today,
    );
  }
}
