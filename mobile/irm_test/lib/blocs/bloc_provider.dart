import 'package:flutter/material.dart';
import 'package:irm_test/blocs/app_bloc.dart';
import 'package:irm_test/blocs/calendar_bloc.dart';

class BlocProvider extends InheritedWidget {
  final AppBloc appBloc;
  final CalendarBloc calendarBloc;

  const BlocProvider({
    Key key,
    @required this.appBloc,
    @required this.calendarBloc,
    @required Widget child,
  })  : assert(child != null),
        assert(appBloc != null),
        assert(calendarBloc != null),
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
