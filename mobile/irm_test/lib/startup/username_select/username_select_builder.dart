import 'package:flutter/material.dart';
import 'package:irm_test/startup/username_select/username_select.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';

class UserNameSelectBuilder {
  final BuildContext context;

  UserNameSelectBuilder(this.context);

  Widget make() {
    AppBloc _appBloc = BlocProvider.of(context).appBloc;
    return UserNameSelect(appBloc: _appBloc);
  }
}
