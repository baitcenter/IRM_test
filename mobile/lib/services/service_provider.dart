import 'package:flutter/material.dart';
import 'package:irm_test/services.dart';

class ServiceProvider extends InheritedWidget{
  final AuthService authService;

  const ServiceProvider({
    Key key,
    @required this.authService,
    @required Widget child,
  })  : assert(child!=null),
        assert (authService!=null),
        super (key:key, child: child);

  static ServiceProvider of(BuildContext context){
    return context.inheritFromWidgetOfExactType(ServiceProvider);
  }

  @override
  bool updateShouldNotify(ServiceProvider old) {
    return true;
  }
}