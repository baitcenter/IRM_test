import 'dart:async';

import 'package:frideos_core/frideos_core.dart';
import 'package:irm_test/z_blocs/app_bloc.dart';

//manage state of login buttons
class LoginBloc {
  final AppBloc _appBloc;

  LoginBloc(this._appBloc) {
    //Small control for phone and SMS format
    phoneNrStream = _appBloc.phoneNr.listen((phoneNr) {
      if (phoneNr.length == 12) {
        _submitPhoneButtonActive.inStream(true);
      } else {
        _submitPhoneButtonActive.inStream(false);
      }
    });

    smsStream = _appBloc.sms.listen((code) {
      if (code.length == 6) {
        _submitSMSButtonActive.inStream(true);
      } else {
        _submitSMSButtonActive.inStream(false);
      }
    });
  }

  StreamSubscription phoneNrStream;
  StreamSubscription smsStream;
  var _submitPhoneButtonActive = StreamedValue<bool>()..inStream(false);
  var _submitSMSButtonActive = StreamedValue<bool>()..inStream(false);

  Stream<bool> get submitButtonActive => _submitPhoneButtonActive.stream;

  Stream<bool> get smsButtonActive => _submitSMSButtonActive.stream;

  dispose() {
    _submitSMSButtonActive.dispose();
    _submitPhoneButtonActive.dispose();
    phoneNrStream.cancel();
    smsStream.cancel();
  }
}
