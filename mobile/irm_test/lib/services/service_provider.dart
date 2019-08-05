import 'package:flutter/material.dart';
import 'package:irm_test/services.dart';

class ServiceProvider extends InheritedWidget {
  final AuthService authService;
  final CalendarService calendarService;
  final UserService userService;

  const ServiceProvider({
    Key key,
    @required this.authService,
    @required this.calendarService,
    @required this.userService,
    @required Widget child,
  })  : assert(child != null),
        assert(authService != null),
        assert(calendarService != null),
        assert(userService != null),
        super(key: key, child: child);

  static ServiceProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ServiceProvider);
  }

  @override
  bool updateShouldNotify(ServiceProvider old) {
    return true;
  }
}
