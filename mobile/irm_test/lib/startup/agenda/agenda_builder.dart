import 'package:flutter/material.dart';
import 'package:irm_test/services.dart';
import 'package:irm_test/startup/agenda/agenda.dart';
import 'package:irm_test/startup/agenda/agenda_bloc.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';

class AgendaBuilder {
  final BuildContext context;

  AgendaBuilder(this.context);

  Widget make() {
    AppBloc _appBloc = BlocProvider.of(context).appBloc;
    CalendarService _calendarService =
        ServiceProvider.of(context).calendarService;
    AgendaBloc _agendaBloc = AgendaBloc(
      _calendarService,
      _appBloc,
    );
    return Agenda(agendaBloc: _agendaBloc);
  }
}
