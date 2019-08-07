import 'package:flutter/material.dart';
import 'package:irm_test/app.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';
import 'package:irm_test/services.dart';

void main() {
  var authService = AuthServiceFirebase();
  //var calendarService = CalendarServiceFake();
  var calendarService = CalendarServiceBackend('146d1318.ngrok.io');
  var userService = UserServiceHttp('146d1318.ngrok.io', authService);
  var appBloc = AppBloc(authService, userService);

  runApp(ServiceProvider(
      authService: authService,
      calendarService: calendarService,
      userService: userService,
      child: BlocProvider(appBloc: appBloc, child: App())));
}
