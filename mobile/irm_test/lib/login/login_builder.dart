import 'package:flutter/material.dart';
import 'package:irm_test/blocs/app_bloc.dart';
import 'package:irm_test/blocs/bloc_provider.dart';
import 'package:irm_test/login/login_screen.dart';

class LoginPageBuilder {
  final LoginSteps step;
  final BuildContext context;

  LoginPageBuilder({this.context, this.step});

  Widget make() {
    AppBloc appBloc = BlocProvider.of(context).appBloc;
    Widget loginScreen;
    switch (step) {
      case LoginSteps.phone:
        loginScreen = LoginScreen(
            submitButtonStream: appBloc.submitButtonActive,
            inputData: appBloc.inputPhoneNr,
            submitData: appBloc.submitPhoneNr,
            hintText: 'Input phone number');
        break;
      case LoginSteps.sms:
        loginScreen = LoginScreen(
          submitButtonStream: appBloc.smsButtonActive,
          inputData: appBloc.inputSMS,
          submitData: appBloc.confirmSMSCode,
          hintText: 'Confirm SMS code',
        );
        break;
    }
    return loginScreen;
  }
}
