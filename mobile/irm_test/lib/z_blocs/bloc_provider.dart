import 'package:flutter/material.dart';
import 'package:irm_test/z_blocs/agenda_bloc.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';

class BlocProvider extends InheritedWidget {
  final AppBloc appBloc;
  final AgendaBloc agendaBloc;

  const BlocProvider({
    Key key,
    @required this.appBloc,
    @required this.agendaBloc,
    @required Widget child,
  })  : assert(child != null),
        assert(appBloc != null),
        assert(agendaBloc != null),
        super(key: key, child: child);

  static BlocProvider of(BuildContext context) {
    return context
        .ancestorInheritedElementForWidgetOfExactType(BlocProvider)
        .widget;
  }

  @override
  bool updateShouldNotify(BlocProvider old) {
    return true;
  }
}
