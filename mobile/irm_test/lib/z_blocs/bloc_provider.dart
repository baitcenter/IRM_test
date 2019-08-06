import 'package:flutter/material.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';

class BlocProvider extends InheritedWidget {
  final AppBloc appBloc;

  const BlocProvider({
    Key key,
    @required this.appBloc,
    @required Widget child,
  })  : assert(child != null),
        assert(appBloc != null),
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
