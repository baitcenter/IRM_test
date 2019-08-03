import 'dart:async';
import 'package:irm_test/services.dart';
import 'package:frideos_core/frideos_core.dart';


class AppBloc {
  final AuthService authService;

  AppBloc(this.authService) {
    authService.getCurrentUser().then((user) {
      if (user != null) {
       defineStep(StartUp.home);
      }
    });

    phoneNrStream = _phoneNr.stream.listen((phoneNr) {
      if (phoneNr.length == 12) {
        _submitPhoneButtonActive.inStream(true);
      } else {
        _submitPhoneButtonActive.inStream(false);
      }
    });

    smsStream = _sms.stream.listen((code) {
      if (code.length == 6) {
        _submitSMSButtonActive.inStream(true);
      } else {
        _submitSMSButtonActive.inStream(false);
      }
    });
  }

  StreamSubscription phoneNrStream;
  StreamSubscription smsStream;
  var _currentStep = StreamedValue<StartUp>()..inStream(StartUp.login);
  var _phoneNr = StreamedValue<String>()..inStream('');
  var _submitPhoneButtonActive = StreamedValue<bool>()..inStream(false);
  var _submitSMSButtonActive = StreamedValue<bool>()..inStream(false);
  var _verificationId = StreamedValue<String>();
  var _sms = StreamedValue<String>()..inStream('');

  Stream<bool> get submitButtonActive => _submitPhoneButtonActive.stream;

  Stream<bool> get smsButtonActive => _submitSMSButtonActive.stream;

  Stream<StartUp> get currentStep => _currentStep.outStream;


  void inputSMS(String userInput) {
    _sms.inStream(userInput);
    print('sms input');
  }

  void inputPhoneNr(String userInput) {
    _phoneNr.inStream(userInput);
    print('phone input');
  }

  ///TO DO prevent multiple clicking on button (add bool "is_loading")
  void submitPhoneNr() async {
    try {
      var verificationId =
          await authService.submitPhoneNumber(phoneNumber: _phoneNr.value);
      print('verification id received');
      _verificationId.inStream(verificationId);
      print('stream added');
      defineStep(StartUp.confirm);
    } catch (err) {
      print('shit hit the fan');
      defineStep(StartUp.login);
      return;
    }
  }

  void confirmSMSCode() async {
    try {
      await authService.confirmSMSCode(
          verificationId: _verificationId.value, smsCode: _sms.value);
      defineStep(StartUp.home);
    } catch (err) {
      print('error with confirmation code: ' + err);
    }
  }

  void defineStep(StartUp step) {
    _currentStep.inStream(step);
  }


  void signOut() {
    authService.signOut().then((_) {
      defineStep(StartUp.login);
    });
  }

  dispose() {
    phoneNrStream.cancel();
    smsStream.cancel();
    _phoneNr.dispose();
    _submitPhoneButtonActive.dispose();
    _currentStep.dispose();
    _sms.dispose();
    _submitSMSButtonActive.dispose();
    _verificationId.dispose();
  }
}
enum StartUp { login, confirm, home }


