import 'package:flutter/material.dart';
import 'package:irm_test/calendar/create_event/create_event.dart';
import 'package:irm_test/calendar/create_event/create_event_bloc.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';

class CreateEventBuilder {
  final BuildContext context;

  CreateEventBuilder(this.context);

  Widget make() {
    AppBloc _appBloc = BlocProvider.of(context).appBloc;
    UserService _userService = ServiceProvider.of(context).userService;
    CalendarService _calendarService =
        ServiceProvider.of(context).calendarService;
    CreateEventBloc _createEventBloc =
        CreateEventBloc(_userService, _calendarService);
    return CreateEvent(
      appBloc: _appBloc,
      createEventBloc: _createEventBloc,
    );
  }
}
