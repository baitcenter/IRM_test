import 'package:flutter/material.dart';
import 'package:irm_test/app.dart';
import 'package:irm_test/z_blocs/agenda_bloc.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';
import 'package:irm_test/services.dart';

void main() {
  var authService = AuthServiceFirebase();
  //var calendarService = CalendarServiceFake();
  var calendarService = CalendarServiceBackend('c9f0cde6.ngrok.io');
  var userService = UserServiceHttp('c9f0cde6.ngrok.io', authService);
  var appBloc = AppBloc(authService, userService);
  var agendaBloc = AgendaBloc(
    calendarService,
    appBloc,
  );

  runApp(ServiceProvider(
      authService: authService,
      calendarService: calendarService,
      userService: userService,
      child: BlocProvider(
          appBloc: appBloc, agendaBloc: agendaBloc, child: App())));
}
