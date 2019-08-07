import 'package:flutter/material.dart';
import 'package:irm_test/calendar/update_event/update_event_bloc.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';

class UpdateEvent extends StatefulWidget {
  @override
  _UpdateEventState createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
  String dropdownValue;
  UserService _userService;
  AppBloc _appBloc;
  CalendarService _calendarService;
  UpdateEventBloc _updateEventBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appBloc ??= BlocProvider.of(context).appBloc;
    _userService ??= ServiceProvider.of(context).userService;
    _calendarService ??= ServiceProvider.of(context).calendarService;
    _updateEventBloc ??= UpdateEventBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
