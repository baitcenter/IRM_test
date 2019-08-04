import 'package:flutter/material.dart';
import 'package:irm_test/app.dart';
import 'package:irm_test/blocs/agenda_bloc.dart';
import 'package:irm_test/blocs/app_bloc.dart';
import 'package:irm_test/blocs/bloc_provider.dart';
import 'package:irm_test/blocs/calendar_bloc.dart';
import 'package:irm_test/services.dart';

void main() {
  var authService = AuthServiceFirebase();
  var calendarService = CalendarServiceFake();
  var agendaBloc = AgendaBloc();
  var appBloc = AppBloc(authService, agendaBloc);
  var calendarBloc = CalendarBloc(calendarService);

  runApp(ServiceProvider(
      authService: authService,
      child: BlocProvider(
          appBloc: appBloc,
          agendaBloc: agendaBloc,
          calendarBloc: calendarBloc,
          child: App())));
}
