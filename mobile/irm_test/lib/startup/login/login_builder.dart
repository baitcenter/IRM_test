import 'package:flutter/material.dart';
import 'package:irm_test/startup/login/login_bloc.dart';
import 'package:irm_test/startup/login/login_screen.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';
import 'package:irm_test/z_blocs/bloc_provider.dart';

class LoginPageBuilder {
  final LoginSteps step;
  final BuildContext context;

  LoginPageBuilder({this.context, this.step});

  Widget make() {
    AppBloc appBloc = BlocProvider.of(context).appBloc;
    LoginBloc loginBloc = LoginBloc(appBloc);
    Widget loginScreen;
    switch (step) {
      case LoginSteps.phone:
        loginScreen = LoginScreen(
          submitButtonStream: loginBloc.submitButtonActive,
          inputData: appBloc.inputPhoneNr,
          submitData: appBloc.submitPhoneNr,
          hintText: 'Input phone number',
          loginBloc: loginBloc,
        );
        break;
      case LoginSteps.sms:
        loginScreen = LoginScreen(
          submitButtonStream: loginBloc.smsButtonActive,
          inputData: appBloc.inputSMS,
          submitData: appBloc.confirmSMSCode,
          hintText: 'Confirm SMS code',
          loginBloc: loginBloc,
        );
        break;
    }
    return loginScreen;
  }
}
