import 'package:flutter/material.dart';
import 'package:irm_test/app.dart';
import 'package:irm_test/blocs/app_bloc.dart';
import 'package:irm_test/blocs/bloc_provider.dart';
import 'package:irm_test/blocs/calendar_bloc.dart';
import 'package:irm_test/services.dart';

void main() {
  var authService = AuthServiceFirebase();
  //var calendarService = CalendarServiceFake();
  var calendarService = CalendarServiceBackend();
  var userService = UserServiceHttp('9994dbdf.ngrok.io', authService);
  var appBloc = AppBloc(authService, userService);
  var calendarBloc = CalendarBloc(calendarService, appBloc);

  runApp(ServiceProvider(
      authService: authService,
      calendarService: calendarService,
      userService: userService,
      child: BlocProvider(
          appBloc: appBloc, calendarBloc: calendarBloc, child: App())));
}
