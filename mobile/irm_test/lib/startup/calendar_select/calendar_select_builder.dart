import 'package:flutter/material.dart';
import 'package:irm_test/startup/calendar_select/calendar_select.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';

class CalendarSelectBuilder {
  final BuildContext context;

  CalendarSelectBuilder(this.context);

  Widget make() {
    AppBloc _appBloc = BlocProvider.of(context).appBloc;
    return CalendarSelect(appBloc: _appBloc);
  }
}
