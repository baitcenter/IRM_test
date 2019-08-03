import 'package:flutter/material.dart';
import 'package:irm_test/app.dart';
import 'package:irm_test/app_bloc.dart';
import 'package:irm_test/bloc_provider.dart';
import 'package:irm_test/services.dart';

void main() {
  var authService = AuthServiceFirebase();
  var appBloc = AppBloc(authService);

  runApp(ServiceProvider(
      authService: authService,
      child: BlocProvider(
          appBloc:appBloc,
          child: App()))
  );
}

